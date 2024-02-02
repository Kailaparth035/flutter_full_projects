import 'dart:io';
import 'package:aspirevue/controller/auth_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/controller/store_file_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/permission_utils.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/alert_dialogs/play_store_alert_dialog.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/screens/menu/development/modules/behaviors/behaviors_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/character_strengths/character_strengths_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/cognitive/cognitive_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/compentency/compentency_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/emotions/emotions_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/leader_style/leader_style_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/risk_fectors/risk_fectors_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/traits/traits_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/values/values_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/work_skills/work_skill_module_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class CommonController {
  double calculateNumber(double number) {
    int valueToDivide = 0;

    if (number >= 0 && number <= 5) {
      valueToDivide = 5;
    } else if (number >= 6 && number <= 15) {
      valueToDivide = 15;
    } else if (number >= 16 && number <= 30) {
      valueToDivide = 30;
    } else if (number >= 31 && number <= 50) {
      valueToDivide = 50;
    } else if (number >= 51 && number <= 1000) {
      valueToDivide = 100;
    } else if (number >= 1001 && number <= 10000) {
      valueToDivide = 200;
    } else if (number >= 10001 && number <= 100000) {
      valueToDivide = 1000;
    } else {
      valueToDivide = 10000;
    }

    double a = number % valueToDivide;

    if (a > 0) {
      return (number ~/ valueToDivide) * valueToDivide +
          valueToDivide.toDouble();
    }

    return number;
  }

  // properties
  static List<BoxShadow> get getBoxShadow => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.25),
          spreadRadius: -0.5,
          blurRadius: 2,
          offset: const Offset(0, 0.7),
        ),
      ];

  static LinearGradient getLinearGradientSecondryAndPrimary(
          {double? optacity}) =>
      LinearGradient(colors: [
        AppColors.secondaryColor.withOpacity(optacity ?? 1),
        AppColors.primaryColor.withOpacity(optacity ?? 1),
      ], stops: const [
        0.0,
        0.7,
      ]);

  // open Url in Browser
  static urlLaunch(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } else {
      showCustomSnackBar("${AppString.couldnotlaunch} $url");
    }
  }

  getIntValueFromString(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0;
    }
  }

  static urlLaunchInApp(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
      showCustomSnackBar("${AppString.couldnotlaunch} $url");
    }
  }

  static bool getIsIOS() {
    if (kIsWeb) {
      return false;
    } else if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  static bool getIsAndroid() {
    if (kIsWeb) {
      return false;
    } else if (Platform.isAndroid) {
      return true;
    } else {
      return false;
    }
  }

  // file picker
  static Future<List<File>?> getFilePicker() async {
    if (getIsIOS()) {
      bool? isPermitGranted =
          await PermissionUtils.takePermission(Permission.photos);

      if (isPermitGranted == null || isPermitGranted == false) {
        return null;
      }
    }

    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['doc', "docx", "xlsx", "xls"],
    );

    if (result != null) {
      List<File> files =
          result.paths.map((path) => File(path.toString())).toList();

      return files;
    } else {
      return null;
    }
  }

