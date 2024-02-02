// import 'package:aspirevue/controller/common_controller.dart';
// import 'package:aspirevue/controller/my_connection_controller.dart';
// import 'package:aspirevue/data/model/response/user_about_model.dart';
// import 'package:aspirevue/util/app_constants.dart';
// import 'package:aspirevue/util/colors.dart';
// import 'package:aspirevue/util/sized_box_utils.dart';
// import 'package:aspirevue/util/string.dart';
// import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
// import 'package:aspirevue/view/base/custom_bottom_navbar.dart';
// import 'package:aspirevue/view/base/custom_dropdown_for_about.dart';
// import 'package:aspirevue/view/base/custom_future_builder.dart';
// import 'package:aspirevue/view/base/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';

// class UserAboutScreen extends StatefulWidget {
//   const UserAboutScreen({Key? key, required this.userId}) : super(key: key);
//   final String userId;
//   @override
//   State<UserAboutScreen> createState() => _UserAboutScreenState();
// }

// class _UserAboutScreenState extends State<UserAboutScreen> {
//   late Future<UserAboutData?> _futureCall;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   _loadData() {
//     var map = <String, dynamic>{"user_id": widget.userId};
//     setState(() {
//       _futureCall = Get.find<MyConnectionController>().getUserAboutData(map);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CommonController.getAnnanotaion(
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(AppConstants.appBarHeight),
//           child: AppbarWithBackButton(
//             appbarTitle: AppString.about,
//             onbackPress: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         bottomNavigationBar: const BottomNavBar(
//           isFromMain: false,
//         ),
//         backgroundColor: AppColors.backgroundColor1,
//         body: _buildMainView(),
//       ),
//     );
//   }

//   FutureBuildWidget _buildMainView() {
//     return FutureBuildWidget(
//       onRetry: () {
//         _loadData();
//       },
//       future: _futureCall,
//       child: (UserAboutData? data) {
//         return _buildView(data);
//       },
//     );
//   }

//   int _selected = 1000000; //at
//   SingleChildScrollView _buildView(UserAboutData? data) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Padding(
//         padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             data!.personalInfo != null
//                 ? _buildPerdonalInfo(data.personalInfo)
//                 : 0.sbh,
//             data.personalInfo != null ? 20.sp.sbh : 0.sbh,
//             data.myFavoriteQuote != null
//                 ? _buildMyFavoriteQuote(data.myFavoriteQuote)
//                 : 0.sbh,
//             data.myFavoriteQuote != null ? 20.sp.sbh : 0.sbh,
//             data.mySignature != null
//                 ? _buildMysignature(data.mySignature)
//                 : 0.sbh,
//             data.mySignature != null ? 20.sp.sbh : 0.sbh,
//             data.roleResponsibilities != null
//                 ? _buildPositionAndResponsibility(data)
//                 : 0.sbh,
//             20.sp.sbh,
//           ],
//         ),
//       ),
//     );
//   }

//   Column _buildMysignature(MySignature? signature) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildBGwithTitle(AppString.mySignature),
//         Padding(
//           padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               5.sp.sbh,
//               _buildTitleOnly(AppString.aspirationalSignature,
//                   signature!.mySignature.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(AppString.purposeStatement,
//                   signature.purposeStatement.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(AppString.whatisImportant,
//                   signature.importantToMe.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(
//                   AppString.teamSignature, signature.teamSignature.toString()),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Column _buildPositionAndResponsibility(UserAboutData? data) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildBGwithTitle(AppString.positionAndRoles),
//         Padding(
//           padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               5.sp.sbh,
//               _buildTitleOnly(
//                   AppString.positionTitle, data!.position!.title.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(AppString.positionDescription, ""),
//               3.sp.sbh,
//               _buildValue(
//                 data.position!.description.toString(),
//               ),
//               5.sp.sbh,
//             ],
//           ),
//         ),
//         20.sp.sbh,
//         _buildRoleList(data.roleResponsibilities!)
//       ],
//     );
//   }

//   ListView _buildRoleList(List<RoleResponsibility> roleResponsibilities) {
//     return ListView.builder(
//       key: Key('builder ${_selected.toString()}'),
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: roleResponsibilities.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.only(bottom: 8.sp),
//           child: CustomDropForAbout(
//             index: index,
//             selected: _selected,
//             onTap: (selectedValue) {
//               setState(() {
//                 _selected = selectedValue;
//               });
//             },
//             headingText: roleResponsibilities[index].title.toString(),
//             child: InkWell(
//                 splashFactory: NoSplash.splashFactory,
//                 highlightColor: Colors.transparent,
//                 onTap: () {},
//                 child: _buildListTileChild(roleResponsibilities[index])),
//           ),
//         );
//       },
//     );
//   }

