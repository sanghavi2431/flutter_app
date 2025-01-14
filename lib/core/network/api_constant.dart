// ignore_for_file: non_constant_identifier_names

class APIConstants {
//

//
// = "https://53f2-2409-4062-2097-da56-25a7-ecec-f87a-6912.ngrok-free.app";

  static var BASE_URL   = 'https://staging-api.woloo.in'; // QA
 // static var BASE_URL = 'https://api.woloo.in'; // Production
//  static var BASE_URL = 'http://192.168.1.103:5000'; // P
  static var SEND_OTP = '$BASE_URL/api/whms/users/sendOTP';
  static var VERIFY_OTP = '$BASE_URL/api/whms/users/verifyOTP';

  /// clock-In - clock-Out
  static var ATTENDANCE = '$BASE_URL/api/whms/users/attendance';

  /// Template List - janitor Dashboard
  static var GET_ALL_TASK_TAMPLATES = '$BASE_URL/api/whms/taskAllocation/getAllTaskByJanitorId';

  /// upload selfie
  static var UPLOAD_SELFIE = '$BASE_URL/api/whms/users/upload_image';

  /// task-list
  static var GET_ALL_TASKS = '$BASE_URL/api/whms/task/getAllTasksByTempleteId';
  static var SUBMIT_TASKS = '$BASE_URL/api/whms/users/submitTask';

  /// Status_update
  static var UPDATE_STATUS = '$BASE_URL/api/whms/users/updateStatus';

  /// Supervisor_dashboard
  static var GET_SUPERVISOR_DASHBOARD_DATA = '$BASE_URL/api/whms/users/supervisor_dashboard';

  /// issues-list
  static var GET_ALL_ISSUES = '$BASE_URL/api/whms/users/IssuesList';

  /// cluster-dropdown-list
  static var GET_CLUSTER_DROPDOWN_DATA = '$BASE_URL/api/whms/users/clusterList';

  /// facility-dropdown-list
  static var GET_FACILITIES_DROPDOWN_DATA = '$BASE_URL/api/whms/users/facilityListByClusterId';

  /// task-dropdown-list
  static var GET_TASKS_DROPDOWN_DATA = '$BASE_URL/api/whms/template/getAllTemplate';

  /// cluster-dropdown-list
  static var GET_ALL_SUBMITTED_TASK = '$BASE_URL/api/whms/users/listOfSubmitedTask';

  /// janitor-dropdown-list
  static var GET_JANITOR_DROPDOWN_DATA = '$BASE_URL/api/whms/users/getAllJanitorByClusterId';

  /// report issue
  static var REPORT_ISSUE = '$BASE_URL/api/whms/users/reportIssue';

  /// FCM token - PN
  static var UPDATE_TOKEN_FCM = '$BASE_URL/api/whms/users/updateToken';

  /// Cluster-list
  static var CLUSTER_LIST = '$BASE_URL/api/whms/users/clusterListBySupervisorId';

  /// Janitor-list
static var  JANITOR_LIST = '$BASE_URL/api/whms/users/janitorsList';

  /// Facility-list
  static var FACILITY_LIST = '$BASE_URL/api/whms/taskAllocation/getJanitorTaskInfo';

  /// Re-assign Task
  static var RE_ASSIGN_TASK = '$BASE_URL/api/whms/taskAllocation/updateTaskAllocation';

  /// App_Launch
  static var APP_LAUNCH = '$BASE_URL/api/whms/users/onAppLoad';

  static var USER_DETAILS = '$BASE_URL/api/whms/users/getUserByID';

   //api/whms/users/getUserByID?id=151

  /// Cluster-list
  static var ATTENDANCE_HISTORY_LIST = '$BASE_URL/api/whms/users/attendanceHistory';
  static var ATTENDANCE_HISTORY_LIST_SUP = '$BASE_URL/api/whms/users/janitorAttendanceHistoryForSupervisor';

  /// Cluster-list
  static var MONTH_LIST = '$BASE_URL/api/whms/users/getMonthlyHistory';
  static var MONTH_LIST_SUP = '$BASE_URL/api/whms/users/getMonthAndYearForSupervisor';


  //  janitor list by facility id 
   static var JANITOR_LIST_FACILITY = '$BASE_URL/api/whms/users/getAllUser';




}
