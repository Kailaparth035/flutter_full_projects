// import 'package:alphabetical_scroll/alphabetical_scroll.dart';
// import 'package:aspirevue/controller/growth_community_controller.dart';
// import 'package:aspirevue/util/app_constants.dart';
// import 'package:aspirevue/util/colors.dart';
// import 'package:aspirevue/util/images.dart';
// import 'package:aspirevue/util/string.dart';
// import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
// import 'package:aspirevue/view/base/custom_text.dart';
// import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
// import 'package:aspirevue/view/base/text_box/custom_search_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';

// class LocalContactsListScreen extends StatefulWidget {
//   const LocalContactsListScreen({
//     super.key,
//   });

//   @override
//   State<LocalContactsListScreen> createState() =>
//       _LocalContactsListScreenState();
// }

// class Sticky {
//   final String note;
//   static List color = [
//     AppColors.backgroundColor3,
//     AppColors.backgroundColor5,
//     AppColors.labelColor4,
//     AppColors.labelColor38,
//     AppColors.labelColor40,
//     AppColors.labelColor45,
//     AppColors.labelColor33,
//   ];

//   Sticky({required this.note});

//   static Color getColorItem() => (color.toList()..shuffle()).first;
// }

// class _LocalContactsListScreenState extends State<LocalContactsListScreen> {
//   final FocusNode _searchFocus = FocusNode();
//   final TextEditingController _searchController = TextEditingController();
//   final _growthCommunityController = Get.find<GrowthCommunityController>();
//   @override
//   void initState() {
//     super.initState();
//     _growthCommunityController.loadContacts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(AppConstants.appBarHeight),
//         child: AppbarWithBackButton(
//           appbarTitle: AppString.importContact,
//           onbackPress: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: buildView(),
//     );
//   }

//   Container buildView() {
//     return Container(
//       padding: EdgeInsets.symmetric(
//           horizontal: AppConstants.screenHorizontalPadding),
//       child: Column(
//         children: [
//           GetBuilder<GrowthCommunityController>(
//               builder: (growthCommunityController) {
//             return CustomSearchTextField(
//               labelText: AppString.search,
//               focusNode: _searchFocus,
//               textEditingController: _searchController,
//               suffixIcon: AppImages.searchBlack,
//               fontFamily: AppString.manropeFontFamily,
//               onSecondTap: () {
//                 growthCommunityController.filterData(_searchController.text);
//               },
//               onChanged: (val) {},
//               fontSize: 10.sp,
//             );
//           }),
//           Expanded(
//             child: GetBuilder<GrowthCommunityController>(
//                 builder: (growthCommunityController) {
//               if (growthCommunityController.isLoadingContact) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         child: CustomLoadingWidget(),
//                       ),
//                       CustomText(
//                         text: AppString.importingContacts,
//                         textAlign: TextAlign.start,
//                         color: AppColors.labelColor8,
//                         fontFamily: AppString.manropeFontFamily,
//                         fontSize: 12.sp,
//                         maxLine: 3,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return AlphabetListScreen<Contact?>(
//                 alphabetBarItemHeight: 12.sp,
//                 isBorderedAlphabetBar: true,
//                 sideAlphabetBarPadding: EdgeInsets.all(0.sp),
//                 contactListPadding: EdgeInsets.only(right: 10.sp),
//                 alphabetBarMargin: EdgeInsets.all(0.sp),
//                 alphabetBarWidth: 15.sp,
//                 alphabetBarSelectedItemColor: Colors.transparent,
//                 selectedAlphabetTextStyle:
//                     TextStyle(fontSize: 10.sp, color: Colors.black),
//                 unSelectedAlphabetTextStyle:
//                     TextStyle(fontSize: 10.sp, color: Colors.grey),
//                 headerTextStyle:
//                     TextStyle(color: AppColors.primaryColor, fontSize: 15.sp),
//                 itemBuilder: (context, contact) {
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Sticky.getColorItem(),
//                       child: Text(
//                         contact!.displayName[0].toString(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     title: Text(contact.displayName),
//                   );
//                 },
//                 sources: growthCommunityController.contacts,
//                 sourceFilterItemList: growthCommunityController.contactsString,
//                 onTap: (item) {},
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
