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
  static const String NEXT = "Next";
  
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


class LoginConstant {
  static const String newUserRegister = "New User?";
  static const String registration = "Register Now";
  static const String forgotPassword = "Forgot Password?";
  static const String loginAsSupervisor = "Login as a Supervisor/Janitor";

}

class SignUpConstant {

  static const String name = "Name";
  static const String email = "Email";
  static const String mobileNo = "Mobile No.";
  static const String address = "Address";
  static const String city = "City";
  static const String pinCode = "Pin Code";
  static const String password = "Password";
  static const String confirmPassword = "Confirm Password";
}

class TermsOfUse {

  static const String title = "Terms of Use";

  static const String subTitle  =  "Terms and Conditions related to using the Woloo App and Website";
  
  static const String accept = "Accept";

  static const String deny = "Deny";

  static const String content = '''
  (Version 1)

  1. Your Agreement  
     1.1 This website [www.woloo.in](http://www.woloo.in) and/or the Woloo App (together, ‘Woloo Platform’) is operated by Loom and Weaver Retail Private Limited, a Company incorporated in India under the Companies Act 2013. Please read these Terms and Conditions (“this Terms of Use”) carefully before using the Woloo Platform and the services offered by Loom and Weaver Retail Private Limited, its affiliated companies (together, “Woloo”) or the third-party operators (the “Operator”) through the Woloo Platform (the “Services”). “You” and “your” when used in this Terms and Conditions includes (1) any person who accesses the Woloo Platform and (2) persons for whom you make a purchase of the Services.

  2. Change of Terms of Use  
     2.1 Woloo’s Modifications  
     2.1.1 Woloo reserves the right, at its sole discretion, to change or modify any part of this Terms of Use at any time without prior notice. You should visit this page periodically to review the current Terms of Use to which you are bound. If Woloo changes or modifies this Terms of Use, Woloo will post the changes on this page and will indicate the date on which this Terms of Use was last revised.  

     2.1.2 Your continued use of the Woloo Platform after any such changes or modifications constitutes your acceptance of the revised Terms of Use. If you do not agree to abide by the revised Terms of Use, do not use or access the Woloo Platform and/or the Services.  

     2.1.3 When using the Services, you shall be subject to any additional terms applicable to such Services that may be posted on the page relating to such Services from time to time and the privacy policy adopted by Woloo from time to time (“the Privacy Policy”).  

  3. Access and Use of the Services  
     3.1 Ownership of Content  
     3.1.1 The Woloo Platform, its domain name ([www.woloo.in](http://www.woloo.in)), features, contents, and application services are owned and operated by Woloo.  

     3.2 Provision and Accessibility of Services  
     3.2.1 Subject to this Terms of Use, Woloo may either provide the Services by itself or on behalf of the Operators. These Services are solely for your own use and not for any third party. Woloo may change, suspend, or discontinue any Services at any time without notice or liability.  

     3.2.2 Woloo does not guarantee that the Services will always be available or uninterrupted. Woloo will not be liable for any unavailability of Services.  

  4. Woloo Platform and Content  
     4.1 Use of the Content  
     4.1.1 All materials displayed on the Woloo Platform, including text, graphics, images, and other materials, are protected by copyright and/or other intellectual property rights.  

     4.1.2 If Woloo grants you access to the Woloo Platform and/or the Content, such access shall be non-exclusive, non-transferable, and limited.  

     4.1.3 You shall not copy, modify, publish, distribute, or otherwise exploit any Content without prior written consent from Woloo.  

     4.2 Woloo’s Liability for the Woloo Platform and Content  
     4.2.1 Woloo does not guarantee the authenticity and accuracy of any content posted by other users. Your use of the Woloo Platform is at your own risk.  

     4.2.2 Woloo is not liable for any content errors, omissions, or any damage resulting from the use of content on the platform.  

  5. Intellectual Property Rights  
     5.1 Intellectual Property  
     5.1.1 All intellectual property rights related to the Woloo Platform belong to Woloo or its licensors.  

     5.1.2 You shall not reproduce, distribute, or commercially exploit any part of the Woloo Platform and Content without permission.  

  6. User Submissions  
     6.1 Uploading of Information  
     6.1.1 By posting content on the Woloo Platform, you grant Woloo a worldwide, royalty-free, perpetual license to use your content.  

     6.1.2 You agree that all posted content complies with applicable laws and does not infringe third-party rights.  

  7. User Representations and Conduct  
     7.1 Use of the Woloo Platform  
     7.1.1 You agree not to use the Woloo Platform for any unlawful activities, including but not limited to infringement of intellectual property rights, harassment, fraud, or spreading harmful content.  

     7.2 Removal of User Submissions  
     7.2.1 Woloo reserves the right to remove any content that violates these terms.  

  8. Account Security  
     8.1 Opening an Account  
     8.1.1 You may be required to create an account with Woloo to use certain services. You must provide accurate information and keep your account secure.  

     8.2 Provision of Personal Information  
     8.2.1 You shall provide accurate and updated personal information for account registration.  

     8.3 Security of Your Account  
     8.3.1 You shall not share your login credentials with third parties.  

     8.3.2 If you suspect unauthorized access, notify Woloo immediately.  

     8.3.3 Woloo reserves the right to terminate accounts involved in fraudulent activities.  

  For further details, contact [support@woloo.in](mailto:support@woloo.in).  

  Thank you for using the Woloo Platform!  
  ''';
}



