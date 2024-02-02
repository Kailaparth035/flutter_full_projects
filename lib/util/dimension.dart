import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Dimensions {
  static double fontSizeExtraSmall = Get.context!.width >= 1300 ? 14 : 10;
  static double fontSizeSmall = Get.context!.width >= 1300 ? 16 : 12;
  static double fontSizeDefault = Get.context!.width >= 1300 ? 18 : 14;
  static double fontSizeLarge = Get.context!.width >= 1300 ? 20 : 15;
  static double fontSizeExtraLarge = Get.context!.width >= 1300 ? 22 : 16;
  static double fontSizeOverLarge = Get.context!.width >= 1300 ? 28 : 20;

  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 15.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;

  static double radiusSmall = 4.sp;
  static double radiusDefault = 8.sp;
  static double radiusLarge = 12.sp;
  static double radiusExtraLarge = 17.sp;
  static double radiusContainer = 27.sp;

  static const double formFieldHeight = 48;
  static const double webMixWidth = 1170;

  static double getHeight(double screenHeight, {required double percentage}) {
    return screenHeight * (percentage / 100.0);
  }

  static double getWidth(double screenWidth, {required double percentage}) {
    return screenWidth * (percentage / 100.0);
  }
}