// hide keyboard

  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static unFocusKeyboard() {
    FocusManager.instance.primaryFocus!.unfocus();
  }

  // download
  static downloadFile(String url, BuildContext context) async {
    buildDownloadLoading(Get.context!);
    try {
      var file = await StoreFile().loadPdfFromNetwork(url);

      showCustomSnackBar("${AppString.downloadSuccessfully} \n ${file.path}",
          isError: false);

      OpenFile.open(file.path).then((value) async {
        if (value.message.contains("No APP found to open this file")) {
          var res = await showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return const PlaystoreAlertDialogWidget();
            },
          );

          if (res != null && res == true) {
            CommonController.urlLaunch(
                "https://play.google.com/store/search?q=doc");
          }
        }
        debugPrint("====> ${value.message}");
      }).catchError((onError) {
        showCustomSnackBar(onError.toString(), isError: true);
      });
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error, isError: true);
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  // get annanotation
  static Widget getAnnanotaion({required Widget child, Color? color}) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getIsAndroid()
          ? SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: color ?? AppColors.backgroundColor1)
          : SystemUiOverlayStyle.light
              .copyWith(statusBarColor: color ?? AppColors.backgroundColor1),
      child: child,
    );
  }

  // get Thumbnail

  static Future<File?> generateThumbnail(String pathfrom) async {
    final String? path = await VideoThumbnail.thumbnailFile(
      video: pathfrom,
      thumbnailPath: (await getTemporaryDirectory()).path,

      /// path_provider
      imageFormat: ImageFormat.PNG,
      maxHeight: 200,
      quality: 50,
    );

    if (path != null) {
      return File(path);
    } else {
      return null;
    }
  }

  // pick Image
  static Future<XFile?> pickImage({ImageSource? imageSource}) async {
    if (getIsIOS()) {
      bool? isPermitGranted =
          await PermissionUtils.takePermission(Permission.photos);

      if (isPermitGranted == null || isPermitGranted == false) {
        return null;
      }
    }

    if (imageSource != null && imageSource == ImageSource.camera) {
      bool? isPermitGranted =
          await PermissionUtils.takePermission(Permission.camera);

      if (isPermitGranted == null || isPermitGranted == false) {
        return null;
      }
    }

    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(
      source: imageSource ?? ImageSource.gallery,
    );
  }

  // Compress video
  static Future<MediaInfo?> compressVideo(XFile xfilePick) async {
    MediaInfo? result = await VideoCompress.compressVideo(
      xfilePick.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
    );
    return result;
  }

  // pick Image
  static Future<List<XFile>?> pickImages() async {
    if (getIsIOS()) {
      bool? isPermitGranted =
          await PermissionUtils.takePermission(Permission.photos);

      if (isPermitGranted == null || isPermitGranted == false) {
        return null;
      }
    }
    final ImagePicker picker = ImagePicker();
    return await picker.pickMultiImage();
  }

  static Future<CroppedFile?> cropImageForCoverImage(
    XFile image,
    BuildContext context,
  ) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      // aspectRatioPresets: [],

      aspectRatio: const CropAspectRatio(ratioX: 20, ratioY: 7),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    return croppedFile;
  }

  static Future<CroppedFile?> cropImage(XFile image, BuildContext context,
      {required bool isProfile}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      cropStyle: isProfile ? CropStyle.circle : CropStyle.rectangle,
      aspectRatioPresets: [
        isProfile
            ? CropAspectRatioPreset.square
            : CropAspectRatioPreset.ratio3x2
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: isProfile ? true : false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    return croppedFile;
  }

  // select Date
  Future<String?> pickDate(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
      return formattedDate;
    } else {
      return null;
    }
  }

  String convertStringToYYMMDD(String savedDateString) {
    DateTime tempDate = DateFormat("yyyy/dd/MM").parse(savedDateString);
    return DateFormat('yyyy/dd/MM').format(tempDate);
  }

  Future<DateTimeRange?> pickMulitpleDates(
    BuildContext context,
  ) async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  static double getPercent(String value) {
    try {
      var data = double.parse(value) / 100;
      return data;
    } catch (e) {
      return 0;
    }
  }

  static double getSliderValue(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0;
    }
  }

  static int getWidgetIndex(
      String? tabName, List<DevelopmetTabModel> titleList) {
    if (tabName == null) {
      return 0;
    }
    var selectedModel =
        titleList.where((element) => element.title == tabName).toList();

    if (selectedModel.isEmpty) {
      return 0;
    }

    return titleList.indexOf(selectedModel.first);
  }

  checkForUpdate() async {
    // try {
    //   final newVersion = NewVersionPlus(
    //     iOSId: 'com.mobile.aspirevue',
    //     androidId: 'com.mobile.aspirevue',
    //     androidPlayStoreCountry: "es_ES",
    //     androidHtmlReleaseNotes: true, //support country code
    //   );

    //   final status = await newVersion.getVersionStatus();

    //   print("com=====> $status");
    // } catch (e) {
    //   print("com=====> $e");
    // }
  }

  static ratingApp() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      var res = await inAppReview.isAvailable();
      if (res) {
        inAppReview.requestReview();
      } else {
        debugPrint("===> app is not available on playstore");
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    }
  }

  TabBar buildTabbar(
      TabController? controller, List<DevelopmetTabModel> titleList) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicator: BoxDecoration(
        boxShadow: CommonController.getBoxShadow,
        gradient: LinearGradient(colors: [
          AppColors.secondaryColor.withOpacity(0.9),
          AppColors.primaryColor.withOpacity(0.9)
        ], stops: const [
          0.0,
          0.7,
        ]),
        borderRadius: BorderRadius.circular(20.sp),
      ),
      indicatorPadding:
          EdgeInsets.only(right: 11.sp, top: 1.sp, bottom: 1.sp, left: 1.sp),
      labelPadding: EdgeInsets.symmetric(horizontal: 0.sp),
      padding: EdgeInsets.all(10.sp),
      unselectedLabelColor: Colors.grey,
      labelColor: AppColors.white,
      splashBorderRadius: BorderRadius.circular(20),
      splashFactory: NoSplash.splashFactory,
      indicatorSize: TabBarIndicatorSize.label,
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return states.contains(MaterialState.focused)
              ? Colors.transparent
              : Colors.transparent;
        },
      ),
      tabs: [
        ...titleList.where((element) => element.isEnable == true).map(
              (e) => Container(
                padding: EdgeInsets.all(10.sp),
                margin: EdgeInsets.only(right: 10.sp),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.black.withOpacity(0.05),
                    AppColors.black.withOpacity(0.05),
                  ], stops: const [
                    0.0,
                    0.7,
                  ]),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Text(e.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppString.manropeFontFamily,
                      )),
                ),
              ),
            )
      ],
    );
  }

  String getValidErrorMessage(String e) {
    // if (["is not a subtype of type"].any(e.contains)) {
    //   return "Response is changed from backend!";
    // } else {
    //   return e;
    // }

    return e;
  }

  static double getDoubleValue(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0;
    }
  }

  static sharePostToEveryWhere(String url) async {
    try {
      if (url != "") {
        await Share.shareUri(Uri.parse(url));
      } else {
        showCustomSnackBar("Share URL is not available.", isError: true);
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    }
  }

  shareInWhatsapp() async {
    // final temp = await getTemporaryDirectory();

    // final image = (await rootBundle
    //     .load("assets/images/app_icon.png")); // convert in to Uint8List
    // final buffer = image.buffer;
    // final path = '${temp.path}/imageToShare.jpg';

    // var file = XFile.fromData(
    //   buffer.asUint8List(image.offsetInBytes, image.lengthInBytes),
    //   name: "Aspirevue",
    //   mimeType: "image/png",
    // );

    // file.saveTo(path);
    var profileController = Get.find<ProfileSharedPrefService>();
    if (await WhatsappShare.isInstalled() == true) {
      await WhatsappShare.share(
          text: profileController.profileData.value.referalText.toString(),
          phone: '90');
    } else {
      var res = await showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return const PlaystoreAlertDialogWidget();
        },
      );

      if (res != null && res == true) {
        CommonController.urlLaunch(
            "https://play.google.com/store/search?q=whatsapp");
      }
    }
  }

  shareInvitation() async {
    try {
      var profileController = Get.find<ProfileSharedPrefService>();
      final image = (await rootBundle
          .load("assets/images/app_icon.png")); // convert in to Uint8List
      final buffer = image.buffer;

      // Share
      await Share.shareXFiles([
        XFile.fromData(
          buffer.asUint8List(image.offsetInBytes, image.lengthInBytes),
          name: "Aspirevue",
          mimeType: "image/png",
        ),
      ],
          subject:
              profileController.profileData.value.referalSubject.toString(),
          text: profileController.profileData.value.referalText.toString());
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    }
  }

  logout() async {
    var res = await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title: AppString.areYouSureWantLogOut,
        );
      },
    );
    if (res != null) {
      var map = <String, dynamic>{};
      var mainController = Get.find<MainController>();
      mainController.addToStackAndNavigate(AppConstants.todayIndex);
      var sharedPrefServiceController = Get.find<ProfileSharedPrefService>();
      buildLoading(Get.context!);
      Get.find<AuthController>()
          .logout(map, sharedPrefServiceController)
          .then((status) async {
        if (status.isSuccess == true) {
          showCustomSnackBar(status.message, isError: false);
          Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
        } else {
          Navigator.pop(Get.context!);
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}

Future shareFileAndText(List<Uint8List> uint8list) async {
  // var mime = lookupMimeType('', headerBytes: data);
  // var extension = extensionFromMime(mime);
  // var mime = lookupMimeType('', headerBytes: uint8list.first);
  // var extension = extensionFromMime(mime!);
  // debugPrint(extension);
  try {
    // var listFile = uint8list
    //     .map((e) => XFile.fromData(
    //           e,
    //           name: "Aspirevue",
    //           mimeType: lookupMimeType('', headerBytes: e),
    //         ))
    //     .toList();
    // Share
    // await Share.shareXFiles(listFile, subject: "subject", text: "text");
  } catch (e) {
    showCustomSnackBar(e.toString(), isError: true);
  }
}

String getTabName(String type) {
  if (type == "reflect") {
    return AppConstants.selfReflection;
  } else if (type == "reputation") {
    return AppConstants.reputation;
  } else if (type == "traits") {
    return AppConstants.goal;
  } else if (type == "assess") {
    return AppConstants.assess;
  } else if (type == "eLearning") {
    return AppConstants.eLearning;
  } else if (type == "target") {
    return AppConstants.aspireVueTargeting;
  } else if (type == "goal") {
    return AppConstants.goalAchievement;
  } else {
    return "";
  }
}

navigateTODevelopmentScreen({
  required DevelopmentType developmentType,
  required UserRole userRole,
  required String userId,
  required String tabTypeRow,
  required bool isShowElarning,
}) {
  if (developmentType == DevelopmentType.workSkills) {
    Get.to(() => WorkSkillModuleScreen(
        isShowLearning: isShowElarning,
        tabName: tabTypeRow,
        userId: userId,
        userRole: userRole));
  } else if (developmentType == DevelopmentType.competencies) {
    Get.to(() => CompetencyModuleScreen(
          isShowLearning: isShowElarning,
          tabName: tabTypeRow,
          userId: userId,
          userRole: userRole,
        ));
  } else if (developmentType == DevelopmentType.traits) {
    Get.to(() => TraitsModuleScreen(
          isShowLearning: isShowElarning,
          tabName: tabTypeRow,
          userId: userId,
          userRole: userRole,
        ));
  } else if (developmentType == DevelopmentType.values1) {
    Get.to(() => ValuesModuleScreen(
          isShowLearning: isShowElarning,
          tabName: tabTypeRow,
          userId: userId,
          userRole: userRole,
        ));
  } else if (developmentType == DevelopmentType.riskFactors) {
    Get.to(() => RiskFectorsModuleScreen(
          isShowLearning: isShowElarning,
          tabName: tabTypeRow,
          userId: userId,
          userRole: userRole,
        ));
  } else if (developmentType == DevelopmentType.leaderStyle) {
    Get.to(() => LeaderStyleModuleScreen(
          isShowLearning: isShowElarning,
          tabName: tabTypeRow,
          userId: userId,
          userRole: userRole,
        ));
  } else if (developmentType == DevelopmentType.characterStrengths) {
    Get.to(() => CharacterStrengthsModuleScreen(
          isShowLearning: isShowElarning,
          tabName: tabTypeRow,
          userId: userId,
          userRole: userRole,
        ));
  } else if (developmentType == DevelopmentType.emotions) {
    Get.to(() => EmotionsModuleScreen(
          isShowLearning: isShowElarning,
          tabName: tabTypeRow,
          userId: userId,
          userRole: userRole,
        ));
  } else if (developmentType == DevelopmentType.cognitive) {
    Get.to(() => CognitiveModuleScreen(
          isShowLearning: isShowElarning,
          tabName: tabTypeRow,
          userId: userId,
          userRole: userRole,
        ));
  } else if (developmentType == DevelopmentType.behaviors) {
    Get.to(() => BehaviorsModuleScreen(
          isShowLearning: isShowElarning,
          tabName: tabTypeRow,
          userId: userId,
          userRole: userRole,
        ));
  } else {}
}

Widget htmlChildForInfo(String title) {
  return Container(
    height: _getHeight(title),
    width: Get.context!.getWidth,
    padding: EdgeInsets.all(10.sp),
    decoration: BoxDecoration(
      color: AppColors.backgroundColor1,
      borderRadius: BorderRadius.circular(5.sp),
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(title.length.toString()),
          Html(
            data: title,
            style: {
              "*": Style(
                padding: HtmlPaddings.all(0.sp),
                fontSize: FontSize(11.sp),
                margin: Margins.all(0),
              ),
            },
          ),
        ],
      ),
    ),
  );
}

double _getHeight(title) {
  var count = parseHtmlString(title).length;

  if (count <= 50) {
    return 40.sp;
  } else if (count > 50 && count <= 100) {
    return 70.sp;
  } else {
    return count.sp / 2;
  }
}

DevelopmentType? getStyleNameFromStyleId(String styleId) {
  switch (styleId) {
    case AppConstants.workSkillId:
      return DevelopmentType.workSkills;

    case AppConstants.compentencyId:
      return DevelopmentType.competencies;

    case AppConstants.traitsId:
      return DevelopmentType.traits;

    case AppConstants.valuesId:
      return DevelopmentType.values1;

    case AppConstants.riskFactorsId:
      return DevelopmentType.riskFactors;

    case AppConstants.leaderStyleId:
      return DevelopmentType.leaderStyle;

    case AppConstants.characterStengthID:
      return DevelopmentType.characterStrengths;

    case AppConstants.emotionsId:
      return DevelopmentType.emotions;

    case AppConstants.cognitiveId:
      return DevelopmentType.cognitive;

    case AppConstants.behaviousId:
      return DevelopmentType.behaviors;

    default:
      return null;
  }
}

enum PostTypeEnum { insight, hashtag, user }

enum UserInsightStreamEnumType { currentUser, savedPost, otherUser }

enum PostTagType {
  inpiredBy,
  pivotalMoments,
  greatQuote,
  growthFocus,
  iAmFeeling,
  booksIRecommend,
  podcastsIFollow
}

enum DevelopmentType {
  workSkills,
  competencies,
  traits,
  values1,
  valuesStyle2,
  riskFactors,
  riskFactors2,
  leaderStyle,
  characterStrengths,
  emotions,
  cognitive,
  cognitiveStyle2,
  behaviors,
  goal
}

enum CompetencyType { selfReflact, targating, goal }

enum UserRole { supervisor, self }

enum VideoType { wistia, vimeo, youtube, embaded }

enum Availability { loading, available, unavailable }
