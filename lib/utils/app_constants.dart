// ignore_for_file: constant_identifier_names

class AppName {
  static const String APP_NAME = "Woloo Smart Hygiene";
}

class MySplashScreenConstants {
  static const String DEAR_USER = 'dearUser';
  static const String PRIVACY = 'privacyPermission';
  static const String PERMISSION = 'dataUsagePermission';
  static const String ADS = 'dataCollectionText';
  static const String CONTINUE = 'continue';
  static const String LOADING = 'loading';
}

class MyLoginConstants {
  static const String WELCOME_TEXT = 'welcomeText';
  static const String MOBILE_NO = 'enterMobileNumber';
  static const String MOBILE_VALIDATION = 'mobileNumberValidation';
  static const String LANGUAGE_HINDI = 'Hindi';
  static const String LANGUAGE_ENGLISH = 'English';
  static const String LANGUAGE_MARATHI = 'Marathi';

  static const String SEND_OTP_BTN = 'sendOTP';
  static const String VERIFY_OTP_BTN = 'Submit';
  static const String LOGIN_WITH_OTP = 'LoginwithOTP';

  static const String OTP_VERIFICATION = 'otpVerification';
  static const String ENTER_OTP = 'enterVerificationCode';
  static const String DIDNT_RECIEVED_OTP = 'didNotReceiveOTP';
  static const String LOCATION_DETECTED_TOAST = 'locationDetected';
  static const String ENTER_OTP_TOAST = 'enterOTP';
  static const String SEC = 'sec';
}

class MyFacilityListConstants {
  static const String POPUP_TEXT = 'taskStartingPermission';
  static const String POPUP_CANCEL_BUTTON = 'cancel';
  static const String POPUP_YES_BUTTON = 'yes';
  static const String SEARCH = 'search';
  static const String SELECT_ALL = 'selectAll';
  static const String ASSIGN = 'assign';
  static const String MIN = 'min';
  static const String GOBACK = 'Go Back';
}

class MyTemplateScreenConstants {
  static const String HELLO = 'hello';
}

class MyTaskListConstants {
  static const String APP_BAR = 'task';
  static const String BACK = 'Back';
  static const String SUBMIT_BTN = 'submit';
  static const String POPUP_TITLE = 'taskSubmissionPermission';
  static const String TASK_SUBMISSION_TOAST = 'taskSubmittedSuccessfully';
  static const String LIST_OF_ACTIVITIES = 'activityList';
}

class MySelfieScreenConstants {
  static const String UPLOAD_TITLE_TEXT = 'Upload A Profile Image';
  static const String TITLE_TEXT = 'takeASelfie';
  static const String TITLE_SUBTEXT = 'selfieGuidelines';
  static const String SUBMIT_BTN = 'submit';
  static const String REMARKS = 'remarks';
  static const String IMAGE_TYPE_UPLOAD = 'profile';
  static const String IMAGE_TYPE_SELFIE = 'selfie';
}

//        "PROFILE": "profile",
//

class MydashboardScreenConstants {
  static const String TITLE_TEXT = 'myDashboard';
  static const String FACILITY = 'facility';

  static const String LOG_OUT = 'logOut';
  static const String URL_ERR_TOAST = 'couldNotLaunch';
  static const String REPORT_ISSUE = 'reportIssue';
  static const String IN = 'IN';
  static const String OUT = 'OUT';
  static const String DESCRIPTION = 'description';
  static const String LOCATION = 'location';
  static const String BOOTHS = 'booths';

  static const String TOTAL_TASK = 'totalTask';
  static const String COMPLETE_TASK = 'completedTask';
  static const String PENDING_TASK = 'pendingTask';
  static const String Onging_TASK = 'Ongoing';
  static const String Rquest_TASK = 'Request for closure';
  static const String ACCEPT_TASk =   'Accepted';
  static const String REJECTED_TASk = 'Rejected';
  
