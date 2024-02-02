import 'package:sizer/sizer.dart';

class AppConstants {
  static const String appName = 'Aspirevue';
  static const double appVersion = 1.0;
  static const String appVersionLable = "Version v 10.11.12";

  static const String privacyPolicyUrl =
      "https://www.aspirevue.com/privacy-policy-2/";
  static const String termAndConditionUrl =
      "https://www.aspirevue.com/terms-of-service/";

  // AspireVue Production URL
  // static const String baseUrl = "https://my.aspirevue.com/api/";

  // AspireVue Staging URL
  static const String baseUrl =
      "https://aspirevue.sigmasolve.com/aspirevue-v3/api/";

  // auth
  static const String registerUri = 'register';
  static const String loginUri = 'login';
  static const String logoutUri = 'logout';
  static const String forgotPasswordUri = 'forgotpassword';
  static const String socialLoginUri = 'social_login';
  static const String deleteAccountUri = 'deleteAccount';
  static const String updateSmsConsentUri = 'updateSmsConsent';

  // others
  static const String saveSupportDataUri = 'saveSupportData';
  static const String getWelcomeHashtagsUri = 'getWelcomeHashtags';

  // notification
  static const String notificationListUri = 'notificationList';
  static const String readAllUri = 'readAll';
  static const String clearAllUri = 'clearAll';
  static const String archiveInboxUri = 'archiveInbox';
  static const String updateUserDeviceTokenUri = 'updateUserDeviceToken';
  static const String acceptDeclineGlobalInvitationUri =
      'acceptDeclineGlobalInvitation';

  // Insight Stream
  static const String insightFeedUri = 'insightFeeds';
  static const String getHashTagListingUri = 'getHashTagListing';
  static const String addStarRatingUri = 'addStarRating';
  static const String savePostUri = 'savePost';
  static const String hidePostUri = 'hidePost';
  static const String hideAllPostUri = 'hideAllPost';
  static const String followUnfollowUserUri = 'followUnfollowUser';
  static const String blockUnblockUri = 'blockUnblock';
  static const String addAsColleagueUri = 'addAsColleague';
  static const String reportPostUri = 'reportPost';
  static const String sharePostUri = 'sharePost';
  static const String getCommentDetailUri = 'getCommentDetail';
  static const String addCommentUri = 'addComment';
  static const String followedHashtagListUri = 'followedHashtagList';
  static const String searchUserHashtagListUri = 'searchUserHashtagList';
  static const String getOtherUserProfileDetailUri =
      'getOtherUserProfileDetail';
  static const String getOtherUserInsightFeedsUri = 'getOtherUserInsightFeeds';
  static const String myInsightFeedListUri = 'myInsightFeedList';
  static const String savedPostDetailUri = 'savedPostDetail';
  static const String getPeopleUserListUri = 'getPeopleUserList';
  static const String getFeelingListUri = 'getFeelingList';
  static const String uploadPostImageVideoFilesUri =
      'uploadPostImageVideoFiles';
  static const String createPostUri = 'createPost';
  static const String removePostUri = 'deletePost';
  static const String getHashtagsUri = 'getHashtags';
  static const String getCreatePostDetailUri = 'getCreatePostDetail';
  static const String getFollowersCountUri = "getFollowersCount";

  // My connection

  static const String myconnectionUserListUri = 'getConnectionUsers';
  static const String searchOrganizationUserUri = 'searchOrganizationUser';
  static const String getUserOrganizationChartUri = 'getUserOrganizationChart';
  static const String getUserAboutInfoUri = "getUserAboutInfo";
  static const String getObjectiveNoteListUri = "getObjectiveNoteList";
  static const String sendMessageUri = "sendMessage";
  static const String getGoalDataUri = "getGoalData";
  static const String removeAsCommunityUserUri = "removeAsCommunityUser";
  static const String getWorkplaceMenuListUri = "getWorkplaceMenuList";
  static const String getColleaguesListUri = "getColleaguesList";
  static const String removeAsColleagueUri = "removeAsColleague";
  static const String getInfluenceListUri = "getInfluenceList";
  static const String getGrowthCommunityListUri = "getGrowthCommunityList";
  static const String getContactListUri = "getContactList";
  static const String userFollowUnfollowUri = "userFollowUnfollow";
  static const String promoteToGlobalColleagueUri = "promoteToGlobalColleague";
  static const String getMyCoachesListUri = "getMyCoachesList";
  static const String getMentorsListUri = "getMentorsList";
  static const String getMenteesListUri = "getMenteesList";
  static const String getCoachMentorMenteeDetailsUri =
      "getCoachMentorMenteeDetails";
  static const String updateSignatureItemUri = "updateSignatureItem";
  static const String createColleagueUri = "createColleague";
  static const String getMenteeRoleResponsibilityUri =
      "getMenteeRoleResponsibility";
  static const String updateCoachMentorMenteeActionItemUri =
      "updateCoachMentorMenteeActionItem";
  static const String getCoacheeListUri = "getCoacheeList";
  static const String updateCoacheeActiveArchiveUri =
      "updateCoacheeActiveArchive";
  static const String importContactsUri = "importContacts";
  static const String inviteContactUri = "inviteContact";

