import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/task_model.dart'
    as tm;
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasklist_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasktime_model.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/horizontal_task_chips_bar.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/task_details_dialog.dart';

/// "Added Tasks" from [getAllUser] / getAllJanitor: grouped by user (name + mobile),
/// each [task_times] row as a card (facility, days, time range, task chips).
///
/// When [sessionTasks], [sessionTaskBuilder], and [sessionBuddyHeader] are all set,
/// unsaved rows ([taskId] == 0) are merged **under the same buddy header** as API rows
/// (matched by janitor id); session-only buddies render after API users.
class AddedTasksFromApiCard extends StatelessWidget {
  final tm.TaskModel? model;
  final bool isLoading;
  final List<TaskDropdownModel> facilityNames;
  final ValueChanged<int> onDeleteTask;
  final VoidCallback onViewAllTasks;

  /// When false, hides the top "Added Tasks" / "View All Tasks" row (e.g. full-screen page with [AppBar]).
  final bool showInlineHeader;

  /// When false, hides the "View All Tasks" link only.
  final bool showViewAllLink;

  /// When set (e.g. 3), each user shows only this many [task_times] rows; use
  /// [onViewAllTasks] (header or per-buddy link) to see the full list.
  /// When null, every row is shown (e.g. [ViewAllAddedTasksScreen]).
  final int? maxTaskTimesPerUser;

  /// Unsaved session rows (e.g. [taskId] == 0) shown under the same "Added Tasks"
  /// card, before API-backed users — buddy header + rows built by the parent.
  /// Prefer [sessionTasks] + [sessionTaskBuilder] + [sessionBuddyHeader] so session
  /// rows merge under each janitor with API tasks (single header per buddy).
  final Widget? sessionSection;

  /// Unsaved tasks ([taskId] == 0); merged per janitor with [model] when [sessionTaskBuilder]
  /// and [sessionBuddyHeader] are set.
  final List<TaskTimeModel>? sessionTasks;

  /// One tile per session task (same card chrome as API rows).
  final Widget Function(TaskTimeModel task)? sessionTaskBuilder;

  /// Header for session-only janitors (e.g. pending buddies not yet in [model]).
  final Widget Function(int? janitorId)? sessionBuddyHeader;

  /// When true, hides "No tasks found" when API users are empty (e.g. [ViewAllAddedTasksScreen]
  /// shows session tasks in a sibling widget above this card).
  final bool suppressEmptyPlaceholder;

  static const Color _accentBlue = Color(0xFF1E7CF2);

  const AddedTasksFromApiCard({
    super.key,
    required this.model,
    required this.isLoading,
    required this.facilityNames,
    required this.onDeleteTask,
    required this.onViewAllTasks,
    this.showInlineHeader = true,
    this.showViewAllLink = true,
    this.maxTaskTimesPerUser,
    this.sessionSection,
    this.sessionTasks,
    this.sessionTaskBuilder,
    this.sessionBuddyHeader,
    this.suppressEmptyPlaceholder = false,
  });

