// import 'package:aspirevue/controller/main_controller.dart';
// import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
// import 'package:aspirevue/util/app_constants.dart';
// import 'package:aspirevue/util/colors.dart';
// import 'package:aspirevue/util/images.dart';
// import 'package:aspirevue/util/sized_box_utils.dart';
// import 'package:aspirevue/util/string.dart';
// import 'package:aspirevue/util/svg_icons.dart';
// import 'package:aspirevue/view/base/custom_text.dart';
// import 'package:aspirevue/view/screens/dashboard/learn_more_screen.dart';
// import 'package:aspirevue/view/screens/main/main_screen.dart';
// import 'package:aspirevue/view/screens/menu/side_menu_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';

// class BottomNavBarUnselected extends StatefulWidget {
//   const BottomNavBarUnselected({
//     super.key,
//     required this.isFromMain,
//     this.onchange,
//   });

//   final bool isFromMain;
//   final Function(int)? onchange;

//   @override
//   State<BottomNavBarUnselected> createState() => _BottomNavBarUnselectedState();
// }

// class _BottomNavBarUnselectedState extends State<BottomNavBarUnselected> {
//   var mainController = Get.find<MainController>();

//   @override
//   void initState() {
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _customBottomBar(),
//       ],
//     );
//   }

//   Widget _customBottomBar() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 4.sp),
//       decoration: BoxDecoration(
//         color: AppColors.labelColor4,
//         borderRadius: BorderRadius.circular(2.sp),
//       ),
//       height: 50.sp,
//       child: Row(
//         children: [
//           _buildBottomNavItem(
//             SvgImage.homeBottom,
//             AppString.dashboard,
//             mainController.currentBottomSheetIndex.value ==
//                 AppConstants.todayIndex,
//             AppConstants.todayIndex,
//           ),
//           _buildBottomNavItem(
//             SvgImage.connectionBotton,
//             AppString.connections,
//             mainController.currentBottomSheetIndex.value ==
//                 AppConstants.connectionsIndex,
//             AppConstants.connectionsIndex,
//           ),
//           _buildBottomNavItem(
//             SvgImage.cartBottom,
//             AppString.store,
//             mainController.currentBottomSheetIndex.value ==
//                 AppConstants.myProfileIndex,
//             AppConstants.myProfileIndex,
//           ),
//           _buildBottomNavItem(
//               SvgImage.discoveryBottom,
//               AppString.discover,
//               mainController.currentBottomSheetIndex.value ==
//                   AppConstants.discoverIndex,
//               AppConstants.discoverIndex),
//           _buildBottomNavItem(
//               SvgImage.menuBottom,
//               AppString.menu,
//               mainController.currentBottomSheetIndex.value ==
//                   AppConstants.menuIndex,
//               AppConstants.menuIndex),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavItem(
//       String image, String title, bool isSelected, int tabIndex) {
//     return Expanded(
//         child: InkWell(
//       onTap: () {
//         _navigate(tabIndex);
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           3.sp.sbh,
//           Expanded(
//             flex: 2,
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(isSelected ? 1.sp : 2.sp),
//                 child: SvgPicture.asset(
//                   image,
//                   height: isSelected ? 16.sp : 15.sp,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//               child: CustomText(
//             fontWeight: FontWeight.w600,
//             fontSize: 8.sp,
//             color: AppColors.white,
//             text: title,
//             textAlign: TextAlign.start,
//             fontFamily: AppString.manropeFontFamily,
//           )),
//           3.sp.sbh,
//         ],
//       ),
//     ));
//   }

//   _navigate(int val) {
//     if (val == AppConstants.menuIndex || val == AppConstants.discoverIndex) {
//       if (mainController.currentBottomSheetIndex.value != val) {
//         if (val == AppConstants.discoverIndex) {
//           Navigator.of(context).push(_goToMenu(const LearnMoreScreen()));
//         } else {
//           // mainController.addToStackAndNavigate(AppConstants.unSelectedIndex);
//           Navigator.of(context).push(_goToMenu(const SideMenuScreen()));
//         }
//       }
//     } else {
//       mainController.addToStackAndNavigate(val);

//       Get.offAll(const MainScreen(
//         isLoadData: false,
//       ));
//     }
//   }

//   Route _goToMenu(Widget widgetToGO) {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) => widgetToGO,
//       transitionDuration: const Duration(milliseconds: 700),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(1.0, 0.0);
//         const end = Offset.zero;
//         const curve = Curves.easeIn;

//         var tween =
//             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//         return SlideTransition(
//           position: animation.drive(tween),
//           child: child,
//         );
//       },
//     );
//   }
// }