  // Goal
  static const String getGoalFollowersUri = "getGoalFollowers";
  static const String getMyGoalsListingUri = "getMyGoalsListing";
  static const String createGoalUri = "createGoal";
  static const String goalDetailsUri = "getGoalDetail";
  static const String updateGoalDetailsUri = "updateGoalDetails";
  static const String archiveGoalUri = "archiveGoal";
  static const String getGoalMessagesUri = "getGoalMessages";
  static const String sendGoalMessageUri = "sendGoalMessage";
  static const String saveDailyQUri = "saveDailyQ";
  static const String getGoalFeedbackUri = "getGoalFeedback";
  static const String saveFollowersUri = "saveFollowers";
  static const String deleteFollowersUri = "deleteFollowers";
  static const String getDailyqHistoryUri = "getDailyqHistory";
  static const String saveGatherFeedbackUri = "saveGatherFeedback";
  static const String deleteEventUri = "deleteEvent";
  static const String getGoalObjectiveDetailUri = "getGoalObjectiveDetail";
  static const String getGoalReminderUri = "getGoalReminder";
  static const String saveGoalReminderUri = "saveGoalReminder";
  static const String saveGoalPopupDetailsUri = "saveGoalPopupDetails";
  static const String geGoalSelectorDetailsUri = "geGoalSelectorDetails";
  static const String getProgressTrackingDropdownOptionsUri =
      "getProgressTrackingDropdownOptions";

  // Profile and setting
  static const String getAllCountriesUri = "getAllCountries";
  static const String getStateTimeZoneListUri = "getStateTimeZoneList";
  static const String getMyProfileUri = "getMyProfile";
  static const String updatePersonalInfoUri = "updatePersonalInfo";
  static const String changePasswordUri = "changePassword";
  static const String getNotificationSettingsUri = "getNotificationSettings";
  static const String updateNotificationSettingsUri =
      "updateNotificationSettings";
  static const String getPrivacySettingsUri = "getPrivacySettings";
  static const String updatePrivacySettingsUri = "privacysetting";
  static const String uploadProfilePictureUri = "uploadProfilePicture";
  static const String getConnectionSettingsUri = "getConnectionSettings";
  static const String updateConnectionSettingsUri = "updateConnectionSettings";
  static const String getSignatureUri = "getSignature";
  static const String updateSignatureUri = "updateSignature";
  static const String getIntegrationDataUri = "getIntegrationData";
  static const String updateIntegrationDataUri = "updateIntegrationSettings";
  static const String deleteReceiveFeedbackUserUri =
      "deleteReceiveFeedbackUser";
  static const String uploadCoverPictureUri = "uploadCoverPicture";

  // dashboard
  static const String getAssignedTestsUri = "getAssignedTests";
  static const String saveAssessmentLinkUri = "saveAssessmentLink";
  static const String getHabitJournalBulletsDetailUri =
      "getHabitJournalBulletsDetail";
  static const String saveHabitBulletUri = "saveHabitBullet";
  static const String saveJournalDataUri = "saveJournalData";
  static const String deleteHabitJournalReminderUri =
      "deleteHabitJournalReminder";
  static const String getDailyqHabitJournalHistoryUri =
      "getDailyqHabitJournalHistory";
  static const String getdailyqhabitJournaleminderUri =
      "getdailyqhabitJournaleminder";
  static const String savedailyqhabitJournaleminderUri =
      "savedailyqhabitJournaleminder";
  static const String getActionItemsUri = "getActionItems";
  static const String getAssessmentBadgesDetailUri =
      "getAssessmentBadgesDetail";
  static const String getForumPollQuestionAnswerUri =
      "getForumPollQuestionAnswer";
  static const String addRemoveReminderTagUri = "addRemoveReminderTag";

  static const String showAllForumPollsUri = "showAllForumPolls";
  static const String addAnswerUri = "addAnswer";
  static const String viewResponseUri = "viewResponse";
  static const String viewQuestionAnswerDetailUri = "viewQuestionAnswerDetail";
  static const String suggestQuestionUri = "suggestQuestion";
  static const String followHashtagUri = "followHashtag";
  static const String getDashboardVideoQuickLinkDetailsUri =
      "getDashboardVideoQuickLinkDetails";

  static const String myLearningUri = "myLearning";
  static const String updateMyChecklistUri = "updateMyChecklist";

