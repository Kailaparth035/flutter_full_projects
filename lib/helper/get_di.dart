import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/development/behaviors_controller.dart';
import 'package:aspirevue/controller/development/character_strengths_controller.dart';
import 'package:aspirevue/controller/development/cognitive_controller.dart';
import 'package:aspirevue/controller/development/compentencies_controller.dart';
import 'package:aspirevue/controller/development/emotions_controller.dart';
import 'package:aspirevue/controller/development/leader_style_controller.dart';
import 'package:aspirevue/controller/development/risk_factor_controller.dart';
import 'package:aspirevue/controller/development/traits_controller.dart';
import 'package:aspirevue/controller/development/values_controller.dart';
import 'package:aspirevue/controller/development/work_skill_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/enterprise_controller.dart';
import 'package:aspirevue/controller/growth_community_controller.dart';
import 'package:aspirevue/controller/hashtag_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/mentees_controller.dart';
import 'package:aspirevue/controller/my_coaches_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/controller/my_goal_controller.dart';
import 'package:aspirevue/controller/my_mentors_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/controller/sub_controller/coachee_controller.dart';
import 'package:aspirevue/controller/user_insight_stream_controller.dart';
import 'package:aspirevue/data/repository/development_repo.dart';
import 'package:aspirevue/data/repository/enterprise_repo.dart';
import 'package:aspirevue/data/repository/my_connections_repo.dart';
import 'package:aspirevue/data/repository/store_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/auth_controller.dart';
import '../controller/insight_stream_controller.dart';
import '../data/api/api_client.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/insight_stream_repo.dart';
import '../data/repository/main_repo.dart';
import '../util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences, fenix: true);
  Get.lazyPut(
      () => ApiClient(
          appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()),
      fenix: true);

  // Repository
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(
      () => InsightStreamRepo(
          apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(
      () => MainRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(
      () => MyConnectionRepo(
          apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(
      () =>
          DevelopmentRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(
      () => StoreRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(
      () =>
          EnterpriseRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  // Controller
  Get.lazyPut(() => AuthController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => InsightStreamController(insightStreamRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => HashTagController(insightStreamRepo: Get.find()),
      fenix: true);

  Get.lazyPut(() => UserInsightStreamController(insightStreamRepo: Get.find()),
      fenix: true);

  Get.lazyPut(() => MyConnectionController(myConnectionRepo: Get.find()),
      fenix: true);

  Get.lazyPut(() => GrowthCommunityController(myConnectionRepo: Get.find()),
      fenix: true);

  Get.lazyPut(() => MyCoachesController(myConnectionRepo: Get.find()),
      fenix: true);

  Get.lazyPut(() => MyMentorsController(myConnectionRepo: Get.find()),
      fenix: true);

  Get.lazyPut(() => MenteesController(myConnectionRepo: Get.find()),
      fenix: true);

  Get.lazyPut(() => MyGoalController(myConnectionRepo: Get.find()),
      fenix: true);

  Get.lazyPut(() => CoacheeController(myConnectionRepo: Get.find()),
      fenix: true);

  Get.lazyPut(() => DashboardController(mainRepo: Get.find()), fenix: true);
  Get.lazyPut(() => StoreController(storeRepo: Get.find()), fenix: true);
  Get.lazyPut(() => EnterpriseController(enterPriseRepo: Get.find()),
      fenix: true);

  // developement controller

  Get.lazyPut(() => WorkSkillController(developmentController: Get.find()),
      fenix: true);
  Get.lazyPut(() => CompentenciesController(developmentController: Get.find()),
      fenix: true);
  Get.lazyPut(() => TraitsController(developmentController: Get.find()),
      fenix: true);
  Get.lazyPut(() => ValuesController(developmentController: Get.find()),
      fenix: true);
  Get.lazyPut(() => RiskFactorController(developmentController: Get.find()),
      fenix: true);
  Get.lazyPut(() => LeaderStyleController(developmentController: Get.find()),
      fenix: true);
  Get.lazyPut(
      () => CharacterStrengthsController(developmentController: Get.find()),
      fenix: true);
  Get.lazyPut(() => EmotionsController(developmentController: Get.find()),
      fenix: true);
  Get.lazyPut(() => CognitiveController(developmentController: Get.find()),
      fenix: true);
  Get.lazyPut(() => BehaviorsController(developmentController: Get.find()),
      fenix: true);

  // permenent route
  Get.put(DevelopmentController(developmentRepo: Get.find()), permanent: true);

  try {
    Get.put(
        ProfileSharedPrefService(
            apiClient: Get.find(),
            sharedPreferences: Get.find(),
            mainRepo: Get.find()),
        permanent: true);
  } catch (e) {
    debugPrint("====> $e");
  }
  Get.put(MainController(mainRepo: Get.find()), permanent: true);

  // Retrieving localized data
  Map<String, Map<String, String>> success = {};
  return success;
}
