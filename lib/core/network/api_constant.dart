// ignore_for_file: non_constant_identifier_names

class APIConstants {
//

//
// = "https://53f2-2409-4062-2097-da56-25a7-ecec-f87a-6912.ngrok-free.app";

  static var BASE_URL = 'https://staging-api.woloo.in'; // QA
  // static var BASE_URL = 'https://api.woloo.in'; // Production
//  static var BASE_URL = 'http://192.168.1.103:5000'; // P
  static var SEND_OTP = '$BASE_URL/api/whms/users/sendOTP';
  static var VERIFY_OTP = '$BASE_URL/api/whms/users/verifyOTP';

  /// clock-In - clock-Out
  static var ATTENDANCE = '$BASE_URL/api/whms/users/attendance';

  /// Template List - janitor Dashboard
  static var GET_ALL_TASK_TAMPLATES =
      '$BASE_URL/api/whms/taskAllocation/getAllTaskByJanitorId';

  /// upload selfie
  static var UPLOAD_SELFIE = '$BASE_URL/api/whms/users/upload_image';

  /// task-list
  static var GET_ALL_TASKS = '$BASE_URL/api/whms/task/getAllTasksByTempleteId';
  static var SUBMIT_TASKS = '$BASE_URL/api/whms/users/submitTask';

  /// Status_update
  static var UPDATE_STATUS = '$BASE_URL/api/whms/users/updateStatus';

  /// Supervisor_dashboard
  static var GET_SUPERVISOR_DASHBOARD_DATA =
      '$BASE_URL/api/whms/users/supervisor_dashboard';

  /// issues-list
  static var GET_ALL_ISSUES = '$BASE_URL/api/whms/users/IssuesList';

  /// cluster-dropdown-list
  static var GET_CLUSTER_DROPDOWN_DATA = '$BASE_URL/api/whms/users/clusterList';

  /// facility-dropdown-list
  static var GET_FACILITIES_DROPDOWN_DATA =
      '$BASE_URL/api/whms/users/facilityListByClusterId';

  /// task-dropdown-list
  static var GET_TASKS_DROPDOWN_DATA =
      '$BASE_URL/api/whms/template/getAllTemplate';

  /// cluster-dropdown-list
  static var GET_ALL_SUBMITTED_TASK =
      '$BASE_URL/api/whms/users/listOfSubmitedTask';

  /// janitor-dropdown-list
  static var GET_JANITOR_DROPDOWN_DATA =
      '$BASE_URL/api/whms/users/getAllJanitorByClusterId';

  /// report issue
  static var REPORT_ISSUE = '$BASE_URL/api/whms/users/reportIssue';

  /// FCM token - PN
  static var UPDATE_TOKEN_FCM = '$BASE_URL/api/whms/users/updateToken';

  /// Cluster-list
  static var CLUSTER_LIST =
      '$BASE_URL/api/whms/users/clusterListBySupervisorId';

  /// Janitor-list
  static var JANITOR_LIST = '$BASE_URL/api/whms/users/janitorsList';

  /// Facility-list
  static var FACILITY_LIST =
      '$BASE_URL/api/whms/taskAllocation/getJanitorTaskInfo';

  /// Re-assign Task
  static var RE_ASSIGN_TASK =
      '$BASE_URL/api/whms/taskAllocation/updateTaskAllocation';

  /// App_Launch
  static var APP_LAUNCH = '$BASE_URL/api/whms/users/onAppLoad';

  static var USER_DETAILS = '$BASE_URL/api/whms/users/getUserByID';

  //api/whms/users/getUserByID?id=151

  /// Cluster-list
  static var ATTENDANCE_HISTORY_LIST =
      '$BASE_URL/api/whms/users/attendanceHistory';
  static var ATTENDANCE_HISTORY_LIST_SUP =
      '$BASE_URL/api/whms/users/janitorAttendanceHistoryForSupervisor';

  /// Cluster-list
  static var MONTH_LIST = '$BASE_URL/api/whms/users/getMonthlyHistory';
  static var MONTH_LIST_SUP =
      '$BASE_URL/api/whms/users/getMonthAndYearForSupervisor';

  //  janitor list by facility id
  static var JANITOR_LIST_FACILITY = '$BASE_URL/api/whms/users/getAllUser';

  static var CREATE_CLIENT = '$BASE_URL/api/wolooGuest/createClient';

  static var CLIENT_SIGNUP = '$BASE_URL/api/whms/clients/clientSignUp';

  static var CLIENT_LOGIN = '$BASE_URL/api/wolooGuest/login';

  static var SEND_OTP_CLIENT = '$BASE_URL/api/wolooGuest/sendOTPForClient';

  static var VERIFY_OTP_CLIENT = '$BASE_URL/api/wolooGuest/verifyOTPForClient';

  static var DELETE_USER = '$BASE_URL/api/wolooGuest/login';