  /// Same layout as per-buddy headers in this card (name + mobile).
  static Widget buddyNamePhoneRow({
    required String name,
    required String mobile,
  }) {
    return Row(
      children: [
        Icon(Icons.person_outline, size: 22, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name.trim(),
            style: AppTextStyle.font16.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(Icons.phone_outlined, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          mobile,
          style: AppTextStyle.font14.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  /// Week order matches [SelectDaysStartTimeCard] (Sun … Sat).
  static int weekdayOrderKey(String raw) {
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
    final s = raw.trim();
    if (s.isEmpty) return 999;
    final lower = s.toLowerCase();
    for (var i = 0; i < 7; i++) {
      if (lower == full[i].toLowerCase()) return i;
    }
    for (var i = 0; i < 7; i++) {
      if (lower == abbr[i].toLowerCase()) return i;
    }
    return 999;
  }

  static List<String> sortWeekdayList(List<String> days) {
    final out = List<String>.from(days);
    out.sort((a, b) {
      final c = weekdayOrderKey(a).compareTo(weekdayOrderKey(b));
      if (c != 0) return c;
      return a.compareTo(b);
    });
    return out;
  }

  /// Sorted Sun→Sat, abbreviated; empty [days] yields "".
  static String formatDaysAbbrevLine(List<String> days) {
    if (days.isEmpty) return '';
    return _abbrDays(days);
  }

  static String _abbrDays(List<String> names) {
    const fullToAbbr = {
      "Sunday": "Sun",
      "Monday": "Mon",
      "Tuesday": "Tue",
      "Wednesday": "Wed",
      "Thursday": "Thu",
      "Friday": "Fri",
      "Saturday": "Sat",
    };
    const abbrOut = {'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'};

    String abbreviate(String d) {
      final t = d.trim();
      final fromFull = fullToAbbr[t];
      if (fromFull != null) return fromFull;
      if (abbrOut.contains(t)) return t;
      for (final e in fullToAbbr.entries) {
        if (e.key.toLowerCase() == t.toLowerCase()) return e.value;
      }
      for (final a in abbrOut) {
        if (a.toLowerCase() == t.toLowerCase()) return a;
      }
      return d;
    }

    return sortWeekdayList(names).map(abbreviate).join(", ");
  }

  static String? _timeRange(tm.TaskTime t) {
    final s = t.startTime;
    final e = t.endTime;
    if (s == null || e == null) return null;
    final start = DateFormat('hh:mm a').format(s).toUpperCase();
    final end = DateFormat('hh:mm a').format(e).toUpperCase();
    return '$start to $end';
  }

  bool get _mergeSession =>
      sessionTasks != null &&
      sessionTaskBuilder != null &&
      sessionBuddyHeader != null;

  static List<int?> _sortJanitorKeys(Iterable<int?> keys) {
    final list = keys.toList();
    list.sort((a, b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return a.compareTo(b);
    });
    return list;
  }

  /// Session rows + API [task_times] under one header per janitor (existing or pending).
  List<Widget> _mergedJanitorBlocks() {
    final sessionByJanitor = <int?, List<TaskTimeModel>>{};
    for (final t in sessionTasks!) {
      sessionByJanitor.putIfAbsent(t.janitorId, () => []).add(t);
    }
    final apiUsers = model?.results?.data ?? [];
    final out = <Widget>[];

    for (final user in apiUsers) {
      final uid = user.id;
      final pending = uid != null ? sessionByJanitor.remove(uid) : null;
      final list = pending ?? <TaskTimeModel>[];
      final allTimes = user.taskTimes ?? [];
      if (list.isEmpty && allTimes.isEmpty) continue;

      final int? cap = maxTaskTimesPerUser;
      final bool truncated = cap != null && allTimes.length > cap;
      final List<tm.TaskTime> visibleTimes;
      if (cap != null && allTimes.length > cap) {
        visibleTimes = allTimes.take(cap).toList(growable: false);
      } else {
        visibleTimes = allTimes;
      }

      out.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buddyNamePhoneRow(
                name: user.name?.trim() ?? "",
                mobile: user.mobile ?? "",
              ),
              const SizedBox(height: 10),
              ...list.map((t) => sessionTaskBuilder!(t)),
              ...visibleTimes.map(
                (task) => _TaskTimeCard(
                  task: task,
                  facilityNames: facilityNames,
                  buddyName: user.name?.trim() ?? '',
                  buddyMobile: user.mobile ?? '',
                  onDelete: () {
                    final id = task.taskId;
                    if (id != null) onDeleteTask(id);
                  },
                ),
              ),
              if (truncated)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: onViewAllTasks,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '+${allTimes.length - visibleTimes.length} more — View all tasks',
                      style: AppTextStyle.font14.copyWith(
                        color: _accentBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    for (final k in _sortJanitorKeys(sessionByJanitor.keys)) {
      final list = sessionByJanitor[k] ?? [];
      if (list.isEmpty) continue;
      out.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sessionBuddyHeader!(k),
              const SizedBox(height: 10),
              ...list.map((t) => sessionTaskBuilder!(t)),
            ],
          ),
        ),
      );
    }

    return out;
  }

  @override
  Widget build(BuildContext context) {
    final users = model?.results?.data ?? [];
    final hasSessionMerge = _mergeSession && sessionTasks!.isNotEmpty;
    final hasApiUsers = users.isNotEmpty;

    // [ViewAllAddedTasksScreen]: skip empty chrome when only session tasks show
    // or during refresh; merged mode uses [sessionTasks] instead of [sessionSection].
    if (_mergeSession) {
      if (!hasSessionMerge && !hasApiUsers && suppressEmptyPlaceholder) {
        return const SizedBox.shrink();
      }
    } else if (sessionSection == null &&
        users.isEmpty &&
        suppressEmptyPlaceholder) {
      return const SizedBox.shrink();
    }

    return Card(
      color: const Color(0xFFF7F7F7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFDEDEDE), width: 1),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showInlineHeader) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Added Tasks",
                    style: AppTextStyle.font16w7.copyWith(
                      fontSize: (AppTextStyle.font16w7.fontSize ?? 16) + 2,
                    ),
                  ),
                  if (showViewAllLink)
                    TextButton(
                      onPressed: onViewAllTasks,
                      child: Text(
                        "View All Tasks",
                        style: AppTextStyle.font14.copyWith(
                          color: _accentBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (!_mergeSession && sessionSection != null) ...[
              sessionSection!,
              const SizedBox(height: 12),
            ],
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_mergeSession)
              ...() {
                final blocks = _mergedJanitorBlocks();
                if (blocks.isEmpty && !suppressEmptyPlaceholder) {
                  return [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "No tasks found",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ];
                }
                if (blocks.isEmpty) return <Widget>[];
                return blocks;
              }()
            else if (users.isEmpty &&
                sessionSection == null &&
                !suppressEmptyPlaceholder)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "No tasks found",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              )
            else if (users.isNotEmpty)
              ...users.expand((user) {
                final allTimes = user.taskTimes ?? [];
                if (allTimes.isEmpty) return <Widget>[];

                final int? cap = maxTaskTimesPerUser;
                final bool truncated = cap != null && allTimes.length > cap;
                final visibleTimes = truncated
                    ? allTimes.take(cap).toList(growable: false)
                    : allTimes;

                return [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buddyNamePhoneRow(
                          name: user.name?.trim() ?? "",
                          mobile: user.mobile ?? "",
                        ),
                        const SizedBox(height: 10),
                        ...visibleTimes.map((task) => _TaskTimeCard(
                              task: task,
                              facilityNames: facilityNames,
                              buddyName: user.name?.trim() ?? '',
                              buddyMobile: user.mobile ?? '',
                              onDelete: () {
                                final id = task.taskId;
                                if (id != null) onDeleteTask(id);
                              },
                            )),
                        if (truncated)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: onViewAllTasks,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                '+${allTimes.length - visibleTimes.length} more — View all tasks',
                                style: AppTextStyle.font14.copyWith(
                                  color: _accentBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ];
              }),
          ],
        ),
      ),
    );
  }
}

