import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/custom_task_dropdown.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/task_buddy_card.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/select_tasks_duration_card.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/select_days_start_time_card.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/added_tasks_from_api_card.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/horizontal_task_chips_bar.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/task_details_dialog.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/view/view_all_added_tasks_screen.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_event.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_state.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/controller/dashbaord_controller.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasklist_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/model/facility_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/widget/add_time_dailog.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomTextField.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/facility_dropdown_model.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasktime_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/language_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/others/client_setup_request_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:woloo_smart_hygiene/screens/assign_screen/bloc/assign_bloc.dart';
import 'package:woloo_smart_hygiene/screens/assign_screen/bloc/assign_event.dart'
as assign_events;
import 'package:woloo_smart_hygiene/screens/assign_screen/bloc/assign_state.dart';
import 'package:woloo_smart_hygiene/screens/assign_screen/data/janitor_list_model.dart'
as assign_models;

import '../../add_facility_task/supervisor_bottom_sheet.dart';

/// Local Task Buddy row (not yet on server); shown in [TaskBuddyCard] with a negative [syntheticId].
class _PendingTaskBuddy {
  final int syntheticId;
  final String name;
  final String mobile;
  final String gender;
  final LanguageData? language;

  _PendingTaskBuddy({
    required this.syntheticId,
    required this.name,
    required this.mobile,
    required this.gender,
    this.language,
  });
}

/// Auto-formats numeric input as `HH:MM` so users type only 4 digits.
class _StartTimeAutoColonFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final clamped = digits.length > 4 ? digits.substring(0, 4) : digits;

    String formatted;
    if (clamped.length <= 2) {
      formatted = clamped;
    } else {
      formatted = '${clamped.substring(0, 2)}:${clamped.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class AssignTasksScreen extends StatefulWidget {
  final bool isClientSupervisor;
  final List<TaskDropdownModel>? facilityNames;
  final String? category;
  final FacilityDropdownModel? selectedFacility;
  final String? facilityName;
  final String? locality;
  final int? clusterId;
  final int? selectedIndex;
  final List<FacilityDropdownModel>? facilitydropdownNames;
  final Datum? existingBuddy; // For existing tasks
  final String? faciltyType;

  /// Filled when opening from [AdminBottomSheetNew] for **supervisor** (role 2) only:
  /// [nameController] / [mobileController] / [isSelfAssign]. Task Buddy uses
  /// [janNameController] / [janMobileController] separately (role 1).
  final String? initialSupervisorName;
  final String? initialSupervisorMobile;
  final bool initialIsSelfAssign;

  /// When true (e.g. Home → Add new facility → [AdminBottomSheetNew]), do not auto-select
  /// a janitor from [GetAllJanitor] unless the user picks one. If they pick an existing
  /// API janitor, we still skip [AddJanitorEvent] and use [facilityId] from [ClientSetUp]
  /// for [AssignTaskEvent] when [selectedFacility] is null.
  final bool isNewFacilitySetup;

  /// [AdminBottomSheetNew] → **Assign a Supervisor**: a new supervisor (role 2) must be
  /// registered via [AddUserEvent] after [ClientSetUp], even if a server janitor is
  /// already selected for tasks. Prevents the "AssignTask only" shortcut that skips AddUser.
  final bool requiresAddUserForNewSupervisor;

  const AssignTasksScreen({
    Key? key,
    required this.isClientSupervisor,
    this.facilityNames,
    this.category,
    this.selectedFacility,
    this.facilityName,
    this.locality,
    this.clusterId,
    this.selectedIndex,
    this.facilitydropdownNames,
    this.existingBuddy,
    this.faciltyType,
    this.initialSupervisorName,
    this.initialSupervisorMobile,
    this.initialIsSelfAssign = false,
    this.isNewFacilitySetup = false,
    this.requiresAddUserForNewSupervisor = false,
  }) : super(key: key);

  @override
  State<AssignTasksScreen> createState() => _AssignTasksScreenState();
}

class _AssignTasksScreenState extends State<AssignTasksScreen> {
  final DashBoardController dashController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final addJanitorKey = GlobalKey<FormState>();

  List<TaskDropdownModel> items = [];
  List<TaskDropdownModel> selectedTaskItems = []; // Track selected items

  List<String>? taskName = [];
  List<int>? selectedId = [];
  List<int?>? taksIds = [];
  int? estimatedTime;
  int? calculatedMinEstimatedTime =
  0; // Minimum time calculated from selected tasks
  String? estimatedTimeError; // Error message for estimated time validation
  int? len;
  TimeOfDay? shiftTime;
  String? use12hour = "00:00";
  final TextEditingController shiftTimeController = TextEditingController();
  final FocusNode shiftTimeFocusNode = FocusNode();
  bool isAM = true; // Default to AM

  bool isTaskSelected = false;
  bool isNext = false;
  List<TaskTimeModel> initialTaskTimeModel = []; // Track initial state

  List<TaskDropdownModel> facilityNames = [];

  final TextEditingController janNameController = TextEditingController();
  final TextEditingController janMobileController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController estimatedHoursController =
  TextEditingController();
  final TextEditingController estimatedMinutesController =
  TextEditingController();
  final FocusNode estimatedHoursFocusNode = FocusNode();
  final FocusNode estimatedMinutesFocusNode = FocusNode();

  List<FacilityDropdownModel> facilitydropdownNames = [];

  FacilityDropdownModel? selectedFacility;

  ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();

  int selectedIndex = -1;
  int selectedAdmin = -1;
  int selectedGender = -1;
  String? janitorGender = "";
  bool isClientSupervisor = false;
  bool canPop = true;
  bool isGender = false;
  LanguageData? selectedLanguage; // Selected language for localization
  LanguageData?
  _preservedSelectedLanguage; // Preserved language for AddJanitorEvent flow
  bool isLanguageSelected = false; // Track if language validation is needed
  List<LanguageData> languagesList = []; // List to store languages from API
  GlobalStorage globalStorage = GetIt.instance();
  bool hasCheckedSupervisor = false; // Track if API check has completed

  /// Avoid duplicate [CheckSupvisorEvent] from [initState] + [GetClient] listener.
  bool _supervisorCheckDispatched = false;

  // Task buddy selection (single janitor at a time).
  final AssignBloc _assignBloc = AssignBloc();
  bool _isJanitorListLoading = false;
  bool _hasRequestedJanitors = false;
  List<assign_models.Datum> _janitors = [];
  int? _selectedJanitorId;

  /// Prevents duplicate AddUser/AddJanitor from repeated [ClientSetUp] emissions
  /// (same facility/cluster fingerprint).
  String? _lastHandledClientSetupResultKey;

  /// Prevents double-tap on Task Buddy sheet (direct [AddUserEvent] or [ClientSetUpEvent]).
  bool _janitorSheetSubmitInFlight = false;

  /// Set when [AddUserEvent] is dispatched; used to refresh janitor lists if it fails.
  bool _addUserAwaitingResult = false;

  /// Set immediately before each [AddJanitorEvent]; cleared on [Addjanitor] success.
  /// On [DashboarError], triggers a full session reset + getAllUser refresh.
  bool _awaitingAddJanitorResult = false;

  /// After [ClientSetUp] for a **new** facility ([selectedFacility] null), allow a single
  /// rollback delete on a downstream bloc failure. Cleared after scheduling that delete,
  /// on [AssignTask] success, or after [DeltetFacility]. Prevents a loop where unrelated
  /// errors (e.g. [GetAllJanitorEvent] 400) repeatedly fire [FacilityDeleteEvent].
  bool _rollbackProvisionedNewFacilityOnBlocError = false;

  /// Task Buddies added via the sheet (Submit); each gets a unique negative [syntheticId].
  final List<_PendingTaskBuddy> _pendingTaskBuddies = [];

  /// Ordered queue: each pending buddy that has at least one unsaved task ([taskId] == 0).
  /// [AddJanitorEvent] runs once per entry, then [AssignTask] runs once with all rows.
  List<_PendingTaskBuddy> _addJanitorQueueForChain = [];
  bool _chainAddJanitorActive = false;

  /// Next synthetic id for pending buddies (…, -102, -101, -100).
  int _nextPendingSyntheticId = -100;

  /// getAllUser / [GetAllJanitorEvent] — all janitors with task_times for Added Tasks UI.
  TaskModel? _allJanitorsApiModel;
  bool _loadingAllJanitorsApi = false;
  bool _isSubmittingFullSetup = false;

  /// True when creating tasks for a newly added facility (explicit flag or empty facility list).
  late bool _isNewFacilitySetupFlow;

  Map<String, dynamic>? decodedToken;
  // Track taskId being deleted
  int? deletingTaskId;
  String facilityType = "";

  // Helper function to convert DateTime to TimeOfDay
  TimeOfDay convertToTimeOfDay(String timeString) {
    DateTime dateTime = DateTime.parse(timeString);
    return TimeOfDay.fromDateTime(dateTime);
  }

  // Helper function to convert abbreviated day names to full day names
  List<String> _convertDaysToFullNames(List<String> abbreviatedDays) {
    final Map<String, String> dayMap = {
      "Sun": "Sunday",
      "Mon": "Monday",
      "Tue": "Tuesday",
      "Wed": "Wednesday",
      "Thu": "Thursday",
      "Fri": "Friday",
      "Sat": "Saturday",
    };

    return abbreviatedDays.map((day) => dayMap[day] ?? day).toList();
  }

  /// Aligns getAllJanitor `days` strings with [_convertDaysToFullNames] so [isOverlap]
  /// day matching works when the API uses abbreviations vs the UI uses full names.
  List<String>? _normalizeApiDaysForOverlap(List<String>? raw) {
    if (raw == null || raw.isEmpty) return null;
    const full = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    const abbr = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final out = <String>[];
    for (final d in raw) {
      final t = d.trim();
      if (t.isEmpty) continue;
      final lower = t.toLowerCase();
      int? idx;
      for (var i = 0; i < 7; i++) {
        if (full[i].toLowerCase() == lower || abbr[i].toLowerCase() == lower) {
          idx = i;
          break;
        }
      }
      out.add(idx != null ? full[idx] : t);
    }
    return out.isEmpty ? null : out;
  }

  /// [GetAllJanitorEvent] `task_times` for overlap checks — these rows appear in Added
  /// Tasks but are not always copied into [dashController.taskTimeModel].
  List<TaskTimeModel> _apiTaskRowsAsModelsForJanitor(int janitorId) {
    final data = _allJanitorsApiModel?.results?.data ?? [];
    for (final d in data) {
      if (d.id != janitorId) continue;
      final times = d.taskTimes;
      if (times == null || times.isEmpty) return [];
      final out = <TaskTimeModel>[];
      for (final tt in times) {
        if (tt.startTime == null || tt.endTime == null) continue;
        out.add(
          TaskTimeModel(
            taskId: tt.taskId ?? 0,
            startTime: TimeOfDay.fromDateTime(tt.startTime!),
            endTime: TimeOfDay.fromDateTime(tt.endTime!),
            facilityName: tt.facilityName ?? '',
            facilityType: tt.facilityType ?? '',
            taskName: tt.taskNames,
            taskIds: null,
            days: _normalizeApiDaysForOverlap(tt.days),
            janitorId: janitorId,
          ),
        );
      }
      return out;
    }
    return [];
  }

  // Helper function to get days for a task from the original API response
  List<String>? _getDaysForTask(int taskId) {
    if (widget.existingBuddy?.taskTimes == null) return null;
    for (var item in widget.existingBuddy!.taskTimes!) {
      if (item.taskId == taskId) {
        return item.days;
      }
    }
    return null;
  }

  void _requestAddedTasksFromApi() {
    final idStr = globalStorage.getClientId();
    if (idStr.isEmpty) return;
    final clientId = int.tryParse(idStr);
    if (clientId == null) return;
    if (!mounted) return;
    setState(() => _loadingAllJanitorsApi = true);
    dashBoardBloc.add(GetAllJanitorEvent(clientId: clientId));
  }

  void _onDeleteAddedTaskFromApi(int taskId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              deletingTaskId = taskId;
              dashBoardBloc.add(DeleteEvent(taskId: taskId));
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _openViewAllAddedTasksScreen() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) => BlocProvider.value(
          value: dashBoardBloc,
          child: ViewAllAddedTasksScreen(
            initialModel: _allJanitorsApiModel,
            isLoading: _loadingAllJanitorsApi,
            facilityNames: facilityNames,
            onDeleteTask: _onDeleteAddedTaskFromApi,
            sessionTaskBuilder: _buildSessionUnsavedTaskRow,
            sessionBuddyHeader: (janitorId) => AddedTasksFromApiCard.buddyNamePhoneRow(
              name: _buddyNameForJanitorId(janitorId),
              mobile: _buddyMobileForJanitorId(janitorId),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // [DashBoardController.selectedDays] is app-wide GetX state; clear on entry so
    // day chips are not left highlighted from a previous screen or session.
    dashController.selectedDays.clear();

    // Set controller text immediately (doesn't trigger reactive updates)
    if (widget.existingBuddy != null) {
      janNameController.text = widget.existingBuddy!.name ?? "";
      if (widget.existingBuddy!.id != null) {
        _selectedJanitorId = widget.existingBuddy!.id;
      }
    }

    if (widget.initialSupervisorName != null &&
        widget.initialSupervisorName!.isNotEmpty) {
      nameController.text = widget.initialSupervisorName!;
    }
    if (widget.initialSupervisorMobile != null &&
        widget.initialSupervisorMobile!.isNotEmpty) {
      mobileController.text = widget.initialSupervisorMobile!;
    }
    isSelfAssign = widget.initialIsSelfAssign;

    // Defer all taskTimeModel operations until after build completes
    // This prevents setState during build errors with reactive GetX lists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        dashController.taskTimeModel.clear();
        initialTaskTimeModel.clear();
        _hydrateTaskTimeModelFromExistingBuddyWidget();
      }
    });

