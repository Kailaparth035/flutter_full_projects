import 'dart:async';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  final LocalAuthentication auth = LocalAuthentication();

  final _profileSharedPrefController = Get.find<ProfileSharedPrefService>();

  late List<BiometricType> availableBiometrics;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getAvailableBiometrics();
    });
  }

  Future<void> _getAvailableBiometrics() async {
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      if (kDebugMode) {
        debugPrint("====> ${e.toString()}");
      }
    } catch (e) {
      availableBiometrics = <BiometricType>[];
      if (kDebugMode) {
        debugPrint("====> ${e.toString()}");
      }
    }
    bool authenticated = false;
    if (availableBiometrics.isNotEmpty) {
      try {
        authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true, useErrorDialogs: false),
        );
      } on PlatformException catch (e) {
        if (kDebugMode) {
          debugPrint("====> ${e.toString()}");
        }

        return;
      }
      if (!mounted) {
        return;
      }
      if (authenticated) {
        _checkLoggin();
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          _getAvailableBiometrics();
        });
      }
    } else {
      Timer(const Duration(seconds: 2), () async {
        _checkLoggin();
      });
    }
  }

  _checkLoggin() async {
    var res = showOnBoardingScreen();
    if (res == true) {
      return;
    }

    if (_profileSharedPrefController.isLoggedIn()) {
      // var sharedController = Get.find<ProfileSharedPrefService>();
      _profileSharedPrefController.getUserData();

      try {
        await _profileSharedPrefController.getMyProfile({});
        Get.offAllNamed(RouteHelper.getMainRoute());
      } catch (e) {
        debugPrint("====> ${e.toString()}");
        _goToLoginScreen();
        return;
      }
    } else {
      _goToLoginScreen();
    }
  }

  _goToLoginScreen() {
    // checking user comming from dynamic link so open register screen if link have referralCode in URl

    Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
  }

  bool showOnBoardingScreen() {
    bool isShowOnBoarding = _profileSharedPrefController.isShowOnBoarding();
    if (isShowOnBoarding) {
      Get.offAllNamed(RouteHelper.getOnBoardingRoute());

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      color: Colors.transparent,
      child: Scaffold(
        key: _globalKey,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                gradient:
                    CommonController.getLinearGradientSecondryAndPrimary()),
            child: Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.h),
                  child: Image.asset(AppImages.logo)),
            ),
          ),
        ),
      ),
    );
  }
}
