import 'package:aspirevue/view/screens/auth/terms_condition_screen.dart';
import 'package:aspirevue/view/screens/create_post/create_post_screen.dart';
import 'package:aspirevue/view/screens/lottie_page.dart';
import 'package:aspirevue/view/screens/main/notification_list_screen.dart';
import 'package:aspirevue/view/screens/menu/development/development_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/organization_chart_screen.dart';
import 'package:aspirevue/view/screens/menu/store/payment_screen.dart';
import 'package:aspirevue/view/screens/on_boarding/on_boarding_screen.dart';
import 'package:aspirevue/view/screens/welcome_screens/congratulations_screen.dart';
import 'package:get/get.dart';

import '../view/screens/auth/forgot_password_screen.dart';
import '../view/screens/auth/sign_in_screen.dart';
import '../view/screens/auth/sign_up_screen.dart';
import '../view/screens/insight_stream/insight_screen.dart';
import '../view/screens/main/main_screen.dart';
import '../view/screens/menu/side_menu_screen.dart';
import '../view/screens/splash/splash_screen.dart';

class RouteHelper {
  static const String initial = '/';

  static const String splash = '/splash';
  static const String signIn = '/sign-in';
  static const String main = '/main';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String congratulation = '/congratulation';
  static const String organization = '/organization';
  static const String preferences = '/preferences';
  static const String trial = '/trial';
  static const String termsCondition = '/terms-condition';
  static const String development = '/development';

  static const String myProfile = '/myProfile';
  static const String boxMenu = '/boxMenu';
  static const String insightStream = '/insight-stream';
  static const String createPost = '/create-post';
  static const String organizationChartRoute = '/organization-chart';
  static const String onBoarding = '/OnBoarding';
  static const String tempLottieAnimation = '/tempLottieAnimation';
  // static const String store = '/store';
  static const String paymentScreen = '/paymentScreen';
  static const String notificationScreen = '/notificationScreen';

  static String getInitialRoute() => initial;

  static String notificationScreenRoute() => notificationScreen;

  static String getOnBoardingRoute() => onBoarding;

  // static String getMainRoute(String page) => '$main?page=$page';
  static String getMainRoute() => main;

  static String getSplashRoute() => splash;

  static String getSignInRoute(String page) => '$signIn?page=$page';

  static String getSignUpRoute() => signUp;

  static String getForgotPasswordRoute() => forgotPassword;

  static String getCongratulationRoute() => congratulation;

  static String getOrganizationRoute() => organization;
  static String getPreferencesRoute() => preferences;

  static String getTrialRoute() => trial;

  static String getTermsConditionRoute() => termsCondition;

  static String getDevelopmentRoute() => development;

  // static String getJourneyRoute() => journeys;

  static String getBoxMenuRoute() => boxMenu;

  static String getInsightStreamRoute() => insightStream;

  static String getCreatePostRoute() => createPost;

  static String getOrganizationChartRoute() => organizationChartRoute;

  static String getTempLottieAnimation() => tempLottieAnimation;

  // static String getStoreRoute() => store;

  static String getPaymentScreenRoute() => paymentScreen;

  static List<GetPage> routes = [
    GetPage(name: tempLottieAnimation, page: () => const LottiePage()),
    GetPage(name: initial, page: () => const SplashScreen()),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(
      name: signIn,
      page: () => SignInScreen(exitFromApp: Get.parameters['page'] == splash),
    ),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: congratulation, page: () => const CongratulationScreen()),
    GetPage(name: termsCondition, page: () => const TermsConditionScreen()),
    GetPage(
        name: main,
        page: () => const MainScreen(
              isLoadData: true,
            )),
    GetPage(name: boxMenu, page: () => const SideMenuScreen()),
    GetPage(name: insightStream, page: () => const InsightScreen()),
    GetPage(name: createPost, page: () => const CreatePostScreen()),
    GetPage(
        name: organizationChartRoute,
        page: () => const OrganizationChartScreen()),
    GetPage(name: onBoarding, page: () => const OnBoardingScreen()),
    GetPage(
      name: development,
      page: () => const DevelopmentScreen(),
    ),
    GetPage(
      name: paymentScreen,
      page: () => const PaymentScreen(),
    ),
    GetPage(
      name: notificationScreen,
      page: () => const NotificationListScreen(),
    ),
  ];
}