  static const String updateTourOverlayFlagUri = "updateTourOverlayFlag";

  // development
  static const String existdevelopmentMenuUri = "existdevelopmentMenu";
  static const String getSelfReflectDetailsUri = "getSelfReflectDetails";
  static const String getAssessmentDetailsUri = "getAssessmentDetails";
  static const String getTargetingDetailsUri = "getTargetingDetails";
  static const String getGoalAchievementsDetailsUri =
      "getGoalAchievementsDetails";
  static const String getReputationFeedbackDetailsUri =
      "getReputationFeedbackDetails";
  static const String updateSelfReflectDetailsUri = "updateSelfReflectDetails";
  static const String inviteUserReputationUri = "inviteUserReputation";
  static const String shareWithSupervisorUri = "shareWithSupervisor";
  static const String enableGoalUri = "enableGoal";
  static const String getGoalPopupDetailsUri = "getGoalPopupDetails";

  static const String eLearningDetailsUri = "eLearningDetails";
  static const String getCompReflectDetailsUri = "getCompReflectDetails";
  static const String courseDetailsUri = "courseDetails";
  static const String saveCourseQuestionAnswerUri = "saveCourseQuestionAnswer";

  static const String updateCompentencyDetailsUri = "updateCompentencyDetails";
  static const String getGraphDetailsUri = "getGraphDetails";
  static const String getGraphCompentencyDetailsUri =
      "getGraphCompentencyDetails";

  static const String updateGoalButtonUri = "updateGoalButton";
  static const String getmyJourneyUri = "getmyJourney";
  static const String enableRecognizeUri = "enableRecognize";
  static const String getBadgeLegendPopupUri = "getBadgeLegendPopup";
  static const String developmentLeftMenuListUri = "developmentLeftMenuList";
  static const String emotionGraphUri = "emotionGraph";

  static const String resetSurveyDetailsUri = "resetSurveyDetails";
  static const String myJourneyGrowthChartUri = "myJourneyGrowthChart";
  static const String getProgressTrackingChartUri = "getProgressTrackingChart";
  static const String updateImportantDataUri = "updateImportantData";
  static const String getEmotionReminderUri = "getEmotionReminder";
  static const String saveEmotionReminderUri = "saveEmotionReminder";
  static const String clearEmotionDataUri = "clearEmotionData";

  static const String journeyCertificateDetailsUri =
      "journeyCertificateDetails";

  static const String getReputationFeedbackUserListUri =
      "getReputationFeedbackUserList";
  static const String getReputationFeedbackSliderListUri =
      "getReputationFeedbackSliderList";

  // store
  static const String getStoreDetailsUri = "getStoreDetails";
  static const String getStoreCoachDetailsUri = "getStoreCoachDetails";
  static const String getCartDetailsUri = "getCartDetails";

  static const String addToCardDetailUri = "addToCardDetail";
  static const String renewProductUri = "renewProduct";
  static const String verifyPromocodeUri = "verifyPromocode";

  static const String getPreCardDetailsUri = "getPreCardDetails";
  static const String getPostCardDetailsUri = "getPostCardDetails";

  static const String updateDataInSessionUri = "updateDataInSession";
  static const String makePaymentUri = "makePayment";
  static const String applyCampaignPromocodeUri = "applyCampaignPromocode";

  static const String updateToViewQuickLinksUri = "updateToViewQuickLinks";
  static const String referAndEarnUri = "referAndEarn";

  // enterprise module

  static const String getEnterpriseDetailsUri = "getEnterpriseDetails";
  static const String newsListingUri = "newsListing";
  static const String newsDetailsUri = "newsDetails";
  static const String enterpriseCourseDetailsUri = "enterpriseCourseDetails";
  static const String saveQuizQuestionAnswerUri = "saveQuizQuestionAnswer";
  static const String addToCartCourseUri = "addToCartCourse";
  static const String followEnterpriseUri = "followEnterprise";
  static const String emptyCartUri = "emptyCart";
  static const String addNewsCommentUri = "addNewsComment";

  // General API
  static const String getCommonDataUri = "getCommonData";

  static const String allowNotificationUri = "allowNotification";

  // ==========================================================

  // Shared Key
  static const String isLogin = 'is_login';
  static const String isOnBoadring = 'is_onboarding';
  static const String token = 'token';
  static const String useName = 'username';
  static const String passWord = 'password';

  //App bar size
  static double appBarHeight = 45.sp;
  static double screenHorizontalPadding = 12.sp;

  // screen index no
  static const int todayIndex = 0;
  static const int connectionsIndex = 1;
  static const int myProfileIndex = 2;
  static const int discoverIndex = 3;
  static const int menuIndex = 4;

  // static const int unSelectedIndex = 500;