class DashboardConst {
  // Dashboard Welcome
  static const String welcomeMessage = "Welcome to";
  static const String dashboardTitle = "Woloo Smart Hygiene Dashboard";
  static const String onboardingMessage = 
      "You’re there! Just a few more steps to get you started with your Smart Hygiene Journey.";
  static const String getStarted = "Get Started";
  static const String listYourFacility = "List Your";
  static const String organizationName = "Your Facility Name *";
   static const String addNewFacility = 'Add a New Facility';
  static const String addNewTask = 'Add a New Task';

  static const String ifOthersMentionFacility = "If Others, Please mention the type of Facility";
  static const String typeOfFacility = "Type of Facility *";
  static const String home = "Home";
  static const String office = "Office";
  static const String restraunt = "Restaurant";
  static const String other = "Others";
  static const String next = "Next";
  static const String chooseAdmin = "Choose";
  static const String monitorYourself = "Monitor \nYourself";
  static const String assignSupervisor = "Assign a \nSupervisor";
  static const String assignsupervisor = "Supervisor";
  static const String fullName = "Supervisor Name *";
  static const String number = "Mobile Number *";
   static const String taskBuddyName = "Name of the Task Buddy *";
  static const String assignJanitor = "Janitor";
  static const String assignFacility = "Assign Facility *";
  static const String gender = "Gender *";
  static const String assignTasks = "Assign";
  static const String selectCleaningTasks = "Select Cleaning Tasks *";
  static const String estimatedTaskCompletionTime = "Estimated Task Completion Time";
  static const String cleaningCycle = "Cleaning Cycle *";
    static const String taskTimeRestriction = 
      "Tasks can only be created between 9 AM and 9 PM.";
  static const String taskScheduledNextDay = 
      "Tasks exceeding this timeframe will be scheduled for the next day.";

  // Facility Management
  static const String addAnotherFacility = "Add another Facility";
  static const String helloSuperAdmin = "Hello Cult-Fit (Super-Admin)";
  static const String currentDateTime = "4.45 pm 19 Jan 2024";

  // Subscription Notice
    static const String subscriptionExpiryNotice =
      "Your Free Subscription shall end in 3 Days.";
  static const String renew = "Renew it Now";
  // Dashboard
  static const String dashboardOverview = "Dashboard Overview";
  static const String taskAudit = "Task Audit";
  static const String janitorPerformance = "Janitor Performance";
  static const String facility = "Facility";
   static const String totalTasks = "Total Tasks";
  static const String tasksCompleted = "Tasks Completed";
  static const String location = "Location";
  static const String shiftStartTime = "Shift Start Time *";
  static const String time = "Time";
  static const String shiftStartDescription = "The shift shall start from DD/MM/YYYY";
  // static const String estimatedTaskCompletionTime = "Estimated Task Completion Time";

  static const String scheduleShift = "Start Shift Time";
  static const String scheduleTask = "Schedule First Task *";
  static const String save = "Add";
  static const String addMoreTimings = "Add More Timings";
  static const String addTimings = "Add Timings";
  static const String shiftStart = "The shift shall start from DD/MM/YYYY at 00:00";
  static const String shiftEnd = "Shift shall complete at 00:00";
  static const String congratulations = "Congratulations!";
  static const String addAnotherTask = "Add Another Task";
  static const String noThanks = "Start Monitoring";
    static const String taskBuddyPrompt = 
      "Do you want to assign a new Task Buddy or utilise your existing Task Buddy?";
  static const String assignNewTaskBuddy = "Assign New Task Buddy";
  static const String assignExistingTaskBuddy = "Assign Existing Task Buddy";

}





class SubcriptionConstant{

  static const String upgradeToPremium = " Upgrade your tasq master service";
  static const String upgradeDescription = "Upgrade to a premium plan to explore more benefits";

  // Free Plan
  static const String freePlan = "Free Plan";
  static const String freeFeature = "This is a Free Feature";
  static const String freeTotalLogins = "Total of 5 Logins";
  static const String freeSupervisorLogin = "1 Supervisor Login";
  static const String freeJanitorLogins = "4 Janitor Logins";
  static const String freeLocation = "1 location";
  static const String freeFacilities = "10 Facilities";

  // Premium Plan
  static const String premiumPlan = "Premium Plan";
  static const String premiumFeature = "This is a Paid Feature";
  static const String premiumTotalLogins = "Total of 5 Logins";
  static const String premiumSupervisorLogin = "1 Supervisor Login";
  static const String premiumJanitorLogins = "4 Janitor Logins";
  static const String premiumLocation = "1 location";
  static const String premiumFacilities = "10 Facilities";

static const String stinqguardOffer = 'Avail STINQGUARD for just \n Rs. 2,499 + GST';
static const String taskMasterOffer = 'Avail TASQMASTER for just \n Rs. 499 + GST';
static const String itemTotal = 'Item Total';
static const String discount = 'Discount';
static const String finalTotal = 'Final Total';  
static const String grandTotal = 'Grand Total';
static const String addFacilityForPremium = 'Add your Facility for Premium';
static const String addFacilityForTaskMaster = 'Add your Facility for TasqMaster';



}