  static const String CLOSE = 'close';
  static const String REJECT = 'reject';
  static const String ACCEPT = 'accept';
  static const String START = 'start';
  static const String DIRECTION = 'direction';
  static const String CHECK_IN = 'clock-in';
  static const String CHECK_OUT = 'clock-out';
  static const String BLANK_LIST_TEXT = 'clockInText';
  static const String LOADING_TOAST = 'loadingText';
  static const String POPUP_TITLE = 'checkOutPermission';
  static const String LOCATION_FETCHING_TOAST = 'waitForLocationFetchingText';
  static const String GPS_DISABLED_TOAST = 'turnOnGPSText';
  static const String PULL_TO_REFRESH = 'pullToRefresh';

}

class MyClusterListScreenConstants {
  static const String TITLE_TEXT = 'cluster';
  static const String BTN_TEXT = 'assign';
}

class MyFacilityScreenConstants {
  static const String TITLE_TEXT = 'tasks';
}

class MyJanitorsListScreenConstants {
  static const String TITLE_TEXT = 'janitors';
  static const String SUB_TITLE = 'janitorList';
  static const String JANITOR_PRESENT = 'present';
  static const String JANITOR_ABSENT = 'absent';
}

class MyTaskDetailsScreenConstants {
  static const String APP_BAR = 'taskDetails';
  static const String APPROVE_BUTTON = 'approve';
  static const String TITLE = 'tasksList';
}

class MyJanitorsDetailsScreenConstants {
  static const String APP_BAR = 'janitorsDetails';
  static const String SHIFT = 'shift';

  static const String CHECK_IN = 'check-in';
  static const String CHECK_OUT = 'check-out';

  static const String COMPLETE_TASK = 'completedTask';
  static const String PENDING_TASK = 'pendingTask';
  static const String TOTAL_TASK = 'totalTask';
  static const String MOB = 'mobNo';
}

class MyIssuesListScreenConstants {
  static const String TITLE_TEXT = 'issueList';
  static const String REPORT_ISSUE_BUTTON = 'reportIssue';
  static const String FACILITY_NAME = 'facilityName';
  static const String JANITOR_NAME = 'janitorName';
  static const String DESCRIPTION = 'description';
}

class MyReportIssueScreenConstants {
  static const String CLUSTER_NAME = 'clusterName';
  static const String CLUSTER_NAME_VALIDATION = 'clusterNameValidation';
  static const String FACILITY = 'facility';
  static const String FACILITY_VALIDATION = 'facilityNameValidation';
  static const String TEMPLATE_NAME = 'templateName';
  static const String TASK_NAME = 'taskName';
  static const String TASK_NAME_VALIDATION = 'taskNameValidation';
  static const String DESCRIPTION = 'description';
  static const String DESCRIPTION_VALIDATION = 'descriptionValidation';
  static const String ASSIGN_TO = 'assignTo';
  static const String ASSIGN_VALIDATION = 'assigningValidation';
  static const String UPLOAD_PHOTO = 'upload\n Photo';
  static const String POP_UP_TEXT = 'issueSubmittedText';
  static const String TEMPLATE_NAME_VALIDATION = 'templateNameValidation';
  static const String CHOOSE_PHOTO = 'chooseFile';
  static const String VIEW_PHOTO = 'View Image';
  static const String DELETE_PHOTO = 'Delete Image ';
  static const String UPLOAD_IMG_TOAST = 'uploadImage';
  static const String FILE_NOT_ALLOWED = 'fileNotAllowed';
  static const String FILE_NOT_SELECTED = 'fileNotSelected';
}

class TaskCompletionScreenConstants {
  static const String TITLE_TEXT = 'addLooPhotos';
  static const String TITLE_SUBTEXT = 'pleaseCaptureImageOfArea';
  static const String END_TASK_BTN = 'endTask';
  static const String REMARKS = 'remarks';
  static const String IMAGE_TYPE_TASK = 'task';
  static const String ADD_PHOTO = 'addPhoto';
}