  static var CLIENT_SETUP = '$BASE_URL/api/whms/clients/clientSetUp';

  static var ADD_USER = '$BASE_URL/api/whms/users/addUser';

  static var GET_TASK = '$BASE_URL/api/whms/task/byCategory';

  static var GET_TASK_DASHBOARD =
      '$BASE_URL/api/whms/taskAllocation/getTaskDashboard';

  static var SubscriptionExpiry =
      '$BASE_URL/api/whms/plans/getSubscriptionExpiry';

  static var CREATE_OREDER = '$BASE_URL/api/whms/payment/createOrder';

  static var ASSIGN_TASK = '$BASE_URL/api/whms/template/add';

  static var GET_CLIENT_ID = '$BASE_URL/api/whms/users/client';

  static var GET_ALL_USER = "$BASE_URL/api/whms/users/getAllUser";

  static var GET_USER_COINS = "$BASE_URL/api/wolooHost/user_coins";

  static var GET_ALL_FACILITY = "$BASE_URL/api/whms/facilities/getFacilities";

  static var EXTEND_EXPIRY = "$BASE_URL/api/whms/clients/extendExpiry";

  static var PAYMENT_STATUS = "$BASE_URL/api/whms/payment/checkPaymentStatus";

  static var FACILITY_BY_JANITOR =
      "$BASE_URL/api/whms/facilities/getJanitorsByFacility";

  static var GET_PLAN = "$BASE_URL/api/whms/plans/getPlans";

  static var CHECK_TASK_TIME =
      '$BASE_URL/api/whms/autoTaskMapping/checkJanitorTasktime';

  static var SUPERVISOR_CHECK = '$BASE_URL/api/whms/clients/supervisorCheck';

  static var GET_FACILITIES_STATUS =
      '$BASE_URL/api/whms/facilities/getFacilitiesStatus';

  static var DELETE_TASK =
      "$BASE_URL/api/whms/autoTaskMapping/deleteTasktiming";

  static var DELETE_FACILITY = '$BASE_URL/api/whms/clients/facilityrollback';

  static var GET_IOT_DASHBOARD_DATA =
      '$BASE_URL/api/whms/iot/getIotDashboardData';

  static var GENERATE_SUMMARY = '$BASE_URL/api/whms/iot/generateSummary';

  static var AUTH_BASE_URL = "https://staging-store.woloo.in";
  static var EMAIL_PASS_REGISTER =
      '$AUTH_BASE_URL/auth/customer/emailpass/register';

  static var STORE_CUSTOMER_REGISTER =
      'https://staging-store.woloo.in/store/customers';

  static var STORE_CUSTOMER_LOGIN = '$AUTH_BASE_URL/auth/customer/emailpass';

  static var UPDATE_CUSTOMER = "$BASE_URL/api/wolooGuest/register";

  //Product
//'https://staging-store.woloo.in/store/regions'
  static var GET_REGIONS = '$AUTH_BASE_URL/store/regions';
  static var CREATE_CART = '$AUTH_BASE_URL/store/carts';
  // store/product-categories
  static var GET_PRODUCT_CATEGORIES = '$AUTH_BASE_URL/store/product-categories';
  //  https://staging-store.woloo.in/store/collections?fields=id,title,metadata
  static var TOP_BRANDS =
      '$AUTH_BASE_URL/store/collections?fields=id,title,metadata&limit=50';

  // https://staging-store.woloo.in/store/
  static var PRODUCT_COLLECTIONS =
      '$AUTH_BASE_URL/store/products?fields=*variants.calculated_price,+variants.inventory_quantity&region_id=reg_01JPH693TAM20TXZEJNBJ5QBV4';

  static var CREATE_ADDRESS = '$AUTH_BASE_URL/store/customers/me/addresses';
  static var UPDATE_ADDRESS = '$AUTH_BASE_URL/store/customers/me/addresses/';
  static var SET_BILLING_ADDRESS = '$AUTH_BASE_URL/store/carts/';

  static var GET_ADDRESS = '$AUTH_BASE_URL/store/customers/me/addresses';

  static var GET_ALL_CART_DATA = '$AUTH_BASE_URL/store/carts/';
  static var ADD_TO_CART = '$AUTH_BASE_URL/store/carts/';

  //Cart
  // URL: https://staging-store.woloo.in/store/carts/cart_01JTQVACY3V5FY8NBBZY3ZZ06C/promotions
  static var CART_BASE_URL = '$AUTH_BASE_URL/store/carts/';
  // https://staging-store.woloo.in/store/shipping-options/address?cart_id=cart_01JTQVACY3V5FY8NBBZY3ZZ06C
  static var SHIPPING_OPTIONS = '$AUTH_BASE_URL/store/shipping-options/';
  static var Add_Remove_Item = '/line-items/';
}
