// import 'package:aspirevue/controller/auth_controller.dart';
// import 'package:aspirevue/controller/common_controller.dart';
// import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
// import 'package:aspirevue/helper/route_helper.dart';
// import 'package:aspirevue/util/app_constants.dart';
// import 'package:aspirevue/util/colors.dart';
// import 'package:aspirevue/util/dimension.dart';
// import 'package:aspirevue/util/images.dart';
// import 'package:aspirevue/util/string.dart';
// import 'package:aspirevue/view/base/custom_loader.dart';
// import 'package:aspirevue/view/base/custom_snackbar.dart';
// import 'package:aspirevue/view/base/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';

// class CustomSideBar extends StatefulWidget {
//   const CustomSideBar({Key? key, required this.scaffoldKey}) : super(key: key);
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   @override
//   State<CustomSideBar> createState() => _CustomSideBarState();
// }

// class _CustomSideBarState extends State<CustomSideBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       width: (MediaQuery.of(context).size.width * 0.825),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//             topRight: Radius.circular(Dimensions.radiusExtraLarge),
//             bottomRight: Radius.circular(Dimensions.radiusExtraLarge)),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(Dimensions.radiusExtraLarge),
//                 bottomRight: Radius.circular(Dimensions.radiusExtraLarge)),
//             gradient: CommonController.getLinearGradientSecondryAndPrimary()),
//         child: ListView(
//           padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 5.h),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: const AssetImage(AppImages.avtar),
//                       radius: 5.h,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         widget.scaffoldKey.currentState?.closeDrawer();
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(8.sp),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(
//                                 Radius.circular(Dimensions.radiusDefault)),
//                             color: AppColors.white.withOpacity(0.3)),
//                         child: Icon(
//                           Icons.arrow_back,
//                           size: 3.h,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 1.h),
//                 CustomText(
//                   color: AppColors.white,
//                   text: "Jeff Creative",
//                   textAlign: TextAlign.start,
//                   fontFamily: AppString.manropeFontFamily,
//                   fontSize: 13.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 SizedBox(height: 0.1.h),
//                 CustomText(
//                   color: AppColors.white,
//                   text: "CEO of GODigital",
//                   textAlign: TextAlign.start,
//                   fontFamily: AppString.manropeFontFamily,
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 SizedBox(height: 2.h),
//                 Row(
//                   children: [
//                     Row(
//                       children: [
//                         Image.asset(
//                           AppImages.combinedShape,
//                           height: 2.5.h,
//                           width: 6.5.w,
//                         ),
//                         SizedBox(width: 0.1.w),
//                         CustomText(
//                           text: AppString.growthStreak,
//                           textAlign: TextAlign.start,
//                           fontFamily: AppString.manropeFontFamily,
//                           fontSize: 11.sp,
//                           color: AppColors.white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ],
//                     ),
//                     SizedBox(width: 3.w),
//                     Row(
//                       children: [
//                         Image.asset(
//                           AppImages.journeyPoints,
//                           height: 2.5.h,
//                           width: 6.5.w,
//                         ),
//                         SizedBox(width: 0.9.w),
//                         CustomText(
//                           text: AppString.journeyPoints,
//                           textAlign: TextAlign.start,
//                           fontFamily: AppString.manropeFontFamily,
//                           fontSize: 11.sp,
//                           color: AppColors.white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 0.5.h),
//                         child: CustomText(
//                           text: "8",
//                           textAlign: TextAlign.start,
//                           fontFamily: AppString.manropeFontFamily,
//                           fontSize: 14.sp,
//                           color: AppColors.white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 3.w),
//                     Expanded(
//                       child: CustomText(
//                         text: "324",
//                         textAlign: TextAlign.start,
//                         fontFamily: AppString.manropeFontFamily,
//                         fontSize: 14.sp,
//                         color: AppColors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5.h),
//                 Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(10.sp),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(
//                               Radius.circular(Dimensions.radiusLarge)),
//                           color: AppColors.labelColor5.withOpacity(0.3)),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             AppImages.myConnection,
//                             height: 4.h,
//                             width: 8.w,
//                           ),
//                           SizedBox(width: 5.w),
//                           CustomText(
//                             text: AppString.myConnections,
//                             textAlign: TextAlign.start,
//                             fontFamily: AppString.manropeFontFamily,
//                             fontSize: 12.sp,
//                             color: AppColors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           const Spacer(),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             size: 2.h,
//                             color: AppColors.white.withOpacity(0.3),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 1.5.h),
//                     _buildListTile(
//                       title: AppString.myGoal,
//                       icon: AppImages.myGol,
//                       ontap: () {},
//                     ),
//                     SizedBox(height: 1.5.h),
//                     _buildListTile(
//                       title: AppString.development,
//                       icon: AppImages.development,
//                       ontap: () {},
//                     ),
//                     SizedBox(height: 1.5.h),
//                     _buildListTile(
//                       title: AppString.performance,
//                       icon: AppImages.performance,
//                       ontap: () {},
//                     ),
//                     SizedBox(height: 1.5.h),
//                     _buildListTile(
//                       title: AppString.alignment,
//                       icon: AppImages.alignment,
//                       ontap: () {
//                         widget.scaffoldKey.currentState?.closeDrawer();
//                         Get.toNamed(RouteHelper.getTrialRoute());
//                       },
//                     ),
//                     SizedBox(height: 1.5.h),
//                     _buildListTile(
//                       title: AppString.projects,
//                       icon: AppImages.projects,
//                       ontap: () {
//                         widget.scaffoldKey.currentState?.closeDrawer();
//                         Get.toNamed(RouteHelper.getPreferencesRoute());
//                       },
//                     ),
//                     SizedBox(height: 1.5.h),
//                     _buildListTile(
//                       title: AppString.insightLibrary,
//                       icon: AppImages.insightLibrary,
//                       ontap: () {
//                         widget.scaffoldKey.currentState?.closeDrawer();
//                         Get.toNamed(RouteHelper.getOrganizationRoute());
//                       },
//                     ),
//                     SizedBox(height: 1.5.h),
//                     _buildListTile(
//                       title: AppString.logOut,
//                       icon: AppImages.projects,
//                       ontap: () {
//                         _logout();
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 3.h),
//                 _buildVersion(),
//                 SizedBox(height: 2.h),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _logout() {
//     var map = <String, dynamic>{};
//     var sharedPrefServiceController = Get.find<ProfileSharedPrefService>();
//     buildLoading(context);
//     Get.find<AuthController>()
//         .logout(map, sharedPrefServiceController)
//         .then((status) async {
//       if (status.isSuccess == true) {
//         showCustomSnackBar(status.message, isError: false);
//         Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
//       } else {
//         Navigator.pop(context);
//         showCustomSnackBar(status.message);
//       }
//     });
//   }

//   GestureDetector _buildListTile(
//       {required Function ontap, required String title, required String icon}) {
//     return GestureDetector(
//       onTap: () {
//         ontap();
//       },
//       child: Container(
//         padding: EdgeInsets.all(10.sp),
//         decoration: BoxDecoration(
//             borderRadius:
//                 BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
//             color: Colors.transparent),
//         child: Row(
//           children: [
//             Image.asset(
//               icon,
//               height: 3.h,
//               width: 8.w,
//             ),
//             SizedBox(width: 5.w),
//             CustomText(
//               text: title,
//               textAlign: TextAlign.start,
//               fontFamily: AppString.manropeFontFamily,
//               fontSize: 12.sp,
//               color: AppColors.white,
//               fontWeight: FontWeight.w500,
//             ),
//             const Spacer(),
//             Icon(
//               Icons.arrow_forward_ios,
//               size: 1.5.h,
//               color: AppColors.white.withOpacity(0.3),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Center _buildVersion() {
//     return Center(
//       child: CustomText(
//         color: AppColors.white,
//         text: AppConstants.appVersionLable,
//         textAlign: TextAlign.start,
//         fontFamily: AppString.manropeFontFamily,
//         fontSize: 11.sp,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }
// }