class BottomNavigatiionBarConstants {
  static const String CLUSTER = 'cluster';
  static const String JANITORS = 'janitors';
  static const String REPORT_ISSUE = 'reportIssue';
  static const String ACCOUNT = 'account';
}

class MyAccountScreenConstants {
  static const String MY_ACCOUNT = 'myAccount';
}

class AssignScreenConstants{
  static const String  SEARCH_JANITOR = 'searchJanitor';
  static const String  JANITOR_SCHEDULE = 'janitorSchedule';
  static const String  AVAILABLE_TIME_SLOT =  'tasksAllocation';
  static const String  UPDATE_TASK   = 'assignTasks';
  static const String  TASK_NAME   = 'taskName';
  static const String  START_TIME   = 'startTime';
  static const String  END_TIME   = 'endTime';
  static const String  TIME   = '--:--';
  static const String TASK_ASSIGN  = "taskAssignSuccessfullyToJanitor";
  static const String SEARCH_JANITOR_TO = "searchJanitorToAssignTasks";
  static const String START_TIME_VALIDATION = "startTimeValidation";
  static const String END_TIME_VALIDATION = "endTimeValidation";
}

class MyJanitorProfileScreenConstants {
  static const String MY_PROFILE = 'myProfile';
  static const String ATTENDANCE_HISTORY = 'attendanceHistory';
  static const String HISTORY = 'History';
  static const String LOG_OUT = 'logOut';
  static const String STATUS_PRESENT = 'present';
  static const String STATUS_ABSENT = 'absent';
  static const String LOGGING_OUT_TOAST = 'loggingOut';
  static const String LOG_OUT_SUCCESS_TOAST = 'logoutSuccess';
}

class MyAttendanceHistoryScreenConstants {
  static const String JAN = 'jan';
  static const String FEB = 'feb';
  static const String MAR = 'mar';
  static const String APR = 'apr';
  static const String MAY = 'may';
  static const String JUN = 'jun';
  static const String JUL = 'jul';
  static const String AUG = 'aug';
  static const String SEP = 'sep';
  static const String OCT = 'oct';
  static const String NOV = 'nov';
  static const String DEC = 'dec';
  static const String SELECT = 'select';
  static const String BLANK_LIST_TEXT = 'selectMonth';
  static const String DOWNLOAD_TO_EXCEL = 'Download To Excel';
  static const String DOWNLOAD_SUCCESS_MESSAGE = 'Excel exported into download folder successfully';
}

class MapUtilsConstants {
  static const String COULD_NOT_OPEN_MAP = 'couldNotOpenTheMap';
}

class ErrorWidgetConstants {
  static const String ERROR = 'error';
}

class EmptyWidgetConstants {
  static const String DATA_NOT_FOUND = 'dataNotFound';
  static const String PENDING_TASK_ERROR = "pending_task";
  static const String ACCEPTED_TASK_ERROR = "accpeted_task";
  static const String RFC_TASK_ERROR = "rfc_task";
  static const String ONGOING_TASK_ERROR = "ongoing_task";
  static const String COMPELTED_TASK_ERROR = "completed_task";
}

class DialogueReportIssueConstants {
  static const String DONE = 'done';
}

class AppError {
  static const String success = "success";
  static const String strBadRequestError = "bad_request_error";
  static const String strNoContent = "no_content";
  static const String strForbiddenError = "forbidden_error";
  static const String strUnauthorizedError = "unauthorized_error";
  static const String strNotFoundError = "not_found_error";
  static const String strConflictError = "conflict_error";
  static const String strInternalServerError = "internal_server_error";
  static const String strUnknownError = "unknown_error";
  static const String strTimeoutError = "timeout_error";
  static const String strDefaultError = "default_error";
  static const String strCacheError = "cache_error";
  static const String strNoInternetError = "no_internet_error";
}