class _TaskTimeCard extends StatelessWidget {
  final tm.TaskTime task;
  final List<TaskDropdownModel> facilityNames;
  final VoidCallback onDelete;
  final String buddyName;
  final String buddyMobile;

  const _TaskTimeCard({
    required this.task,
    required this.facilityNames,
    required this.onDelete,
    this.buddyName = '',
    this.buddyMobile = '',
  });

  @override
  Widget build(BuildContext context) {
    final fn = task.facilityName ?? "";
    final ft = task.facilityType ?? "";
    final facilityTitleForDialog =
        [fn, ft].where((s) => s.trim().isNotEmpty).join(" · ");

    final days = task.days ?? [];
    final daysText = days.isEmpty ? "" : AddedTasksFromApiCard._abbrDays(days);
    final timeText = AddedTasksFromApiCard._timeRange(task);
    final names = normalizeTaskNamesForChips(task.taskNames);

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
          if (fn.trim().isNotEmpty)
            Text(
              fn.trim(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff1a1a1a),
              ),
            ),
          if (ft.trim().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: fn.trim().isNotEmpty ? 4 : 0),
              child: Text(
                ft.trim(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          if (fn.trim().isEmpty && ft.trim().isEmpty)
            const Text(
              "—",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff1a1a1a),
              ),
            ),
          if (daysText.isNotEmpty || (timeText != null && timeText.isNotEmpty))
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
                        if (daysText.isNotEmpty &&
                            timeText != null &&
                            timeText.isNotEmpty)
                          const SizedBox(width: 12),
                        if (timeText != null && timeText.isNotEmpty) ...[
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              timeText,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onDelete,
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
                  buddyName: buddyName,
                  buddyMobile: buddyMobile,
                  daysLabel: daysText,
                  timeRange: timeText ?? '',
                  taskNames: List<String>.from(names),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