    // Initialize data from widget parameters (passed from home.dart)
    if (widget.selectedFacility != null) {
      selectedFacility = widget.selectedFacility;
      if (selectedFacility!.id != null && !_hasRequestedJanitors) {
        _hasRequestedJanitors = true;
        _assignBloc.add(
          assign_events.GetJanitorList(facilityId: selectedFacility!.id!),
        );
      }
    }
    if (widget.facilityName != null && widget.facilityName!.isNotEmpty) {
      facilityController.text = widget.facilityName!;
    }
    if (widget.locality != null && widget.locality!.isNotEmpty) {
      loc = widget.locality!;
    }
    if (widget.clusterId != null) {
      clusterId = widget.clusterId;
    }
    if (widget.selectedIndex != null && widget.selectedIndex! >= 0) {
      selectedIndex = widget.selectedIndex!;
    }
    if (widget.facilitydropdownNames != null &&
        widget.facilitydropdownNames!.isNotEmpty) {
      facilitydropdownNames = widget.facilitydropdownNames!;
    }
    _isNewFacilitySetupFlow =
        widget.isNewFacilitySetup || facilitydropdownNames.isEmpty;
    if (widget.faciltyType != null) {
      facilityType = widget.faciltyType!;
    }

    // Initialize with passed facilityNames if available, otherwise fetch from API
    if (widget.facilityNames != null && widget.facilityNames!.isNotEmpty) {
      facilityNames = widget.facilityNames!;
      _initDropdownItems();
    } else {
      // Fetch tasks from API
      dashBoardBloc.add(GetTaskEvent(category: widget.category ?? "Home"));
    }

    // Don't initialize from widget parameter - only use API response
    // This ensures we get the correct value from the server
    isClientSupervisor = false;