//   Container _buildListTileChild(e) {
//     return Container(
//       width: double.infinity,
//       color: AppColors.labelColor22,
//       padding: EdgeInsets.all(10.sp),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomText(
//             text: e.description.toString(),
//             textAlign: TextAlign.start,
//             color: AppColors.labelColor41,
//             fontFamily: AppString.manropeFontFamily,
//             fontSize: 11.sp,
//             maxLine: 100,
//             fontWeight: FontWeight.w400,
//           ),
//           10.sp.sbh,
//           e.review!.isNotEmpty
//               ? Container(
//                   color: AppColors.white,
//                   width: double.infinity,
//                   padding: EdgeInsets.all(3.sp),
//                   child: Center(
//                     child: CustomText(
//                       text: "Performance Expectations",
//                       textAlign: TextAlign.start,
//                       color: AppColors.labelColor8,
//                       fontFamily: AppString.manropeFontFamily,
//                       fontSize: 13.sp,
//                       maxLine: 100,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 )
//               : 0.sbh,
//           ...e.review!.map(
//             (r) => Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 5.sp.sbh,
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: CustomText(
//                         text: r.reviewTitle.toString(),
//                         textAlign: TextAlign.start,
//                         color: AppColors.labelColor41,
//                         fontFamily: AppString.manropeFontFamily,
//                         fontSize: 11.sp,
//                         maxLine: 100,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     10.sp.sbw,
//                     Expanded(
//                       child: CustomText(
//                         text: r.reviewDesc.toString(),
//                         textAlign: TextAlign.start,
//                         color: AppColors.labelColor41,
//                         fontFamily: AppString.manropeFontFamily,
//                         fontSize: 11.sp,
//                         maxLine: 100,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//                 5.sp.sbh,
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Column _buildMyFavoriteQuote(MyFavoriteQuote? myfavQuote) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildBGwithTitle(AppString.myFavoriteQuote),
//         Padding(
//           padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               5.sp.sbh,
//               _buildValue(myfavQuote!.dsc.toString()),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Column _buildPerdonalInfo(PersonalInfo? info) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildBGwithTitle(AppString.personalInfo2),
//         5.sp.sbh,
//         Padding(
//           padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildTitleOnly(AppString.aboutMe, ""),
//               3.sp.sbh,
//               _buildValue(info!.aboutMe.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(AppString.emailTitle, info.email.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(AppString.occupation, info.occupation.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(AppString.birthday, info.birthday.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(AppString.birthplace, info.birthplace.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(AppString.joined, info.joined.toString()),
//               5.sp.sbh,
//               _buildTitleOnly("Web: ", info.webUrl.toString()),
//               5.sp.sbh,
//               _buildTitleOnly(
//                   "From (Location): ", info.fromLocation.toString()),
//               5.sp.sbh,
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTitleOnly(String title, String subTiele) {
//     return Text.rich(
//       TextSpan(
//         children: [
//           TextSpan(
//             text: title,
//             style: TextStyle(
//               fontSize: 10.sp,
//               fontFamily: AppString.manropeFontFamily,
//               fontWeight: FontWeight.w700,
//               color: AppColors.black,
//             ),
//           ),
//           TextSpan(
//             text: subTiele,
//             style: TextStyle(
//               fontSize: 10.sp,
//               fontFamily: AppString.manropeFontFamily,
//               fontWeight: FontWeight.w400,
//               color: AppColors.black,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildValue(String title) {
//     return CustomText(
//       text: title,
//       textAlign: TextAlign.start,
//       color: AppColors.labelColor20,
//       fontFamily: AppString.manropeFontFamily,
//       fontSize: 10.sp,
//       maxLine: 500,
//       fontWeight: FontWeight.w400,
//     );
//   }

//   Container _buildBGwithTitle(String title) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
//       decoration: BoxDecoration(
//           color: AppColors.labelColor19,
//           borderRadius: BorderRadius.circular(3.sp)),
//       child: CustomText(
//         text: title,
//         textAlign: TextAlign.start,
//         color: AppColors.labelColor8,
//         fontFamily: AppString.manropeFontFamily,
//         fontSize: 12.sp,
//         fontWeight: FontWeight.w700,
//       ),
//     );
//   }
// }