  // tab name
  static const String selfReflection = "Self-Reflection";
  static const String reputation = "Reputation";
  static const String aspireVueTargeting = "AspireVue Targeting";
  static const String assess = "Assess";
  static const String eLearning = "eLearning";

  static const String goal = "Goal";
  static const String goalAchievement = "Goal Achievement";

  // static module id

  static const String traitsId = "1";
  static const String workSkillId = "7";
  static const String valuesId = "3";
  static const String riskFactorsId = "2";
  static const String leaderStyleId = "9";
  static const String emotionsId = "5";
  static const String compentencyId = "10";
  static const String cognitiveId = "4";
  static const String characterStengthID = "8";
  static const String behaviousId = "6";

  // overley index

  static const int profileOverLayIndex = 1;
  static const int notificationOverLayIndex = 2;
  static const int getStartVideoOverLayIndex = 3;
  static const int gloabalSearchOverLayIndex = 4;
  static const int quickLinkOverLayIndex = 5;
  static const int personalGrowthOverLayIndex = 6;
  static const int goalOverLayIndex = 7;

  static const int insightStreamOverLayIndex = 8;
  static const int actionItemOverLayIndex = 9;
  static const int forumPullOverLayIndex = 10;
  static const int connectionOverLayIndex = 11;
  static const int storeOverLayIndex = 12;
  static const int discoverOverLayIndex = 13;
  static const int menuOverLayIndex = 14;
  static const int startUpMenuOverLayIndex = 15;

  static const String profileOverLayDescription =
      "Before you start aspiring, go ahead and complete your personal info, privacy settings, notifications, leader signature, and more!";
  static const String notificationOverLayDescription =
      "Opt-in and customize your account notifications to stay informed of AspireVue account activity that’s important to you.";
  static const String getStartVideoOverLayDescription =
      "View these 5 videos to hit the ground running.";
  static const String quickLinkOverLayDescription =
      "Add your active modules to the Dashboard for easy one-touch access.";
  static const String insightStreamOverLayDescription =
      "A positive place to connect with others in the AspireVue community in a purposeful way with posts, photos, videos, etc. This is an encouraging social media feed where you can be inspired to achieve something great.";
  static const String actionItemStreamOverLayDescription =
      "Get stuff done in no time within Action Items.";
  static const String forumPullOverLayDescription =
      "Forum Poll questions offer interesting topics related to personal well-being, growth, psychological capacity, leading, and developing and influencing others. Follow any topic hashtag to re-visit the topic quickly through your Connections page. ";
  static const String gloabalOverLayDescription =
      "Your global search for AspireVue connections, companies, hashtag links, topics, coaches, and more!";

  static const String connectionOverLayDescription =
      "Build your network. Start with people you know, like colleagues, close friends, and family members - aim for 30 to start.";
  static const String personalGrowthOverLayDescription =
      "Unleash personal motivation with a well-defined development road map and real-time performance picture. Your Journey Summary offers a single location to track growth over time within 10 targeted arenas using self-appraisal and assessment data. Consider adding a Journey’s 360 subscription or e-learning courses to supercharge your personal performance.";
  static const String storeOverLayDescription =
      "Manage subscription options, leverage assessments to increase self-awareness, and gain access to an executive coach for greater focus and prioritization.";
  static const String discoverOverLayDescription =
      "A collection of AspireVue tutorial videos, insightful podcasts, and short hot topic episodes all designed to encourage disciplined goal setting and increase your impact.";
  static const String menuOverLayDescription =
      "Gain quick access to app features and workflow such as Goals, Development Journeys, Poll Forums, Insight Stream, and AspireVue Help.";
  static const String startUpMenuOverLayDescription =
      "Get a sense of direction within the app by performing simple actions on the user Checklist menu.";

  static const String goalOverLayDescription =
      "Create really effective goals using a unique 3-step OKR guided sequence, then monitor your progress! ";

  // user role name

  static const String userRoleSelf = "self";
  static const String userRoleSupervisor = "superviser";

  static const String stripeKey =
      "pk_test_51NQBkKKWinelMwr0SzY5fWc4YYGJS88xU7QuonXieWiar1jrEyFIB5dhmlxv6a4oB9lNvcGrRcjruixrnnqB7dxH00w4TCscsr";

  // client test key
  // pk_test_51NQBkKKWinelMwr0SzY5fWc4YYGJS88xU7QuonXieWiar1jrEyFIB5dhmlxv6a4oB9lNvcGrRcjruixrnnqB7dxH00w4TCscsr

  // jay test key
  // pk_test_51O0LgmSJ8L5rWki8ioXAn7BFK8j3kmO7tDJuiSl682aUGf3VFjCpZmFl4bmesBJZyLiyMKzlKC4ACStymYYqMBrB00711S2ddi
}
