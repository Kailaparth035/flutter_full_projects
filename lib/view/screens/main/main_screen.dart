import 'dart:async';
import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/custom_bottom_navbar.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/main/notification_list_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/my_connection_main_screen.dart';
import 'package:aspirevue/view/screens/menu/store/store_main_screen.dart';
import 'package:aspirevue/view/screens/profile/profile_drawer_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';
import '../../../util/colors.dart';
import '../../../util/string.dart';
import '../../base/custom_snackbar.dart';
import '../dashboard/dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.isLoadData});
  final bool isLoadData;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> _screens;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _canExit = false;
  final _maincontroller = Get.find<MainController>();
  final _profileSharedPrefService = Get.find<ProfileSharedPrefService>();

  _initController() async {
    if (widget.isLoadData) {
      // CommonController().checkForUpdate();
      _maincontroller.initController();
      _maincontroller.updateUserDeviceToken();
    }
  }

  _checkNotificaitonInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _profileSharedPrefService.isShowOverlayView.value = false;
      // _profileSharedPrefService.isOverlayStarted.value = false;
      _profileSharedPrefService.isFromNotification.value = true;

      Get.to(const NotificationListScreen());
    }
  }

  @override
  void initState() {
    super.initState();

    _checkNotificaitonInitialMessage();

    _initController();

    _screens = [
      DashboardScreen(scaffoldKey: _scaffoldKey),
      MyConnctionMainScreen(
        isShowBottomSheet: false,
        onBackPress: () {
          _setPageBack(_maincontroller);
        },
      ),
      StoreMainScreen(
        isFromMenu: true,
        onBackPress: () {
          _setPageBack(_maincontroller);
        },
      ),
      const Center(
        child: Text(''),
      ),
      const Center(
        child: Text(''),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (MainController mainController) {
      return PopScope(
        canPop: _scaffoldKey.currentState == null
            ? false
            : _scaffoldKey.currentState!.isEndDrawerOpen
                ? false
                : mainController.currentBottomSheetIndex.value != 0
                    ? false
                    : _canExit,
        onPopInvoked: (val) {
          if (_scaffoldKey.currentState!.isEndDrawerOpen) {
            _scaffoldKey.currentState!.closeEndDrawer();
          } else {
            if (mainController.currentBottomSheetIndex.value != 0) {
              _setPageBack(mainController);
            } else {
              if (_canExit) {
              } else {
                showCustomSnackBarWithMessage(AppString.backPressAgainToExist);
                setState(() {
                  _canExit = true;
                });
                Timer(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      _canExit = false;
                    });
                  }
                });
              }
            }
          }
        },
        child: SafeArea(
          child: CommonController.getAnnanotaion(
            color: AppColors.white,
            child: UpgradeAlert(
              upgrader: Upgrader(
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: Stack(
                children: [
                  _buildMainScafold(context, mainController),
                  Obx(() {
                    return _profileSharedPrefService.isShowOverlayView.value ==
                            false
                        ? 0.sbh
                        : Container(
                            color: Colors.black.withOpacity(0.1),
                            height: 100.h,
                            width: 100.w,
                          );
                  })
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMainScafold(
      BuildContext context, MainController mainController) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: const ProfileDrawer(isFromAboutScreen: false),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: <Widget>[
            GetBuilder(builder:
                (ProfileSharedPrefService profileAndSherepfController) {
              if (profileAndSherepfController.isLoading) {
                return const Expanded(
                  child: Center(
                    child: CustomLoadingWidget(),
                  ),
                );
              }

              if (profileAndSherepfController.isError) {
                return Expanded(
                  child: Center(
                    child: CustomErrorWidget(
                      onRetry: () async {
                        await profileAndSherepfController.getMyProfile({});

                        _initController();
                      },
                      text: profileAndSherepfController.errorMsg.toString(),
                    ),
                  ),
                );
              }

              return Expanded(
                child: _screens[mainController.currentBottomSheetIndex.value],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        isFromMain: true,
        onchange: (val) {},
      ),
    );
  }

  void _setPageBack(MainController mainController) {
    mainController.remoteToStackAndNavigateBack(true);
  }

  @override
  void dispose() {
    _maincontroller.disposeController();
    super.dispose();
  }
}