    // Client + supervisor check: start check as soon as clientId is known — do not wait
    // for [GetClient], or [hasCheckedSupervisor] stays false and "Next" never runs Sequence B.
    var token = globalStorage.getClientToken();
    if (token.isNotEmpty) {
      decodedToken = JwtDecoder.decode(token);
      dashBoardBloc.add(ClientEvent(id: decodedToken!["id"]));
      final sid = globalStorage.getClientId();
      if (sid.isNotEmpty) {
        _supervisorCheckDispatched = true;
        dashBoardBloc.add(CheckSupvisorEvent(id: int.parse(sid)));
      }
    } else {
      // If no token, try to use existing clientId from storage
      String clientId = globalStorage.getClientId();
      if (clientId.isNotEmpty) {
        _supervisorCheckDispatched = true;
        dashBoardBloc.add(CheckSupvisorEvent(id: int.parse(clientId)));
        hasCheckedSupervisor = false; // Will be set to true when API responds
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _requestAddedTasksFromApi();
        });
      } else {
        // No clientId available, mark as checked with default value
        hasCheckedSupervisor = true;
        isClientSupervisor = false; // Default to false if no clientId
      }
    }
  }

  /// Loads [widget.existingBuddy.taskTimes] into [dashController.taskTimeModel] and
  /// [initialTaskTimeModel] (call after clearing both lists).
  void _hydrateTaskTimeModelFromExistingBuddyWidget() {
    if (widget.existingBuddy == null ||
        widget.existingBuddy!.taskTimes == null ||
        widget.existingBuddy!.taskTimes!.isEmpty) {
      return;
    }
    print(
      "Loading ${widget.existingBuddy!.taskTimes!.length} existing tasks (from widget)",
    );
    for (var item in widget.existingBuddy!.taskTimes!) {
      String formattedStartDate = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(item.startTime!);
      String formattedEndDate = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(item.endTime!);

      TimeOfDay startTime = convertToTimeOfDay(formattedStartDate);
      TimeOfDay endTime = convertToTimeOfDay(formattedEndDate);

      List<int> taskIds = [];
      if (item.taskNames != null) {
        if (facilityNames.isNotEmpty) {
          for (String taskName in item.taskNames!) {
            TaskDropdownModel? taskModel = facilityNames.firstWhere(
                  (task) => task.facilityName == taskName,
              orElse: () => TaskDropdownModel(),
            );
            if (taskModel.id != null) {
              taskIds.add(taskModel.id!);
            }
          }
        }
      }

      TaskTimeModel taskModel = TaskTimeModel(
        taskId: item.taskId!,
        endTime: endTime,
        startTime: startTime,
        facilityName: item.facilityName ?? "",
        facilityType: item.facilityType ?? "",
        taskName: item.taskNames,
        taskIds: taskIds.isNotEmpty ? taskIds : null,
        days: item.days,
        janitorId: widget.existingBuddy?.id,
      );
      dashController.taskTimeModel.add(taskModel);
      initialTaskTimeModel.add(taskModel);
      print(
        "Added existing task: ${taskModel.facilityName}, taskId: ${taskModel.taskId}, taskNames: ${taskModel.taskName}, days: ${taskModel.days}",
      );
    }
    print("Total tasks loaded: ${dashController.taskTimeModel.length}");
  }

  /// After [AddJanitorEvent] fails: drop local session state and align with a fresh
  /// getAllUser ([GetAllJanitorEvent]) refresh — see [DashboarError] handler.
  void _resetAssignSessionAfterAddJanitorFailure() {
    dashController.selectedDays.clear();
    dashController.taskTimes.clear();
    dashController.taskTimeModel.clear();
    initialTaskTimeModel.clear();

    _pendingTaskBuddies.clear();
    _nextPendingSyntheticId = -100;
    _addJanitorQueueForChain = [];
    _chainAddJanitorActive = false;
    _preservedSelectedLanguage = null;
    deletingTaskId = null;

    shiftTimeController.clear();
    shiftTime = null;
    isAM = true;
    estimatedTime = null;
    estimatedTimeError = null;
    calculatedMinEstimatedTime = 0;
    _clearDurationFields();
    taskName = [];
    selectedId = [];
    taksIds = [];
    selectedTaskItems = [];
    isTaskSelected = false;
    isNext = false;
    _handleTaskSelectionChanged([]);

    _resetJanitorSheetFormFields();

    if (widget.existingBuddy != null) {
      janNameController.text = widget.existingBuddy!.name ?? "";
      _selectedJanitorId = widget.existingBuddy!.id;
    } else {
      _selectedJanitorId = null;
    }

    _hydrateTaskTimeModelFromExistingBuddyWidget();
  }

  int? clusterId;
  int? locationId;
  int? facilityId;
  bool isOpenDrop = false;

  List<TaskDropdownModel> gender = [
    TaskDropdownModel(id: 1, facilityName: "Male"),
    TaskDropdownModel(id: 1, facilityName: "Female"),
  ];

  bool isSelfAssign = false;

  final TextEditingController facilityController = TextEditingController();

  String? loc = "";
  bool isAdminSelected = false;
  String errorMessage = '';
  String erroradminMessage = '';
  String errorGenderMessage = '';

  void _updateShiftTime(String timeString) {
    if (timeString.isEmpty) {
      shiftTime = null;
      return;
    }

    // Parse HH:MM format
    List<String> parts = timeString.split(':');
    if (parts.length != 2) {
      shiftTime = null;
      return;
    }

    int? hour = int.tryParse(parts[0]);
    int? minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      shiftTime = null;
      return;
    }

    // Validate hour (1-12 for 12-hour format)
    if (hour < 1 || hour > 12) {
      shiftTime = null;
      return;
    }

    // Validate minute (0-59)
    if (minute < 0 || minute > 59) {
      shiftTime = null;
      return;
    }

    // Convert to 24-hour format
    int hour24 = hour;
    if (!isAM && hour != 12) {
      hour24 = hour + 12;
    } else if (isAM && hour == 12) {
      hour24 = 0;
    }

    shiftTime = TimeOfDay(hour: hour24, minute: minute);
  }

  void _handleShiftTimeTextChanged(String value) {
    final digitsOnly = value.replaceAll(':', '');
    if (digitsOnly.isEmpty) {
      _updateShiftTime('');
      return;
    }
    if (value.length == 5 && value.contains(':')) {
      _updateShiftTime(value);
    } else {
      shiftTime = null;
    }
  }

  int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  List<int> normalizeRange(TimeOfDay start, TimeOfDay end) {
    int s = toMinutes(start);
    int e = toMinutes(end);

    if (e <= s) {
      // Crosses midnight → extend end into next day
      e += 24 * 60;
    }

    return [s, e];
  }

  bool isOverlap(
      TimeOfDay startTime,
      TimeOfDay endTime,
      List<TaskTimeModel> tasks,
      List<String>? selectedDays,
      ) {
    final newRange = normalizeRange(startTime, endTime);

    return tasks.any((e) {
      // Check if time overlaps
      final existingRange = normalizeRange(e.startTime, e.endTime);
      bool timeOverlaps =
          newRange[0] < existingRange[1] && newRange[1] > existingRange[0];

      print("  Checking task ${e.taskId}:");
      print(
        "    Existing - Start: ${e.startTime.hour}:${e.startTime.minute}, End: ${e.endTime.hour}:${e.endTime.minute}",
      );
      print("    Existing - Days: ${e.days}");
      print("    Time overlaps: $timeOverlaps");

      if (!timeOverlaps) {
        print("    No time overlap, skipping");
        return false; // No time overlap, so no conflict
      }

      // If time overlaps, check if days overlap
      if (selectedDays == null || selectedDays.isEmpty) {
        print(
          "    WARNING: No days selected for new task - treating as conflict",
        );
        return true; // If no days selected for new task, consider it as conflict
      }

      if (e.days == null || e.days!.isEmpty) {
        print("    WARNING: Existing task has no days - treating as conflict");
        return true; // If existing task has no days, consider it as conflict
      }

      // Check if any day overlaps between new task and existing task
      // Convert both to lowercase for case-insensitive comparison
      List<String> selectedDaysLower =
      selectedDays.map((d) => d.toLowerCase()).toList();
      List<String> existingDaysLower =
      e.days!.map((d) => d.toLowerCase()).toList();
      bool daysOverlap = selectedDaysLower.any(
            (day) => existingDaysLower.contains(day),
      );

      print("    Selected days (lower): $selectedDaysLower");
      print("    Existing days (lower): $existingDaysLower");
      print("    Days overlap: $daysOverlap");
      print("    Final conflict: $daysOverlap");

      return daysOverlap; // Conflict only if both time AND days overlap
    });
  }

  void _addTask() {
    if (!_hasBuddySelectedForTasks()) {
      EasyLoading.showError("Please select a Task Buddy");
      return;
    }

    // Validate days selection first (required when adding a new task)
    if (dashController.selectedDays.isEmpty) {
      EasyLoading.showError("Please select at least one day");
      return;
    }

    // Validate estimated time first
    if (estimatedHoursController.text.trim().isNotEmpty ||
        estimatedMinutesController.text.trim().isNotEmpty) {
      _validateEstimatedDuration();
    }

    // Check if estimated time is valid
    if (!_isEstimatedTimeValid()) {
      String errorMessage =
          estimatedTimeError ?? "Please enter a valid estimated time";
      if (estimatedTime == null || estimatedTime == 0) {
        errorMessage = "Please select tasks and set estimated time";
      }

      // Show alert dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Validation Error"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Validate all required fields
    if (estimatedTime == null || estimatedTime == 0) {
      EasyLoading.showError("Please select tasks and set estimated time");
      return;
    }

    // Update shiftTime from controller if it's null
    if (shiftTime == null && shiftTimeController.text.isNotEmpty) {
      _updateShiftTime(shiftTimeController.text);
    }

    if (shiftTimeController.text.isEmpty || shiftTime == null) {
      EasyLoading.showError("Please enter valid start time");
      return;
    }

    if (taskName == null || taskName!.isEmpty) {
      EasyLoading.showError("Please add at least one task");
      return;
    }

    if (selectedId == null || selectedId!.isEmpty) {
      EasyLoading.showError("Please add at least one task");
      return;
    }

    // Calculate end time from start time + estimated time
    DateTime now = DateTime.now();
    DateTime startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      shiftTime!.hour,
      shiftTime!.minute,
    );
    DateTime endDateTime = startDateTime.add(Duration(minutes: estimatedTime!));
    TimeOfDay endTimeOfDay = TimeOfDay.fromDateTime(endDateTime);

    // Check for overlap with existing tasks (considering both time and days).
    // Include getAllJanitor rows for this buddy, not only [taskTimeModel], or API-only
    // schedules are invisible to this check and duplicates slip through.
    bool hasOverlap = false;
    final int? buddyIdForNewTask = _selectedJanitorId;
    final List<TaskTimeModel> fromController = dashController.taskTimeModel
        .where((t) => t.janitorId == buddyIdForNewTask)
        .toList();
    final List<TaskTimeModel> fromApi =
        buddyIdForNewTask != null && buddyIdForNewTask > 0
            ? _apiTaskRowsAsModelsForJanitor(buddyIdForNewTask)
            : <TaskTimeModel>[];
    final List<TaskTimeModel> tasksForSameBuddy = [
      ...fromController,
      ...fromApi,
    ];

    if (tasksForSameBuddy.isNotEmpty) {
      // Get selected days (convert abbreviated to full names if needed)
      List<String> selectedDays = _convertDaysToFullNames(
        dashController.selectedDays.toList(),
      );

      print("=== Overlap Check ===");
      print(
        "New task - Start: ${shiftTime!.hour}:${shiftTime!.minute}, End: ${endTimeOfDay.hour}:${endTimeOfDay.minute}",
      );
      print("New task - Selected days: $selectedDays");
      print(
        "Existing tasks (same janitor $buddyIdForNewTask): ${tasksForSameBuddy.length} "
        "(controller: ${fromController.length}, api: ${fromApi.length})",
      );

      hasOverlap = isOverlap(
        shiftTime!,
        endTimeOfDay,
        tasksForSameBuddy,
        selectedDays,
      );

      print("Has overlap: $hasOverlap");
    }

    if (hasOverlap) {
      EasyLoading.showError(
        "Task already assigned for this time slot on the selected day(s)",
      );
      return;
    }

    // Get facility name and type (same sources as [_buildSessionUnsavedTaskRow]).
    // Do not shadow [facilityType] with a local empty string — that hid widget /
    // [selectedFacility?.facalityType] and left new tasks with no type in the UI.
    final String facilityNameForTask = facilityController.text.isNotEmpty
        ? facilityController.text
        : selectedFacility?.facilityName ?? "";
    final String facilityTypeForTask = facilityType.isNotEmpty
        ? facilityType
        : (selectedFacility?.facalityType ?? "");

    // Format dates for API
    String formattedStartDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(startDateTime);
    String formattedEndDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(endDateTime);

    // Add to taskTimeModel
    // Create copies of taskName and selectedId to prevent them from being affected
    // when the user removes tasks from the dropdown/chips later
    // Get selected days (convert abbreviated to full names)
    List<String> selectedDays = _convertDaysToFullNames(
      dashController.selectedDays.toList(),
    );

    dashController.taskTimeModel.add(
      TaskTimeModel(
        taskName: List<String>.from(taskName ?? []), // Create a copy
        taskIds: List<int>.from(selectedId ?? []), // Create a copy
        taskId: 0,
        endTime: endTimeOfDay,
        startTime: shiftTime!,
        facilityName: facilityNameForTask,
        facilityType: facilityTypeForTask,
        days: selectedDays, // Store selected days for this task
        janitorId: _selectedJanitorId,
      ),
    );

    // Add to taskTimes for API
    dashController.taskTimes.add({
      "start_time": formattedStartDate,
      "end_time": formattedEndDate,
      "estimated_time": estimatedTime.toString(),
      "task_ids": selectedId,
    });

    // Show success message
    EasyLoading.showSuccess("Task timing has been saved successfully");

    // Clear the time input
    shiftTimeController.clear();
    shiftTime = null;
    isAM = true; // Reset to AM

    // Clear selected days after adding task (this doesn't affect already added tasks
    // because each task stores its own days in TaskTimeModel.days)
    dashController.selectedDays.clear();

    setState(() {});
  }

  // Rebuild taskTimes from taskTimeModel to ensure all tasks have proper task_ids
  // If onlyNew is true, only include newly added tasks (taskId == 0).
  // days: The selected days to include in each task_time item
  // [defaultJanitorId]: applied per row only when [TaskTimeModel.janitorId] is null.
  // For template/add with tasks for multiple buddies, pass null so rows use each
  // task's stored buddy — not the current Task Buddy dropdown selection.
  List<Map<String, dynamic>> _buildTaskTimesFromModel({
    bool onlyNew = false,
    required List<String> days,
    int? defaultJanitorId,
  }) {
    List<Map<String, dynamic>> taskTimes = [];
    for (TaskTimeModel task in dashController.taskTimeModel) {
      // Skip existing tasks when we only want newly added ones
      if (onlyNew && task.taskId != 0) {
        continue;
      }
      // Only include tasks that have taskIds
      if (task.taskIds != null && task.taskIds!.isNotEmpty) {
        DateTime now = DateTime.now();
        DateTime startDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          task.startTime.hour,
          task.startTime.minute,
        );
        DateTime endDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          task.endTime.hour,
          task.endTime.minute,
        );

        String formattedStartDate = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(startDateTime);
        String formattedEndDate = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(endDateTime);

        // Calculate estimated time from start and end time
        int estimatedMinutes =
        (endDateTime.difference(startDateTime).inMinutes).abs();

        // Use days from task.days if available, otherwise use the provided days parameter
        // This ensures each task uses its own stored days, not the current selection
        List<String> daysToUse =
        (task.days != null && task.days!.isNotEmpty) ? task.days! : days;

        // New API structure: days, task_ids, estimated_time, janitor_id on each task_times item.
        // Do not replace negative (pending) row ids with [defaultJanitorId] — that would
        // attach another buddy's tasks to whoever is selected in the dropdown.
        final int? rowJanitorId = task.janitorId ?? defaultJanitorId;
        final row = <String, dynamic>{
          "days":
          daysToUse, // Use days from task if available, otherwise use provided days
          "task_ids": task.taskIds!,
          "start_time": formattedStartDate,
          "end_time": formattedEndDate,
          "estimated_time": estimatedMinutes.toString(),
        };
        if (rowJanitorId != null) {
          row["janitor_id"] = rowJanitorId;
        }
        taskTimes.add(row);
      }
    }
    return taskTimes;
  }

  bool _isValidWeekday(String day) {
    const valid = {
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    };
    return valid.contains(day);
  }

  _PendingTaskBuddy? _pendingBuddyBySyntheticId(int id) {
    for (final p in _pendingTaskBuddies) {
      if (p.syntheticId == id) return p;
    }
    return null;
  }

  ClientFullSetupRequest? _buildClientFullSetupRequest() {
    final clientId = int.tryParse(globalStorage.getClientId());
    if (clientId == null) {
      EasyLoading.showError("Invalid client id");
      return null;
    }


    final convertedDays = _convertDaysToFullNames(dashController.selectedDays.toList());
    final taskRows = _buildTaskTimesFromModel(
      onlyNew: true,
      days: convertedDays,
      defaultJanitorId: _selectedJanitorId,
    );
    if (taskRows.isEmpty) {
      EasyLoading.showError("Please add at least one task");
      return null;
    }

    final isFacilityCreation = selectedFacility == null;
    final facilityIdForExisting = selectedFacility?.id ?? facilityId;
    final clusterIdForPayload =
        selectedFacility?.clusterId ?? clusterId ?? widget.clusterId;
    String facilityRefSnapshot = "";
    if(isFacilityCreation == true) {
      final rawRef = globalStorage.getFacilityRef();

      facilityRefSnapshot =
      (rawRef == null || rawRef == "null") ? "" : rawRef;
    }
    else{
      facilityRefSnapshot = "";
    }

    if (!isFacilityCreation &&
        (facilityIdForExisting == null || clusterIdForPayload == null)) {
      EasyLoading.showError("Facility and cluster are required");
      return null;
    }

    final Set<String> templateIds = <String>{};
    final Set<String> tempIds = <String>{};
    final Map<int, String> janitorRefById = {};
    final List<TemplateTaskRequest> tasks = [];
    final List<JanitorRequest> janitors = [];
    final Map<String, Set<String>> assignmentMap = {};

    int taskCounter = 1;
    int janitorCounter = 1;

    for (final row in taskRows) {
      final taskIdsRaw = row['task_ids'];
      final daysRaw = row['days'];
      final janitorIdRaw = row['janitor_id'];
      final janitorId = janitorIdRaw is int
          ? janitorIdRaw
          : int.tryParse(janitorIdRaw?.toString() ?? '');

      if (janitorId == null) {
        EasyLoading.showError("Task Buddy mapping is missing for one or more tasks");
        return null;
      }
      final taskIds = (taskIdsRaw is List)
          ? taskIdsRaw.map((e) => int.tryParse(e.toString())).whereType<int>().toList()
          : <int>[];
      if (taskIds.isEmpty) {
        EasyLoading.showError("Task ids cannot be empty");
        return null;
      }
      final days = (daysRaw is List) ? daysRaw.map((e) => e.toString()).toList() : <String>[];
      if (days.isEmpty || days.any((d) => !_isValidWeekday(d))) {
        EasyLoading.showError("Please select valid weekdays");
        return null;
      }

      final templateId = "t$taskCounter";
      taskCounter++;
      if (!templateIds.add(templateId)) {
        EasyLoading.showError("Duplicate task template id detected");
        return null;
      }
      tasks.add(
        TemplateTaskRequest(
          templateId: templateId,
          taskIds: taskIds,
          days: days,
          startTime: row['start_time'].toString(),
          endTime: row['end_time'].toString(),
          estimatedTime: row['estimated_time'].toString(),

        ),
      );

      String? janitorRef = janitorRefById[janitorId];
      if (janitorRef == null) {
        janitorRef = "j$janitorCounter";
        janitorCounter++;
        janitorRefById[janitorId] = janitorRef;
        if (!tempIds.add(janitorRef)) {
          EasyLoading.showError("Duplicate janitor reference detected");
          return null;
        }

        if (janitorId > 0) {
          janitors.add(
            JanitorRequest(tempId: janitorRef, type: "existing", janitorId: janitorId),
          );
        } else {
          final pending = _pendingBuddyBySyntheticId(janitorId);
          if (pending == null) {
            EasyLoading.showError("Unable to map new Task Buddy details");
            return null;
          }
          janitors.add(
            JanitorRequest(
              tempId: janitorRef,
              type: "new",
              data: JanitorDataRequest(
                firstName: pending.name.trim(),
                mobile: pending.mobile.trim(),
                gender: pending.gender,
                languageCodes: pending.language?.languageCode != null
                    ? [pending.language!.languageCode!]
                    : (globalStorage.getLanguageCodes().isNotEmpty
                        ? globalStorage.getLanguageCodes()
                        : ['en']),
              ),
            ),
          );
        }
      }

      assignmentMap.putIfAbsent(janitorRef, () => <String>{}).add(templateId);
    }

    final assignments = assignmentMap.entries
        .map((e) => AssignmentRequest(janitorRef: e.key, templateRef: e.value.toList()))
        .toList();
    if (tasks.isNotEmpty && assignments.isEmpty) {
      EasyLoading.showError("At least one task assignment is required");
      return null;
    }

    final supervisorName = _addUserNameForApi();
    final supervisorMobile = int.tryParse(_addUserMobileForApi());
    final shouldCreateSupervisor =
        widget.requiresAddUserForNewSupervisor && !isSelfAssign || !isClientSupervisor;

    final shift = shiftTime ?? const TimeOfDay(hour: 12, minute: 0);
    final shiftStr = "${shift.hour.toString().padLeft(2, '0')}:${shift.minute.toString().padLeft(2, '0')}:00";
    return ClientFullSetupRequest(
      isFacilityCreation: isFacilityCreation,
      clientId: clientId,
      clusterId: clusterIdForPayload,
      facilityId: isFacilityCreation ? null : facilityIdForExisting,
      location: (loc?.isNotEmpty == true) ? loc! : (widget.locality ?? ""),
      facilityName: facilityController.text.isNotEmpty
          ? facilityController.text.trim()
          : (widget.facilityName ?? ""),
      facilityType: facilityType,
      isSupervisorCreation: shouldCreateSupervisor,
      supervisor: SupervisorRequest(
              roleId: 2,
              firstName: supervisorName ?? "",
              mobile: supervisorMobile ?? 0,
              gender: (janitorGender?.isNotEmpty == true) ? janitorGender! : "Male",
              isSelfAssign: isSelfAssign,
            ),
         // : null,
      isJanitorCreation: janitors.isNotEmpty,
      isTaskCreation: tasks.isNotEmpty,
      template: TemplateRequest(
        janitors: janitors,
        tasks: tasks,
        assignments: assignments,
        shiftTime: shiftStr,
        facilityRef: facilityRefSnapshot,
      ),
    );


  }

  /// [DashboardService.assignTask] only uses the event-level janitor id to fill
  /// `task_times` rows that omit `janitor_id`. Rows built from [TaskTimeModel] should
  /// carry each buddy's id; this returns the first row's id so the fallback matches
  /// the payload — not the Task Buddy dropdown (which may show another janitor).
  int _assignTaskEventJanitorIdFromRowsOrFallback(
    List<Map<String, dynamic>> taskTimes, {
    required int fallback,
  }) {
    for (final row in taskTimes) {
      final id = row['janitor_id'];
      if (id != null) {
        if (id is int) return id;
        return int.tryParse(id.toString()) ?? fallback;
      }
    }
    return fallback;
  }

  bool _hasTaskChanges() {
    // Only check for added tasks (taskId == 0 means newly added)
    // Check if there are any new tasks that weren't in the initial list
    for (TaskTimeModel current in dashController.taskTimeModel) {
      // If taskId is 0, it's a newly added task
      if (current.taskId == 0) {
        return true;
      }

      // Check if this task exists in initial list
      bool foundInInitial = false;
      for (TaskTimeModel initial in initialTaskTimeModel) {
        if (current.taskId == initial.taskId &&
            current.startTime.hour == initial.startTime.hour &&
            current.startTime.minute == initial.startTime.minute &&
            current.endTime.hour == initial.endTime.hour &&
            current.endTime.minute == initial.endTime.minute) {
          foundInInitial = true;
          break;
        }
      }

      // If task not found in initial list, it's a new addition
      if (!foundInInitial) {
        return true;
      }
    }

    return false; // No new tasks added
  }

  void _showFullSetupErrorPopup(String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _submitClientFullSetup() {
    if (_isSubmittingFullSetup) return;
    final request = _buildClientFullSetupRequest();
    if (request == null) return;
    _isSubmittingFullSetup = true;
    dashBoardBloc.add(SubmitClientFullSetupEvent(request: request));
  }

  void _initDropdownItems() {
    items = List.from(facilityNames);
    setState(() {});
  }

  void _handleTaskSelectionChanged(List<TaskDropdownModel> selectedItems) {
    selectedTaskItems = selectedItems;

    taskName = selectedItems.map((e) => e.facilityName ?? '').toList();
    selectedId = selectedItems.map((e) => e.id ?? 0).toList();
    len = selectedItems.length;

    List<int?> listTime = selectedItems.map((e) => e.requiredTime).toList();

    print("total time $estimatedTime");
    if (selectedItems.isEmpty) {
      estimatedTime = null;
      calculatedMinEstimatedTime = 0;
      _clearDurationFields();
    } else if (selectedItems.isNotEmpty) {
      calculatedMinEstimatedTime = listTime.reduce(
            (a, b) => (a ?? 0) + (b ?? 0),
      );
      estimatedTime = calculatedMinEstimatedTime;
      taksIds = selectedItems.map((e) => e.id).toList();
      // Only set value if it's greater than 0
      if (estimatedTime != null && estimatedTime! > 0) {
        _setDurationFieldsFromTotalMinutes(estimatedTime);
      } else {
        _clearDurationFields();
        estimatedTime = null;
      }
    }

    print("estimated $estimatedTime");
    setState(() {});
  }

  void _submitExistingBuddyTasks() {
    // For existing buddy, directly call AssignTaskEvent
    // This is similar to what happens in the AddUser listener
    if (!_isExistingApiJanitor()) {
      EasyLoading.showError("Invalid buddy information");
      return;
    }

    final int existingJanitorId = _selectedJanitorId!;

    String clientId = globalStorage.getClientId();

    if (_hasPendingSheetBuddiesWithTasks()) {
      _janitorSheetSubmitInFlight = true;
      _preservedSelectedLanguage = selectedLanguage;
      List<String>? languageCodesList;
      if (_preservedSelectedLanguage != null &&
          _preservedSelectedLanguage!.languageCode != null) {
        languageCodesList = [_preservedSelectedLanguage!.languageCode!];
        _preservedSelectedLanguage = null;
      } else {
        final codes = globalStorage.getLanguageCodes();
        languageCodesList = codes.isNotEmpty ? codes : null;
      }
      if (!_startAddJanitorRegistrationChain()) {
        _awaitingAddJanitorResult = true;
        dashBoardBloc.add(
          AddJanitorEvent(
            mobile: janMobileController.text,
            name: janNameController.text,
            gender: janitorGender,
            roleId: "1",
            clientId: clientId,
            clusterId: [
              clusterId ?? selectedFacility!.clusterId ?? 0,
            ],
            languageCodes: languageCodesList,
          ),
        );
      }
      return;
    }

    // Get shift time (default to 12:00 if not set)
    shiftTime = shiftTime ?? const TimeOfDay(hour: 12, minute: 0);

    // Rebuild taskTimes from taskTimeModel - only include newly added tasks
    final convertedDays = _convertDaysToFullNames(
      dashController.selectedDays.toList(),
    );
    List<Map<String, dynamic>> rebuiltTaskTimes = _buildTaskTimesFromModel(
      onlyNew: true,
      days: convertedDays,
      // Do not default null row ids to the dropdown — tasks belong to whoever was
      // selected when each row was added ([TaskTimeModel.janitorId]).
      defaultJanitorId: null,
    );

    if (rebuiltTaskTimes.isEmpty) {
      EasyLoading.showError("Please add at least one task");
      return;
    }

    final int eventJanitorId = _assignTaskEventJanitorIdFromRowsOrFallback(
      rebuiltTaskTimes,
      fallback: existingJanitorId,
    );

    _addAssignTaskForJanitor(
      clientId: int.parse(clientId),
      shift: shiftTime!,
      taskTimes: rebuiltTaskTimes,
      janitorId: eventJanitorId,
    );
  }

  int? _parseTotalMinutesFromDurationFields() {
    final ht = estimatedHoursController.text.trim();
    final mt = estimatedMinutesController.text.trim();
    if (ht.isEmpty && mt.isEmpty) return null;
    final h = int.tryParse(ht) ?? 0;
    final m = int.tryParse(mt) ?? 0;
    return h * 60 + m;
  }

  void _clearDurationFields() {
    estimatedHoursController.clear();
    estimatedMinutesController.clear();
  }

  void _setDurationFieldsFromTotalMinutes(int? minutes) {
    if (minutes == null || minutes <= 0) {
      _clearDurationFields();
      return;
    }
    estimatedHoursController.text = (minutes ~/ 60).toString().padLeft(2, '0');
    estimatedMinutesController.text = (minutes % 60).toString().padLeft(2, '0');
  }

  void _validateEstimatedDuration() {
    final total = _parseTotalMinutesFromDurationFields();
    if (total == null) {
      estimatedTime = null;
      estimatedTimeError = null;
      setState(() {});
      return;
    }
    _validateEstimatedTimeMinutes(total);
  }

  void _validateEstimatedTimeMinutes(int parsedValue) {
    if (parsedValue <= 0) {
      estimatedTimeError = "Please enter a valid time greater than 0";
      estimatedTime = null;
      setState(() {});
      return;
    }

    // Validate minimum value (calculated from tasks)
    if (calculatedMinEstimatedTime != null &&
        calculatedMinEstimatedTime! > 0 &&
        parsedValue < calculatedMinEstimatedTime!) {
      estimatedTimeError =
      "Minimum time should be $calculatedMinEstimatedTime minutes";
      estimatedTime = parsedValue; // Store the entered value but show error
      setState(() {});
      return;
    }

    // Validate maximum value (720 minutes)
    if (parsedValue > 720) {
      estimatedTimeError = "Maximum time should be 720 minutes (12 hours)";
      estimatedTime = parsedValue; // Store the entered value but show error
      setState(() {});
      return;
    }

    // Value is valid
    estimatedTime = parsedValue;
    estimatedTimeError = null;
    setState(() {});
  }

  bool _isEstimatedTimeValid() {
    if (estimatedTime == null || estimatedTime == 0) {
      return false;
    }

    if (calculatedMinEstimatedTime != null &&
        calculatedMinEstimatedTime! > 0 &&
        estimatedTime! < calculatedMinEstimatedTime!) {
      return false;
    }

    if (estimatedTime! > 720) {
      return false;
    }

    return true;
  }

  /// [AssignTaskEvent] facility: dropdown [selectedFacility] (no `facility_ref`),
  /// else [facilityId] from [ClientSetUp] with `facility_ref`, else `facility_ref` only.
  void _addAssignTaskForJanitor({
    required int clientId,
    required TimeOfDay shift,
    required List<Map<String, dynamic>> taskTimes,
    required int janitorId,
  }) {
    final shiftStr = "${shift.hour}:${shift.minute}:00";
    final String facilityRefSnapshot = globalStorage.getFacilityRef();
    if (selectedFacility?.id != null) {
      dashBoardBloc.add(
        AssignTaskEvent(
          clientId: clientId,
          shiftTime: shiftStr,
          taskTimes: taskTimes,
          janitorId: janitorId,
          facilityId: selectedFacility!.id.toString(),
        ),
      );
    } else if (facilityId != null) {
      dashBoardBloc.add(
        AssignTaskEvent(
          clientId: clientId,
          shiftTime: shiftStr,
          taskTimes: taskTimes,
          janitorId: janitorId,
          facilityRef: facilityRefSnapshot,
          facilityId: facilityId.toString(),
        ),
      );
    } else {
      dashBoardBloc.add(
        AssignTaskEvent(
          clientId: clientId,
          shiftTime: shiftStr,
          taskTimes: taskTimes,
          janitorId: janitorId,
          facilityRef: facilityRefSnapshot,
        ),
      );
    }
    globalStorage.removeFacilityRef();
  }

  /// True if a Task Buddy was added via the sheet (pending / synthetic id) and has
  /// unsaved [taskId] == 0 rows — [AddJanitorEvent] must run before template/add,
  /// even if the dropdown currently shows a different (existing API) janitor.
  bool _hasPendingSheetBuddiesWithTasks() {
    return _pendingBuddiesWithTasksOrdered().isNotEmpty;
  }

  /// Pending sheet buddies that have at least one unsaved task tied to their [syntheticId].
  List<_PendingTaskBuddy> _pendingBuddiesWithTasksOrdered() {
    final out = <_PendingTaskBuddy>[];
    for (final p in _pendingTaskBuddies) {
      final hasTask = dashController.taskTimeModel.any(
            (t) => t.taskId == 0 && t.janitorId == p.syntheticId,
      );
      if (hasTask) {
        out.add(p);
      }
    }
    return out;
  }

  void _mergeJanitorIntoApiModel(int newId, String name, String mobile) {
    final prev = _allJanitorsApiModel;
    final list = List<Datum>.from(prev?.results?.data ?? []);
    if (!list.any((u) => u.id == newId)) {
      list.add(
        Datum(
          id: newId,
          name: name.trim(),
          mobile: mobile.trim(),
          taskTimes: const [],
        ),
      );
      _allJanitorsApiModel = TaskModel(
        success: prev?.success ?? true,
        results: Results(data: list, total: list.length),
      );
    }
  }

  void _dispatchAddJanitorForBuddy(_PendingTaskBuddy buddy) {
    List<String>? languageCodesList;
    if (buddy.language?.languageCode != null) {
      languageCodesList = [buddy.language!.languageCode!];
    } else {
      final codes = globalStorage.getLanguageCodes();
      languageCodesList = codes.isNotEmpty ? codes : null;
    }
    _awaitingAddJanitorResult = true;
    dashBoardBloc.add(
      AddJanitorEvent(
        mobile: buddy.mobile,
        name: buddy.name,
        gender: buddy.gender,
        roleId: "1",
        clientId: globalStorage.getClientId(),
        clusterId: [clusterId ?? selectedFacility?.clusterId ?? 0],
        languageCodes: languageCodesList,
      ),
    );
  }

  /// Returns true if a multi–add-janitor chain was started ([AddJanitorEvent] in flight).
  bool _startAddJanitorRegistrationChain() {
    _addJanitorQueueForChain = _pendingBuddiesWithTasksOrdered();
    if (_addJanitorQueueForChain.isEmpty) {
      return false;
    }
    _chainAddJanitorActive = true;
    _dispatchAddJanitorForBuddy(_addJanitorQueueForChain.first);
    return true;
  }

  /// When a single [AddJanitorEvent] succeeds outside the chain, [TaskTimeModel] rows may
  /// still carry negative [syntheticId] values; [_buildTaskTimesFromModel] would otherwise
  /// send them in `task_times` as `janitor_id`.
  void _remapSyntheticJanitorIdsAfterSingleAddJanitor(int newJanitorId) {
    final syntheticIds = <int>{};
    for (final t in dashController.taskTimeModel) {
      if (t.taskId == 0 &&
          t.janitorId != null &&
          t.janitorId! < 0) {
        syntheticIds.add(t.janitorId!);
      }
    }
    if (syntheticIds.isEmpty) {
      return;
    }
    for (final t in dashController.taskTimeModel) {
      if (t.taskId == 0 &&
          t.janitorId != null &&
          t.janitorId! < 0) {
        t.janitorId = newJanitorId;
      }
    }
    _pendingTaskBuddies.removeWhere((p) => syntheticIds.contains(p.syntheticId));
    if (_selectedJanitorId != null && _selectedJanitorId! < 0) {
      _selectedJanitorId = newJanitorId;
    }
  }

  void _onChainAddJanitorSuccess(int newJanitorId) {
    if (_addJanitorQueueForChain.isEmpty) {
      return;
    }
    final done = _addJanitorQueueForChain.removeAt(0);
    setState(() {
      for (final t in dashController.taskTimeModel) {
        if (t.janitorId == done.syntheticId) {
          t.janitorId = newJanitorId;
        }
      }
      _mergeJanitorIntoApiModel(newJanitorId, done.name, done.mobile);
      _pendingTaskBuddies.removeWhere((p) => p.syntheticId == done.syntheticId);
      if (_selectedJanitorId == done.syntheticId) {
        _selectedJanitorId = newJanitorId;
      }
    });
    if (_addJanitorQueueForChain.isEmpty) {
      _chainAddJanitorActive = false;
      _runAssignAfterPendingJanitors();
    } else {
      _dispatchAddJanitorForBuddy(_addJanitorQueueForChain.first);
    }
  }

  void _runAssignAfterPendingJanitors() {
    final clientId = globalStorage.getClientId();
    shiftTime = shiftTime ?? const TimeOfDay(hour: 12, minute: 0);
    final convertedDays = _convertDaysToFullNames(
      dashController.selectedDays.toList(),
    );
    final rebuiltTaskTimes = _buildTaskTimesFromModel(
      onlyNew: true,
      days: convertedDays,
      defaultJanitorId: null,
    );
    if (rebuiltTaskTimes.isEmpty) {
      EasyLoading.showError("Please add at least one task");
      _janitorSheetSubmitInFlight = false;
      return;
    }
    final int assignJanitorId = _assignTaskEventJanitorIdFromRowsOrFallback(
      rebuiltTaskTimes,
      fallback: _selectedJanitorId ?? 0,
    );
    _addAssignTaskForJanitor(
      clientId: int.parse(clientId),
      shift: shiftTime!,
      taskTimes: rebuiltTaskTimes,
      janitorId: assignJanitorId,
    );
  }

  Future<void> _showAddTimeDialog({bool isFromExisting = false}) async {
    if (estimatedTime == null) return;

    showDialog<Map<String, List<TimeOfDay>>>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AddTimeDailog(
          estimatedTime: estimatedTime!,
          startTime: shiftTime,
          endTime: use12hour,
          isFromExisting: isFromExisting,
          facalityName: facilityController.text.isNotEmpty
              ? facilityController.text
              : selectedFacility?.facilityName ?? "",
          facilityType: facilityType,

          // (selectedIndex >= 0 && selectedIndex < facility.length)
          //     ? facility[selectedIndex].title ?? ""
          //     : "",
          taskName: taskName,
          taskIds: selectedId!,
        );
      },
    ).then((value) {
      isTaskSelected = false;
      setState(() {});
    });
  }

  void _tryFetchJanitors() {
    if (_hasRequestedJanitors) return;
    final int? facilityIdForApi = selectedFacility?.id ?? facilityId;
    if (facilityIdForApi == null) return;
    _hasRequestedJanitors = true;
    _assignBloc.add(
      assign_events.GetJanitorList(facilityId: facilityIdForApi),
    );
  }

  /// [GetAllJanitorEvent] for Added Tasks + [GetJanitorList] for Task Buddy dropdown ([AssignBloc]).
  void _refreshJanitorDropdownAndServerList() {
    _requestAddedTasksFromApi();
    final int? facilityIdForApi = selectedFacility?.id ?? facilityId;
    if (facilityIdForApi != null) {
      _hasRequestedJanitors = false;
      _tryFetchJanitors();
    }
  }

  /// After [AddUserEvent] fails: same refresh as after facility rollback.
  void _refreshJanitorListsAfterAddUserFailure() {
    _refreshJanitorDropdownAndServerList();
  }

  /// Pending rows use negative ids; [TaskBuddyCard.addTaskBuddyValue] is -1.
  bool _isPendingSyntheticJanitorId(int? id) {
    return id != null && id < 0 && id != TaskBuddyCard.addTaskBuddyValue;
  }

  /// True when a server-backed janitor is selected (positive id).
  bool _isExistingApiJanitor() {
    return _selectedJanitorId != null && _selectedJanitorId! > 0;
  }

  /// True when a Task Buddy is chosen (not null, not the "Add Task Buddy" row).
  bool _hasBuddySelectedForTasks() {
    final id = _selectedJanitorId;
    if (id == null) return false;
    if (id == TaskBuddyCard.addTaskBuddyValue) return false;
    return true;
  }

  /// [AddUserEvent] name: when [isSelfAssign] (Monitor Yourself), use profile if the field is empty.
  String _addUserNameForApi() {
    if (!isSelfAssign) return nameController.text.trim();
    final n = nameController.text.trim();
    if (n.isNotEmpty) return n;
    final p = globalStorage.getProfileName().trim();
    if (p.isNotEmpty) return p;
    return 'Self';
  }

  /// [AddUserEvent] mobile: when [isSelfAssign], use stored client mobile if the field is empty.
  String _addUserMobileForApi() {
    if (!isSelfAssign) return mobileController.text.trim();
    final m = mobileController.text.trim();
    if (m.isNotEmpty) return m;
    return globalStorage.getClientMobileNo().trim();
  }

  void _resetJanitorSheetFormFields() {
    janNameController.clear();
    janMobileController.clear();
    janitorGender = '';
    selectedGender = -1;
    selectedLanguage = null;
    isGender = false;
    isLanguageSelected = false;
    addJanitorKey.currentState?.reset();
  }

  void _applyPendingToControllers(_PendingTaskBuddy p) {
    janNameController.text = p.name;
    janMobileController.text = p.mobile;
    janitorGender = p.gender;
    selectedLanguage = p.language;
  }

  void _applyApiJanitorToControllers(int janitorId) {
    for (final u in _allJanitorsApiModel?.results?.data ?? []) {
      if (u.id == janitorId) {
        janNameController.text = u.name ?? '';
        janMobileController.text = u.mobile ?? '';
        return;
      }
    }
    for (final e in _janitors) {
      if (e.id == janitorId) {
        janNameController.text = e.name ?? '';
        janMobileController.text = e.mobile ?? '';
        return;
      }
    }
  }

  String _normalizeJanitorMobileDigits(String raw) {
    return raw.replaceAll(RegExp(r'\D'), '');
  }

  /// True if [rawMobile] matches an API janitor or another pending buddy (10+ digits).
  bool _isDuplicateJanitorMobile(String rawMobile) {
    final n = _normalizeJanitorMobileDigits(rawMobile.trim());
    if (n.length < 10) return false;
    for (final u in _allJanitorsApiModel?.results?.data ?? []) {
      if (_normalizeJanitorMobileDigits(u.mobile ?? '') == n) {
        return true;
      }
    }
    for (final j in _janitors) {
      if (_normalizeJanitorMobileDigits(j.mobile ?? '') == n) {
        return true;
      }
    }
    for (final p in _pendingTaskBuddies) {
      if (_normalizeJanitorMobileDigits(p.mobile) == n) {
        return true;
      }
    }
    return false;
  }

  /// Task Buddy dropdown: getAllUser ([GetAllJanitorEvent]) plus pending sheet rows.
  List<assign_models.Datum> _janitorsForDropdown() {
    final list = <assign_models.Datum>[];
    for (final u in _allJanitorsApiModel?.results?.data ?? []) {
      if (u.id == null) continue;
      list.add(
        assign_models.Datum(
          id: u.id,
          name: u.name,
          mobile: u.mobile,
        ),
      );
    }
    final eb = widget.existingBuddy;
    if (eb?.id != null && !list.any((e) => e.id == eb!.id)) {
      list.add(
        assign_models.Datum(
          id: eb!.id,
          name: eb.name,
          mobile: eb.mobile,
        ),
      );
    }
    for (final p in _pendingTaskBuddies) {
      list.add(
        assign_models.Datum(
          id: p.syntheticId,
          name: p.name,
          mobile: p.mobile,
        ),
      );
    }
    return list;
  }

  /// Display name for a janitor id (API, pending synthetic, or [existingBuddy]).
  String _buddyNameForJanitorId(int? id) {
    if (id != null) {
      for (final d in _janitorsForDropdown()) {
        if (d.id == id) {
          final n = d.name?.trim();
          if (n != null && n.isNotEmpty) return n;
          break;
        }
      }
      if (_isPendingSyntheticJanitorId(id)) {
        final match =
        _pendingTaskBuddies.where((e) => e.syntheticId == id).toList();
        if (match.isNotEmpty) return match.first.name.trim();
      }
      if (widget.existingBuddy?.id == id) {
        final n = widget.existingBuddy?.name?.trim();
        if (n != null && n.isNotEmpty) return n;
      }
    } else {
      final typed = janNameController.text.trim();
      if (typed.isNotEmpty) return typed;
    }
    return "Unsaved tasks";
  }

  String _buddyMobileForJanitorId(int? id) {
    if (id != null && id > 0) {
      for (final d in _janitorsForDropdown()) {
        if (d.id == id) {
          final m = d.mobile?.trim();
          if (m != null && m.isNotEmpty) return m;
          break;
        }
      }
    }
    if (id != null && _isPendingSyntheticJanitorId(id)) {
      final match =
      _pendingTaskBuddies.where((e) => e.syntheticId == id).toList();
      if (match.isNotEmpty) return match.first.mobile.trim();
    }
    if (widget.existingBuddy?.id == id) {
      final m = widget.existingBuddy?.mobile?.trim();
      if (m != null && m.isNotEmpty) return m;
    }
    if (id == null) {
      final m = janMobileController.text.trim();
      if (m.isNotEmpty) return m;
    }
    return "—";
  }

  /// One header per distinct [TaskTimeModel.janitorId] for unsaved rows.
  Widget _buildSessionUnsavedTaskRow(TaskTimeModel task) {
    final String resolvedFacilityName = task.facilityName.isNotEmpty
        ? task.facilityName
        : (selectedFacility?.facilityName ??
        (facilityController.text.isNotEmpty
            ? facilityController.text
            : "Facility"));
    final String resolvedFacilityType = task.facilityType.isNotEmpty
        ? task.facilityType
        : (selectedFacility?.facalityType ?? "");
    final String facilityTitleForDialog = [
      resolvedFacilityName,
      resolvedFacilityType,
    ].where((s) => s.trim().isNotEmpty).join(" · ");

    List<String>? daysList;
    if (task.taskId != 0) {
      daysList = _getDaysForTask(task.taskId);
    } else {
      daysList = task.days;
    }
    final daysText =
        AddedTasksFromApiCard.formatDaysAbbrevLine(daysList ?? const []);

    final timeStr =
        '${task.startTime.format(context).toUpperCase()} to ${task.endTime.format(context).toUpperCase()}';
    final names = normalizeTaskNamesForChips(task.taskName);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (resolvedFacilityName.trim().isNotEmpty)
            Text(
              resolvedFacilityName.trim(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff1a1a1a),
              ),
            ),
          if (resolvedFacilityType.trim().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                top: resolvedFacilityName.trim().isNotEmpty ? 4 : 0,
              ),
              child: Text(
                resolvedFacilityType.trim(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          if (resolvedFacilityName.trim().isEmpty &&
              resolvedFacilityType.trim().isEmpty)
            const Text(
              "—",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff1a1a1a),
              ),
            ),
          if (daysText.isNotEmpty || timeStr.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (daysText.isNotEmpty) ...[
                          Image.asset(
                            AppImages.iconSelectDays,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              daysText,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4A4A4A),
                              ),
                            ),
                          ),
                        ],
                        if (daysText.isNotEmpty && timeStr.isNotEmpty)
                          const SizedBox(width: 12),
                        if (timeStr.isNotEmpty) ...[
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              timeStr,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text("Delete Task"),
                            content: const Text(
                              "Are you sure you want to delete this task?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (task.taskId != 0) {
                                    deletingTaskId = task.taskId;
                                    dashBoardBloc.add(
                                      DeleteEvent(taskId: task.taskId),
                                    );
                                  } else {
                                    dashController.taskTimeModel.remove(task);
                                  }
                                  Navigator.of(dialogContext).pop();
                                  setState(() {});
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      AppImages.iconDeleteTask,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          if (names.isNotEmpty) ...[
            const SizedBox(height: 10),
            HorizontalTaskChipsBar(
              names: names,
              facilityNames: facilityNames,
              onViewAll: () {
                showTaskDetailsDialog(
                  context,
                  facilityTitle: facilityTitleForDialog.isEmpty
                      ? '—'
                      : facilityTitleForDialog,
                  buddyName: _buddyNameForJanitorId(task.janitorId),
                  buddyMobile: _buddyMobileForJanitorId(task.janitorId),
                  daysLabel: daysText,
                  timeRange: timeStr,
                  taskNames: List<String>.from(names),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  /// API entry from bottom **Next**: [ClientSetUpEvent] when [facilitydropdownNames] is empty
  /// (new facility / no org dropdown).
  ///
  /// **Existing facility** ([selectedFacility] set, non-empty facility list): **no** [AddUserEvent].
  /// - New janitor → [AddJanitorEvent] → [AssignTask] ([Addjanitor] listener)
  /// - Existing API buddy **and** no pending sheet buddies with tasks → [AssignTask] only.
  ///   If the user added a sheet buddy then switched the dropdown to an API janitor,
  ///   [AddJanitorEvent] still runs first ([_hasPendingSheetBuddiesWithTasks]).
  ///
  /// **New facility** ([selectedFacility] null): handled in [ClientSetUp] listener — see comments there.
  void _dispatchNewBuddyUserOrClientSetup() {
    if (_janitorSheetSubmitInFlight) return;
    _janitorSheetSubmitInFlight = true;
    _preservedSelectedLanguage = selectedLanguage;

    String city = globalStorage.getCity();
    String address = "";
    String pincode = globalStorage.getPincode();
    String clientId = globalStorage.getClientId();

    if (facilitydropdownNames.isNotEmpty) {
      if (selectedFacility == null) {
        _janitorSheetSubmitInFlight = false;
        EasyLoading.showError("Please select a facility");
        return;
      }
      // Existing facility: skip AddUser — mirror former [AddUser] listener behavior.
      List<String>? languageCodesList;
      if (_preservedSelectedLanguage != null &&
          _preservedSelectedLanguage!.languageCode != null) {
        languageCodesList = [_preservedSelectedLanguage!.languageCode!];
        _preservedSelectedLanguage = null;
      } else {
        final codes = globalStorage.getLanguageCodes();
        languageCodesList = codes.isNotEmpty ? codes : null;
      }

      if (_isExistingApiJanitor() && !_hasPendingSheetBuddiesWithTasks()) {
        shiftTime = shiftTime ?? const TimeOfDay(hour: 12, minute: 0);
        final convertedDays = _convertDaysToFullNames(
          dashController.selectedDays.toList(),
        );
        final rebuiltTaskTimes = _buildTaskTimesFromModel(
          onlyNew: true,
          days: convertedDays,
          defaultJanitorId: null,
        );
        if (rebuiltTaskTimes.isEmpty) {
          EasyLoading.showError("Please add at least one task");
          _janitorSheetSubmitInFlight = false;
          return;
        }
        final int eventJanitorId = _assignTaskEventJanitorIdFromRowsOrFallback(
          rebuiltTaskTimes,
          fallback: _selectedJanitorId!,
        );
        _addAssignTaskForJanitor(
          clientId: int.parse(clientId),
          shift: shiftTime!,
          taskTimes: rebuiltTaskTimes,
          janitorId: eventJanitorId,
        );
      } else {
        // New janitor(s) from the sheet still need [AddJanitorEvent], even if the dropdown
        // was switched to an existing API buddy — same chain as [AddUser] listener.
        if (!_startAddJanitorRegistrationChain()) {
          _awaitingAddJanitorResult = true;
          dashBoardBloc.add(
            AddJanitorEvent(
              mobile: janMobileController.text,
              name: janNameController.text,
              gender: janitorGender,
              roleId: "1",
              clientId: clientId,
              clusterId: [
                clusterId ?? selectedFacility!.clusterId ?? 0,
              ],
              languageCodes: languageCodesList,
            ),
          );
        }
      }
    } else {
      String orgName = facilityController.text.isNotEmpty
          ? facilityController.text
          : widget.facilityName ?? "";
      String localityValue =
      loc?.isNotEmpty == true ? loc! : widget.locality ?? "";
      String cityValue = city.isNotEmpty ? city : globalStorage.getCity();
      String pincodeValue =
      pincode.isNotEmpty ? pincode : globalStorage.getPincode();
      String addressValue = address;
      String facilityTypeValue = facilityType;
      print(
        "ClientSetUp data - orgName: $orgName, locality: $localityValue, city: $cityValue, pincode: $pincodeValue, clusterId: $clusterId, facilityType: $facilityTypeValue",
      );
      clusterId != null
          ? dashBoardBloc.add(
        ClientSetUpEvent(
          clientId: clientId,
          orgName: orgName,
          locality: localityValue,
          pincode: pincodeValue,
          address: addressValue,
          clusterId: clusterId.toString(),
          city: cityValue,
          facilityType: facilityTypeValue,
          mobile: globalStorage.getClientMobileNo(),
        ),
      )
          : dashBoardBloc.add(
        ClientSetUpEvent(
          clientId: clientId,
          orgName: orgName,
          locality: localityValue,
          pincode: pincodeValue,
          address: addressValue,
          city: cityValue,
          clusterId: "",
          facilityType: facilityTypeValue,
          mobile: globalStorage.getClientMobileNo(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientDashBoardBloc, DashboardState>(
      bloc: dashBoardBloc,
      listenWhen: (previous, current) {
        // Ignore back-to-back duplicate ClientSetUp emissions from the bloc.
        if (current is ClientSetUp && previous is ClientSetUp) {
          return false;
        }
        return true;
      },
      listener: (context, state) {
        if (state is DashboarLoading) {
          EasyLoading.show(status: state.message);
        }
        if (state is GetTask) {
          EasyLoading.dismiss();
          facilityNames = state.tasklist;
          _initDropdownItems();

          // If we have existing tasks but facilityNames was empty before,
          // now that facilityNames is populated, reload existing tasks to map task IDs
          // Require non-empty task_times (same as initState): otherwise do not clear —
          // empty [] would wipe the list and drop locally added tasks.
          if (widget.existingBuddy != null &&
              widget.existingBuddy!.taskTimes != null &&
              widget.existingBuddy!.taskTimes!.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                dashController.taskTimeModel.clear();
                initialTaskTimeModel.clear();
                _hydrateTaskTimeModelFromExistingBuddyWidget();
              }
            });
          }
        }

        if (state is DeltetFacility) {
          EasyLoading.dismiss();
          if (selectedFacility == null) {
            locationId = null;
            clusterId = null;
            facilityId = null;
          }
          _rollbackProvisionedNewFacilityOnBlocError = false;
          _refreshJanitorDropdownAndServerList();
        }

        if (state is DashboarError) {
          EasyLoading.dismiss();
          if (_isSubmittingFullSetup) {
            _isSubmittingFullSetup = false;
            _janitorSheetSubmitInFlight = false;
            _showFullSetupErrorPopup(state.error);
            return;
          }
          final bool addJanitorFailed = _awaitingAddJanitorResult;
          if (addJanitorFailed) {
            _awaitingAddJanitorResult = false;
            _resetAssignSessionAfterAddJanitorFailure();
          }
          _janitorSheetSubmitInFlight = false;
          _chainAddJanitorActive = false;
          _addJanitorQueueForChain = [];
          // [ClientSetUp] sets [_lastHandledClientSetupResultKey]; if [AddUserEvent] /
          // [AddJanitorEvent] fails next, a retry must not hit the duplicate-key early return
          // (which would skip re-dispatching those calls).
          _lastHandledClientSetupResultKey = null;
          if (_addUserAwaitingResult) {
            _addUserAwaitingResult = false;
            _refreshJanitorListsAfterAddUserFailure();
          }
          if (addJanitorFailed && mounted) {
            setState(() {});
            _refreshJanitorDropdownAndServerList();
          } else if (_loadingAllJanitorsApi) {
            setState(() => _loadingAllJanitorsApi = false);
          } else if (mounted) {
            setState(() {});
          }
          if (!hasCheckedSupervisor) {
            hasCheckedSupervisor = true;
          }
          EasyLoading.showError(state.error);
          // Roll back provisioned facility once after [ClientSetUp] for new facility only.
          // Do not run on unrelated errors (e.g. [GetAllJanitorEvent] after refresh) or the
          // delayed delete + follow-up errors loop forever.
          final bool shouldRollbackProvisioned = _rollbackProvisionedNewFacilityOnBlocError &&
              selectedFacility == null &&
              locationId != null &&
              clusterId != null &&
              facilityId != null;
          if (shouldRollbackProvisioned) {
            _rollbackProvisionedNewFacilityOnBlocError = false;
            Future.delayed(const Duration(seconds: 1), () {
              if (!mounted) return;
              if (selectedFacility == null &&
                  locationId != null &&
                  clusterId != null &&
                  facilityId != null) {
                dashBoardBloc.add(
                  FacilityDeleteEvent(
                    locationId: locationId!,
                    clusterId: clusterId!,
                    facilityId: facilityId!,
                  ),
                );
              }
            });
          }
        }
        if (state is ClientSetupSuccess) {
          EasyLoading.dismiss();
          _isSubmittingFullSetup = false;
          _janitorSheetSubmitInFlight = false;
          globalStorage.removeFacilityRef();
          canPop = false;
          dashController.taskTimes = <Map<String, dynamic>>[].obs;
          _requestAddedTasksFromApi();
          _showSuccessDialog();
        }
        if (state is GetClient) {
          EasyLoading.dismiss();
          final clientId = globalStorage.getClientId();
          if (clientId.isNotEmpty) {
            if (!_supervisorCheckDispatched) {
              _supervisorCheckDispatched = true;
              dashBoardBloc.add(CheckSupvisorEvent(id: int.parse(clientId)));
            }
          } else if (!hasCheckedSupervisor) {
            hasCheckedSupervisor = true;
          }
          _requestAddedTasksFromApi();
        }
        if (state is GetAllJanitor) {
          EasyLoading.dismiss();
          setState(() {
            _allJanitorsApiModel = state.taskModel;
            _loadingAllJanitorsApi = false;

            final data = _allJanitorsApiModel?.results?.data ?? [];
            final apiIds = data.map((e) => e.id).whereType<int>().toSet();

            if (_selectedJanitorId != null &&
                _selectedJanitorId! > 0 &&
                !apiIds.contains(_selectedJanitorId) &&
                widget.existingBuddy?.id != _selectedJanitorId) {
              _selectedJanitorId = (!_isNewFacilitySetupFlow && data.isNotEmpty)
                  ? data.first.id
                  : null;
            }
            if (_selectedJanitorId == null &&
                widget.existingBuddy == null &&
                _pendingTaskBuddies.isEmpty &&
                data.isNotEmpty &&
                !_isNewFacilitySetupFlow) {
              _selectedJanitorId = data.first.id;
            }
          });
        }
        if (state is CheckSupervisor) {
          EasyLoading.dismiss();
          isClientSupervisor =
          state.checkSupervisorModel!.results!.isClientSupervisor!;
          hasCheckedSupervisor = true; // Mark that API check is complete
          setState(() {}); // Update UI when isClientSupervisor is set
          print("isClientSupervisor updated to: $isClientSupervisor");
        }
        if (state is ClientSetUp) {
          final setupData = state.clientSetupModel.results.data;
          final dedupeKey =
              '${setupData.facilityId}_${setupData.clusterId}_${setupData.locationId}';
          if (_lastHandledClientSetupResultKey == dedupeKey) {
            EasyLoading.dismiss();
            _janitorSheetSubmitInFlight = false;
            return;
          }
          _lastHandledClientSetupResultKey = dedupeKey;

          EasyLoading.dismiss();
          print("client setup ${isClientSupervisor}");
          String clientId = globalStorage.getClientId();

          // Call CheckSupvisorEvent again after ClientSetUp (as in home.dart)
          dashBoardBloc.add(CheckSupvisorEvent(id: int.parse(clientId)));

          // Extract locationId, facilityId, and clusterId from response
          locationId = state.clientSetupModel.results.data.locationId;
          facilityId = state.clientSetupModel.results.data.facilityId;
          clusterId = state.clientSetupModel.results.data.clusterId;
          if (selectedFacility == null) {
            _rollbackProvisionedNewFacilityOnBlocError = true;
          }

          // If facility was not available initially, request janitors now.
          _tryFetchJanitors();

          // --- New facility ([selectedFacility] null): flow matrix ---
          // Existing API buddy + !isSelfAssign → AssignTask only (unless a new supervisor
          // must be registered: [requiresAddUserForNewSupervisor] → AddUser role 2 first).
          // newFacility + isSelfAssign (Monitor Yourself) → AddUser(role 2) for new *or* existing buddy,
          // then [AddUser] listener (AssignTask if existing janitor, else AddJanitor…)
          final bool newFacility = selectedFacility == null;

          List<String>? languageCodesList;
          if (selectedLanguage != null &&
              selectedLanguage!.languageCode != null) {
            languageCodesList = [selectedLanguage!.languageCode!];
          }

          if (newFacility &&
              !isSelfAssign &&
              _isExistingApiJanitor() &&
              !widget.requiresAddUserForNewSupervisor) {
            if (_hasPendingSheetBuddiesWithTasks()) {
              if (!_startAddJanitorRegistrationChain()) {
                _awaitingAddJanitorResult = true;
                dashBoardBloc.add(
                  AddJanitorEvent(
                    mobile: janMobileController.text,
                    name: janNameController.text,
                    gender: janitorGender,
                    roleId: "1",
                    clientId: clientId,
                    clusterId: [
                      state.clientSetupModel.results.data.clusterId,
                    ],
                    languageCodes: languageCodesList,
                  ),
                );
              }
              return;
            }
            print(
              "new facility: existing API buddy, not self-assign → AssignTask only",
            );
            shiftTime = shiftTime ?? const TimeOfDay(hour: 12, minute: 0);
            final convertedDays = _convertDaysToFullNames(
              dashController.selectedDays.toList(),
            );
            final rebuiltTaskTimes = _buildTaskTimesFromModel(
              onlyNew: true,
              days: convertedDays,
              defaultJanitorId: null,
            );
            if (rebuiltTaskTimes.isEmpty) {
              EasyLoading.showError("Please add at least one task");
              _janitorSheetSubmitInFlight = false;
              return;
            }
            final int eventJanitorId = _assignTaskEventJanitorIdFromRowsOrFallback(
              rebuiltTaskTimes,
              fallback: _selectedJanitorId!,
            );
            _addAssignTaskForJanitor(
              clientId: int.parse(clientId),
              shift: shiftTime!,
              taskTimes: rebuiltTaskTimes,
              janitorId: eventJanitorId,
            );
            _janitorSheetSubmitInFlight = false;
            return;
          }

          if (newFacility && isSelfAssign) {
            print(
              "new facility, self-assign → AddUser(isSelfAssign: true)",
            );
            _addUserAwaitingResult = true;
            dashBoardBloc.add(
              AddUserEvent(
                mobile: _addUserMobileForApi(),
                name: _addUserNameForApi(),
                gender:
                janitorGender?.isNotEmpty == true ? janitorGender : null,
                roleId: "2",
                clientId: clientId,
                clusterId: [state.clientSetupModel.results.data.clusterId],
                isSelfAssign: true,
                languageCodes: languageCodesList,
              ),
            );
            return;
          }

          if (isClientSupervisor) {
            if (isSelfAssign) {
              // Monitor Yourself ([AdminBottomSheetNew] / Task Buddy): AddUser role 2,
              // then [AddUser] listener → AddJanitor — not AddJanitorEvent directly.
              print(
                "self-assign (client supervisor) → AddUser(roleId: 2, isSelfAssign)",
              );
              _addUserAwaitingResult = true;
              dashBoardBloc.add(
                AddUserEvent(
                  mobile: _addUserMobileForApi(),
                  name: _addUserNameForApi(),
                  gender:
                  janitorGender?.isNotEmpty == true ? janitorGender : null,
                  roleId: "2",
                  clientId: clientId,
                  clusterId: [state.clientSetupModel.results.data.clusterId],
                  isSelfAssign: true,
                  languageCodes: languageCodesList,
                ),
              );
            } else {
              print("call add user event");
              _addUserAwaitingResult = true;
              dashBoardBloc.add(
                AddUserEvent(
                  mobile: _addUserMobileForApi(),
                  name: _addUserNameForApi(),
                  gender:
                  janitorGender?.isNotEmpty == true ? janitorGender : null,
                  roleId: "2",
                  clientId: clientId,
                  clusterId: [state.clientSetupModel.results.data.clusterId],
                  isSelfAssign: isSelfAssign,
                  languageCodes: languageCodesList,
                ),
              );
            }
          } else {
            print("call add user event");
            _addUserAwaitingResult = true;
            dashBoardBloc.add(
              AddUserEvent(
                mobile: _addUserMobileForApi(),
                name: _addUserNameForApi(),
                gender:
                janitorGender?.isNotEmpty == true ? janitorGender : null,
                roleId: "2",
                clientId: clientId,
                clusterId: [state.clientSetupModel.results.data.clusterId],
                isSelfAssign: isSelfAssign,
                languageCodes: languageCodesList,
              ),
            );
          }
        }
        if (state is AddUser) {
          EasyLoading.dismiss();
          _addUserAwaitingResult = false;
          String clientId = globalStorage.getClientId();

          print("add user successful");

          // Existing facility + API buddy now skips AddUser ([_dispatchNewBuddyUserOrClientSetup]).
          // This branch remains for new-facility / other [AddUserEvent] sources (e.g. [ClientSetUp]).
          if (_isExistingApiJanitor()) {
            if (_hasPendingSheetBuddiesWithTasks()) {
              List<String>? languageCodesList;
              if (selectedLanguage != null &&
                  selectedLanguage!.languageCode != null) {
                languageCodesList = [selectedLanguage!.languageCode!];
              } else {
                final codes = globalStorage.getLanguageCodes();
                languageCodesList = codes.isNotEmpty ? codes : null;
              }
              if (!_startAddJanitorRegistrationChain()) {
                _awaitingAddJanitorResult = true;
                dashBoardBloc.add(
                  AddJanitorEvent(
                    mobile: janMobileController.text,
                    name: janNameController.text,
                    gender: janitorGender,
                    roleId: "1",
                    clientId: clientId,
                    clusterId: [
                      clusterId ?? selectedFacility?.clusterId ?? 0,
                    ],
                    languageCodes: languageCodesList,
                  ),
                );
              }
            } else {
              final int existingJanitorId = _selectedJanitorId!;
              shiftTime = shiftTime ?? const TimeOfDay(hour: 12, minute: 0);

              final convertedDays = _convertDaysToFullNames(
                dashController.selectedDays.toList(),
              );
              List<Map<String, dynamic>> rebuiltTaskTimes =
              _buildTaskTimesFromModel(
                onlyNew: true,
                days: convertedDays,
                defaultJanitorId: null,
              );

              final int eventJanitorId =
                  _assignTaskEventJanitorIdFromRowsOrFallback(
                rebuiltTaskTimes,
                fallback: existingJanitorId,
              );

              _addAssignTaskForJanitor(
                clientId: int.parse(clientId),
                shift: shiftTime!,
                taskTimes: rebuiltTaskTimes,
                janitorId: eventJanitorId,
              );
            }
          } else {
            // Normal flow: create new janitor
            // Use preserved selectedLanguage from dropdown if available, otherwise fall back to storage
            List<String>? languageCodesList;
            if (_preservedSelectedLanguage != null &&
                _preservedSelectedLanguage!.languageCode != null) {
              languageCodesList = [_preservedSelectedLanguage!.languageCode!];
              // Clear preserved language after use
              _preservedSelectedLanguage = null;
            } else {
              // Fall back to stored language codes if no language selected in dropdown
              List<String> languageCodes = globalStorage.getLanguageCodes();
              languageCodesList =
              languageCodes.isNotEmpty ? languageCodes : null;
            }

            if (!_startAddJanitorRegistrationChain()) {
              _awaitingAddJanitorResult = true;
              dashBoardBloc.add(
                AddJanitorEvent(
                  mobile: janMobileController.text,
                  name: janNameController.text,
                  gender: janitorGender,
                  roleId: "1",
                  clientId: clientId,
                  clusterId: [clusterId ?? selectedFacility?.clusterId ?? 0],
                  languageCodes: languageCodesList,
                ),
              );
            }
          }
        }
        if (state is Addjanitor) {
          EasyLoading.dismiss();
          _awaitingAddJanitorResult = false;
          String clientId = globalStorage.getClientId();
          final int newJanitorId = state.superVisorModel!.results!.data!.value;

          if (_chainAddJanitorActive) {
            _onChainAddJanitorSuccess(newJanitorId);
            return;
          }

          _remapSyntheticJanitorIdsAfterSingleAddJanitor(newJanitorId);

          List<int> taskIds = [];
          dashController.taskTimeModel
              .map((e) => taskIds.addAll(e.taskIds ?? []))
              .toList();

          // Keep getAllUser-shaped list in sync for the Task Buddy dropdown.
          setState(() {
            final prev = _allJanitorsApiModel;
            final list = List<Datum>.from(prev?.results?.data ?? []);
            if (!list.any((u) => u.id == newJanitorId)) {
              list.add(
                Datum(
                  id: newJanitorId,
                  name: janNameController.text.trim(),
                  mobile: janMobileController.text.trim(),
                  taskTimes: const [],
                ),
              );
              _allJanitorsApiModel = TaskModel(
                success: prev?.success ?? true,
                results: Results(data: list, total: list.length),
              );
            }
          });

          shiftTime = shiftTime ?? const TimeOfDay(hour: 12, minute: 0);

          // Rebuild taskTimes from taskTimeModel to ensure all tasks have proper task_ids
          // Convert days to full names and include in each task_time item
          final convertedDays = _convertDaysToFullNames(
            dashController.selectedDays.toList(),
          );
          List<Map<String, dynamic>> rebuiltTaskTimes =
          _buildTaskTimesFromModel(
            days: convertedDays,
            defaultJanitorId: newJanitorId,
          );

          _addAssignTaskForJanitor(
            clientId: int.parse(clientId),
            shift: shiftTime!,
            taskTimes: rebuiltTaskTimes,
            janitorId: newJanitorId,
          );
        }
        if (state is AssignTask) {
          EasyLoading.dismiss();
          _janitorSheetSubmitInFlight = false;
          _rollbackProvisionedNewFacilityOnBlocError = false;
          canPop = false;
          dashController.taskTimes = <Map<String, dynamic>>[].obs;
          _requestAddedTasksFromApi();
          _showSuccessDialog();
        }
        if (state is DeltetTaskTime) {
          EasyLoading.dismiss();
          // Find and remove the deleted task
          if (state.deleteModel != null) {
            // Remove the task that was being deleted
            if (deletingTaskId != null) {
              dashController.taskTimeModel.removeWhere(
                    (task) => task.taskId == deletingTaskId,
              );
              deletingTaskId = null;
            }
            setState(() {});
            EasyLoading.showSuccess(state.deleteModel!.results.message);
            _requestAddedTasksFromApi();
          }
        }
        if (state is GetLanguages) {
          EasyLoading.dismiss();
          languagesList = state.languageModel?.results ?? [];
        }
      },
      builder: (context, state) {
        // Don't call _initDropdownItems() here - it's already handled in listener
        // Calling it here causes setState during build error
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Assign Tasks"),
            backgroundColor: AppColors.white,
            foregroundColor: Colors.black,
            elevation: 1,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // ---------- Scrollable content ----------
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Dismiss keyboard when tapping outside
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocConsumer<AssignBloc, AssignState>(
                            bloc: _assignBloc,
                            listener: (context, assignState) {
                              if (assignState is JanitorListLoading) {
                                setState(() {
                                  _isJanitorListLoading = true;
                                });
                              } else if (assignState
                              is GetJanitorListDataSuccess) {
                                final flattened = assignState.data
                                    .expand(
                                      (m) =>
                                  m.data ??
                                      const <assign_models.Datum>[],
                                )
                                    .where((e) => e.id != null)
                                    .toList();

                                setState(() {
                                  _isJanitorListLoading = false;
                                  _janitors = flattened;
                                  // Task Buddy dropdown uses getAllUser only; do not
                                  // change selection from facility-scoped list.
                                });
                              } else if (assignState is GetJanitorListError) {
                                setState(() {
                                  _isJanitorListLoading = false;
                                  // Keep last successful janitor list; do not clear on transient errors.
                                });
                                EasyLoading.showError(
                                  assignState.error.message,
                                );
                              }
                            },
                            builder: (context, assignState) {
                              return TaskBuddyCard(
                                janitors: _janitorsForDropdown(),
                                selectedJanitorId: _selectedJanitorId,
                                isLoading: _loadingAllJanitorsApi ||
                                    _isJanitorListLoading,
                                onAddTaskBuddy: () {
                                  janitorBottomSheet();
                                },
                                onJanitorSelected: (janitorId) {
                                  setState(() {
                                    _selectedJanitorId = janitorId;
                                    if (_isPendingSyntheticJanitorId(
                                        janitorId)) {
                                      final p = _pendingTaskBuddies.firstWhere(
                                            (e) => e.syntheticId == janitorId,
                                      );
                                      _applyPendingToControllers(p);
                                    } else if (janitorId > 0) {
                                      _applyApiJanitorToControllers(janitorId);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          // ---------------- Select Tasks + duration ----------------
                          SelectTasksDurationCard(
                            taskSelector: CustomTaskDropdown(
                              items: items,
                              selectedItems: selectedTaskItems,
                              onSelectionChanged: _handleTaskSelectionChanged,
                              hintText: "Select",
                              borderRadius: 12,
                              hintTextStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff8F8F8F),
                              ),
                              selectedTextStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              fieldBoxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            hoursController: estimatedHoursController,
                            minutesController: estimatedMinutesController,
                            hoursFocusNode: estimatedHoursFocusNode,
                            minutesFocusNode: estimatedMinutesFocusNode,
                            totalMinutes: estimatedTime,
                            errorText: estimatedTimeError,
                            onDurationChanged: () {
                              estimatedTimeError = null;
                              final total =
                              _parseTotalMinutesFromDurationFields();
                              if (total != null && total > 0) {
                                estimatedTime = total;
                              } else {
                                estimatedTime = null;
                              }
                              setState(() {});
                            },
                            onDurationCommit: () {
                              _validateEstimatedDuration();
                              estimatedHoursFocusNode.unfocus();
                              estimatedMinutesFocusNode.unfocus();
                            },
                          ),

                          const SizedBox(height: 20),

                          // ---------------- Select Days & Start Time ----------------
                          SelectDaysStartTimeCard(
                            selectedDayKeys:
                            dashController.selectedDays.toList(),
                            onDayToggled: (day) {
                              setState(() {
                                if (dashController.selectedDays.contains(day)) {
                                  dashController.selectedDays.remove(day);
                                } else {
                                  dashController.selectedDays.add(day);
                                }
                              });
                            },
                            isAM: isAM,
                            onAmPmChanged: (am) {
                              setState(() {
                                isAM = am;
                              });
                              _updateShiftTime(shiftTimeController.text);
                            },
                            startTimeTextField: TextField(
                              controller: shiftTimeController,
                              focusNode: shiftTimeFocusNode,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Enter Start Time',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: AppTextStyle.font14bold,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                _StartTimeAutoColonFormatter(),
                              ],
                              onChanged: _handleShiftTimeTextChanged,
                              onSubmitted: (value) {
                                shiftTimeFocusNode.unfocus();
                                _updateShiftTime(value);
                              },
                              onEditingComplete: () {
                                shiftTimeFocusNode.unfocus();
                                _updateShiftTime(shiftTimeController.text);
                              },
                            ),
                            onAddPressed: () => _addTask(),
                          ),

                          const SizedBox(height: 20),

                          // ---------------- Added Tasks (session + getAllUser / getAllJanitor) ----------------
                          Obx(() {
                            final uniqueTasks = uniqueSessionTasksFromController(
                              dashController,
                            );

                            return AddedTasksFromApiCard(
                              model: _allJanitorsApiModel,
                              isLoading: _loadingAllJanitorsApi,
                              facilityNames: facilityNames,
                              onDeleteTask: _onDeleteAddedTaskFromApi,
                              onViewAllTasks: _openViewAllAddedTasksScreen,
                              maxTaskTimesPerUser: 3,
                              sessionTasks: uniqueTasks,
                              sessionTaskBuilder: _buildSessionUnsavedTaskRow,
                              sessionBuddyHeader: (janitorId) =>
                                  AddedTasksFromApiCard.buddyNamePhoneRow(
                                    name: _buddyNameForJanitorId(janitorId),
                                    mobile: _buddyMobileForJanitorId(janitorId),
                                  ),
                            );
                          }),

                          const SizedBox(height: 20),
                          /*   AssignSupervisorCard(
                            monitorYourself: isSelfAssign,
                            onMonitorYourselfChanged: (monitor) {
                              setState(() {
                                isSelfAssign = monitor;
                                if (monitor) {
                                  mobileController.text =
                                      globalStorage.getClientMobileNo();
                                  nameController.clear();
                                } else {
                                  nameController.clear();
                                  mobileController.clear();
                                }
                              });
                            },
                            nameController: nameController,
                            mobileController: mobileController,
                            mobileReadOnly: isSelfAssign,
                          ),*/

                          const SizedBox(height: 20),

                          estimatedTime == null && isTaskSelected
                              ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Please select Tasks",
                                  style: AppTextStyle.font12.copyWith(
                                    color: AppColors.red,
                                  ),
                                ),
                              ],
                            ),
                          )
                              : const SizedBox(),

                          dashController.taskTimeModel.isEmpty && isNext
                              ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Please add Timing for tasks",
                                  style: AppTextStyle.font12.copyWith(
                                    color: AppColors.red,
                                  ),
                                ),
                              ],
                            ),
                          )
                              : const SizedBox(),

                          const SizedBox(
                            height: 100,
                          ), // space for bottom buttons
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? MediaQuery.of(context).viewInsets.bottom + 15
                  : 15,
            ),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  isNext = true;
                  setState(() {});

                  // Validate that there are tasks to proceed with
                  if (dashController.taskTimeModel.isEmpty) {
                    EasyLoading.showError(
                      "Please add at least one task before proceeding",
                    );
                    return;
                  }

                  // For existing buddies, allow proceeding if there are any tasks (existing or new)
                  // For new buddies, check if new tasks were added
                  if (!_isExistingApiJanitor()) {
                    // For new buddies, check if any changes were made to tasks
                    if (!_hasTaskChanges()) {
                      EasyLoading.showError(
                        "Please add or modify tasks before proceeding",
                      );
                      return;
                    }
                    if (_janitorsForDropdown().isEmpty) {
                      EasyLoading.showError(
                        "Please add a Task Buddy",
                      );
                      return;
                    }
                    if (_selectedJanitorId == null) {
                      EasyLoading.showError("Please select a Task Buddy");
                      return;
                    }
                    if (_isPendingSyntheticJanitorId(_selectedJanitorId)) {
                      final match = _pendingTaskBuddies
                          .where((e) => e.syntheticId == _selectedJanitorId)
                          .toList();
                      if (match.isEmpty) {
                        EasyLoading.showError(
                          "Invalid Task Buddy selection",
                        );
                        return;
                      }
                      _applyPendingToControllers(match.first);
                    }
                    if (janNameController.text.trim().isEmpty ||
                        janMobileController.text.trim().length < 10 ||
                        janitorGender == null ||
                        janitorGender!.isEmpty ||
                        selectedLanguage == null) {
                      EasyLoading.showError(
                        "Please complete Task Buddy name, mobile, gender, and language",
                      );
                      return;
                    }
                  }

                  if (!hasCheckedSupervisor) {
                    EasyLoading.showInfo(
                      "Please wait, checking supervisor status...",
                    );
                    return;
                  }
                  _submitClientFullSetup();
                },
                child: Custombutton(
                  text: _isExistingApiJanitor() ? "Submit" : "Submit",
                  width: double.infinity,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Placeholder functions for BottomSheets
  janitorBottomSheet() {
    final void Function(void Function()) hostSetState = setState;
    final int? restoreSelectionId = _selectedJanitorId;
    _lastHandledClientSetupResultKey = null;
    _janitorSheetSubmitInFlight = false;
    _resetJanitorSheetFormFields();
    // Fetch languages when bottom sheet opens
    if (languagesList.isEmpty) {
      dashBoardBloc.add(GetLanguagesEvent());
    }
    showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              maxChildSize: 0.9,
              builder: (context, controller) {
                return Form(
                  key: addJanitorKey,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 1.75,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView(
                          controller: controller,
                          //  crossAxisAlignment: CrossAxisAlignment.start,
                          //  mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            header("Assign", "Task Buddy", ClientImages.avatar),

                            const SizedBox(height: 30),
                            CustomTextField(
                              padding: const EdgeInsets.all(0),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (p0) {},
                              controller: janNameController,
                              hintText: DashboardConst.taskBuddyName,
                              keyboardType: TextInputType.text,

                              //  maxLength: 10,
                              validator: validateName,
                              //  (value) {
                              //    if (value == null || value.isEmpty || value.length < 10) {
                              //      return "Enter a valid 10-digit number";
                              //    }
                              //    return null;
                              //  },
                              // prefixIcon: Icons.phone,
                            ),
                            const SizedBox(height: 20),

                            CustomTextField(
                              padding: const EdgeInsets.all(0),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (p0) {},
                              controller: janMobileController,
                              hintText: DashboardConst.number,
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                              maxLength: 10,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 10) {
                                  return "Enter a valid 10-digit number";
                                }
                                return null;
                              },
                              // prefixIcon: Icons.phone,
                            ),
                            const SizedBox(height: 20),

                            Text(
                              DashboardConst.gender,
                              style: AppTextStyle.font14bold.copyWith(
                                color: const Color(0xff8F8F8F),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              // flex: 2,
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              child: Center(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                  const SizedBox(width: 45),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: genderList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          selectedGender = index;
                                        });
                                        janitorGender =
                                            genderList[selectedGender].title;
                                        print("gender $janitorGender");
                                      },
                                      child: genderCard(
                                        genderList[index].image!,
                                        genderList[index].title!,
                                        index,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            janitorGender!.isEmpty && isGender
                                ? Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 10,
                              ),
                              child: Text(
                                "Please select gender",
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.red,
                                ),
                              ),
                            )
                                : const SizedBox(),

                            //  const SizedBox(height: 680/3.8),
                            // const Spacer(),
                            const SizedBox(height: 20),

                            // Language Selection Dropdown
                            Text(
                              "Select language",
                              style: AppTextStyle.font14bold.copyWith(
                                color: const Color(0xff8F8F8F),
                              ),
                            ),
                            const SizedBox(height: 10),
                            BlocConsumer<ClientDashBoardBloc, DashboardState>(
                              bloc: dashBoardBloc,
                              listener: (context, state) {
                                if (state is GetLanguages) {
                                  setModalState(() {
                                    languagesList =
                                        state.languageModel?.results ?? [];
                                  });
                                }
                              },
                              builder: (context, state) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton2<LanguageData>(
                                    isExpanded: true,
                                    hint: Text(
                                      "Select language",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    items: languagesList
                                        .map((LanguageData language) {
                                      return DropdownMenuItem<LanguageData>(
                                        value: language,
                                        child: Text(
                                          "${language.languageNameNative ?? ''} (${language.languageNameEn ?? ''})",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedLanguage,
                                    onChanged: (LanguageData? value) {
                                      setModalState(() {
                                        selectedLanguage = value;
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 55,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: AppColors.white,
                                      ),
                                    ),
                                    menuItemStyleData:
                                    const MenuItemStyleData(height: 40),
                                  ),
                                );
                              },
                            ),
                            selectedLanguage == null && isLanguageSelected
                                ? Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 10,
                              ),
                              child: Text(
                                "Please select language",
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.red,
                                ),
                              ),
                            )
                                : const SizedBox(),

                            const SizedBox(height: 20),

                            GestureDetector(
                              onTap: () async {
                                isGender = true;
                                isLanguageSelected = true;
                                setModalState(() {});

                                if (addJanitorKey.currentState!.validate() &&
                                    janitorGender!.isNotEmpty &&
                                    selectedLanguage != null) {
                                  final mobileTrim =
                                  janMobileController.text.trim();
                                  if (_isDuplicateJanitorMobile(mobileTrim)) {
                                    EasyLoading.showError(
                                      "This mobile number is already in the list",
                                    );
                                    return;
                                  }
                                  try {
                                    EasyLoading.show(
                                      status: "Checking mobile number...",
                                    );
                                    await dashBoardBloc.dashboardService
                                        .checkMobileAvailability(
                                      roleId: 1,
                                          mobile: mobileTrim,
                                        );
                                  } catch (error) {
                                    if (EasyLoading.isShow) {
                                      EasyLoading.dismiss();
                                    }
                                    final errorText = error
                                        .toString()
                                        .replaceFirst("Exception: ", "")
                                        .trim();
                                    EasyLoading.showError(errorText);
                                    return;
                                  }
                                  if (EasyLoading.isShow) {
                                    EasyLoading.dismiss();
                                  }
                                  if (!mounted) {
                                    return;
                                  }
                                  final lang = selectedLanguage;
                                  final int newId = _nextPendingSyntheticId--;
                                  hostSetState(() {
                                    _pendingTaskBuddies.add(
                                      _PendingTaskBuddy(
                                        syntheticId: newId,
                                        name: janNameController.text.trim(),
                                        mobile: janMobileController.text.trim(),
                                        gender: janitorGender ?? '',
                                        language: lang,
                                      ),
                                    );
                                    _selectedJanitorId = newId;
                                    _preservedSelectedLanguage = lang;
                                  });
                                  _resetJanitorSheetFormFields();
                                  _applyPendingToControllers(
                                    _pendingTaskBuddies.last,
                                  );
                                  Navigator.pop(context, true);
                                }
                              },
                              child: const Custombutton(
                                text: "Submit",
                                width: double.infinity,
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).then((value) {
      isGender = false;
      isLanguageSelected = false;
      if (value == true) {
        return;
      }
      // Sheet dismissed without Submit: restore selection + controllers.
      if (restoreSelectionId != null) {
        setState(() {
          _selectedJanitorId = restoreSelectionId;
          if (_isPendingSyntheticJanitorId(restoreSelectionId)) {
            final p = _pendingTaskBuddies.firstWhere(
                  (e) => e.syntheticId == restoreSelectionId,
            );
            _applyPendingToControllers(p);
          } else if (restoreSelectionId > 0) {
            _applyApiJanitorToControllers(restoreSelectionId);
          }
        });
      }
    });
  }

  Widget genderCard(String image, String title, int index) {
    return Stack(
      children: [
        Container(
          width: 131,
          height: 131,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 1, // Spread effect
                blurRadius: 10, // Blur effect
                offset: const Offset(0, 5), // Bottom shadow
              ),
            ],
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selectedGender == index
                  ? AppColors.backgroundColor
                  : AppColors.white,
            ),
          ),
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              CustomImageProvider(image: image, width: 67, height: 67),
              const SizedBox(height: 10),
              Text(
                title,
                style: AppTextStyle.font13.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greyBorder,
                ),
              ),
            ],
          ),
        ),
        selectedGender == index
            ? Positioned(
          bottom: index == 0 ? 10 : 10,
          right: index == 0 ? 0 : 0,
          // left: 100,
          child: CustomImageProvider(
            image: ClientImages.check,
            width: 20,
            height: 20,
          ),
        )
            : const SizedBox(),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            backgroundColor: AppColors.white,
            title: Center(
              child: Text(
                DashboardConst.congratulations,
                style: AppTextStyle.font20bold,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  CustomImageProvider(
                    image: ClientImages.celebration,
                    width: 145,
                    height: 145,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    textAlign: TextAlign.center,
                    "You have assigned the Task to ${janNameController.text}",
                    style: AppTextStyle.font14w7,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    textAlign: TextAlign.center,
                    "Tasks scheduled before the current time will start tracking from the next day, as today's time may have already passed at the time of assignment",
                    style: AppTextStyle.font14bold,
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) {
                            return ClientDashboard(
                              dashIndex: 0,
                              popUpMsg: "asdad",
                            );
                          },
                        ),
                        (route) => false,
                      );
                    },
                    child: Custombutton(
                      height: 30.h,
                      text: DashboardConst.noThanks,
                      width: 320.w,
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _assignBloc.close();
    estimatedHoursController.dispose();
    estimatedMinutesController.dispose();
    estimatedHoursFocusNode.dispose();
    estimatedMinutesFocusNode.dispose();
    shiftTimeController.dispose();
    shiftTimeFocusNode.dispose();
    super.dispose();
  }
}
