import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/organization_chart_model.dart';
import 'package:aspirevue/data/model/response/organization_user_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_message.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/organization_chart_shimmer_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/profile/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../util/string.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class OrganizationChartScreen extends StatefulWidget {
  const OrganizationChartScreen({super.key});

  @override
  State<OrganizationChartScreen> createState() =>
      _OrganizationChartScreenState();
}

class _OrganizationChartScreenState extends State<OrganizationChartScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();
  final TextEditingController _typeAheadController = TextEditingController();
  late TreeController<OrganizarionChartData> treeController;
  bool _chartLoading = false;
  bool _userlistLoading = false;
  List<OrganizarionChartData> charList = [];
  @override
  void initState() {
    super.initState();
    loadData("");
  }

  loadData(String userId) async {
    setState(() {
      _chartLoading = true;
    });
    var map = <String, dynamic>{};

    if (userId == "") {
      var userId = Get.find<ProfileSharedPrefService>().profileData;
      map['user_id'] = userId.value.id.toString();
    } else {
      map['user_id'] = userId;
    }

    var charList1 =
        await Get.find<MyConnectionController>().getGrowthChart(map);
    if (mounted) {
      setState(() {
        charList = charList1;
      });
    }

    try {
      treeController.dispose();
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }

    treeController = TreeController<OrganizarionChartData>(
      roots: charList,
      childrenProvider: (OrganizarionChartData node) => node.child!,
    )..expandAll();
    if (mounted) {
      setState(() {
        _chartLoading = false;
      });
    }
  }

  @override
  void dispose() {
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: PopScope(
        canPop: true,
        // onWillPop: () {
        //   return Future.value(true);
        // },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              appbarTitle: AppString.organizationChart,
              onbackPress: () {
                Navigator.pop(context);
              },
            ),
          ),
          // bottomNavigationBar: const BottomNavBar(
          //   isFromMain: false,
          // ),
          backgroundColor: AppColors.backgroundColor1,
          body: Container(
            padding: EdgeInsets.only(
                top: AppConstants.screenHorizontalPadding,
                left: AppConstants.screenHorizontalPadding,
                right: AppConstants.screenHorizontalPadding),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBox(),
                  SizedBox(
                    height: 10.sp,
                  ),
                  _chartLoading
                      ? const OrganizationChartShimmerWidget()
                      : charList.isEmpty
                          ? Container(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 7 -
                                      10.sp),
                              child: const CustomNoDataFoundWidget(),
                            )
                          : _buildChart(),
                  SizedBox(
                    height: 30.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return TreeView<OrganizarionChartData>(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      treeController: treeController,
      nodeBuilder:
          (BuildContext context, TreeEntry<OrganizarionChartData> entry) {
        return MyTreeTile(
          key: ValueKey(entry.node),
          entry: entry,
          onTap: () => treeController.toggleExpansion(entry.node),
        );
      },
    );
  }

  Widget _buildSearchBox() {
    return StatefulBuilder(builder: (context, setState) {
      return Form(
        key: _formKey,
        child: TypeAheadField(
          controller: _typeAheadController,
          builder: (context, controller, focusNode) => TextFormField(
            autofocus: false,
            decoration: InputDecoration(
              hintText: AppString.search,
              hintStyle: TextStyle(
                color: AppColors.hintColor,
                fontFamily: AppString.manropeFontFamily,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
              contentPadding: context.isTablet
                  ? EdgeInsets.all(1.5.h)
                  : EdgeInsets.symmetric(horizontal: 3.h),
              filled: true,
              counterText: "",
              fillColor: AppColors.editColor,
              suffixIcon: Padding(
                padding: EdgeInsets.all(12.sp),
                child: _userlistLoading
                    ? SizedBox(
                        child: Transform.scale(
                          scale: 0.7.sp,
                          child: const CupertinoActivityIndicator(
                            color: AppColors.black,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {},
                        child: Image.asset(
                          AppImages.searchBlack,
                          width: 2.h,
                          height: 2.h,
                        ),
                      ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.radiusContainer)),
                borderSide: const BorderSide(color: AppColors.editBoarderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.radiusContainer)),
                borderSide: const BorderSide(color: AppColors.editBoarderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.radiusContainer)),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
            ),
            controller: controller,
            focusNode: focusNode,
          ),
          decorationBuilder: (context, child) => Material(
            type: MaterialType.card,
            elevation: 4,
            borderRadius: BorderRadius.circular(2.sp),
            child: child,
          ),
          itemBuilder: (context, product) => ListTile(
            title: Text(product.name.toString()),
          ),
          hideOnSelect: true,
          hideOnUnfocus: true,
          hideWithKeyboard: true,
          retainOnLoading: true,
          onSelected: _onSuggestionSelected,
          suggestionsCallback: _suggestionsCallback,
          itemSeparatorBuilder: _itemSeparatorBuilder,
          loadingBuilder: (context) {
            return const Center(child: CustomLoadingWidget());
          },
          emptyBuilder: (conta) {
            return const CustomNoDataFoundWidget(
              topPadding: 0,
            );
          },
        ),
      );
    });
  }

  Widget _itemSeparatorBuilder(BuildContext context, int index) =>
      const Divider(
        height: 1,
        color: AppColors.labelColor,
      );

  Future<List<OrganizationUser>> _suggestionsCallback(String pattern) async {
    try {
      setState(() {
        _userlistLoading = true;
      });
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }

    List<OrganizationUser>? data = await _response(pattern);
    try {
      setState(() {
        _userlistLoading = false;
      });
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }
    if (data != null) {
      return data;
    } else {
      return [];
    }
  }

  _onSuggestionSelected(suggestion) {
    try {
      var user = suggestion as OrganizationUser;
      loadData(user.id.toString());
      _typeAheadController.text = user.name.toString();
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    }
  }

  Future<List<OrganizationUser>?> _response(pattern) async {
    try {
      var map = <String, dynamic>{};
      map['name'] = pattern;

      var data =
          await Get.find<MyConnectionController>().getGrowthUserList(map);

      return data;
    } catch (e) {
      return null;
    }
  }
}

class MyTreeTile extends StatelessWidget {
  const MyTreeTile({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final TreeEntry<OrganizarionChartData> entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TreeIndentation(
        entry: entry,
        guide: const IndentGuide.connectingLines(indent: 20),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: entry.node.color!),
              color: entry.node.color!.withOpacity(0.2),
              borderRadius: BorderRadius.all(
                Radius.circular(Dimensions.radiusSmall),
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.circleGreen),
                        ),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.circleGreen,
                              radius: 20.sp,
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                backgroundImage:
                                    NetworkImage(entry.node.photo.toString()),
                                radius: 19.sp,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: -0,
                              child: entry.node.color == AppColors.greenColor
                                  ? Container(
                                      height: 13.sp,
                                      width: 13.sp,
                                      padding: EdgeInsets.all(2.sp),
                                      decoration: const BoxDecoration(
                                        color: AppColors.labelColor42,
                                        shape: BoxShape.circle,
                                      ),
                                      child: FittedBox(
                                        child: Center(
                                          child: Text(
                                            entry.node.directReportCount
                                                .toString(),
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 8.sp),
                                          ),
                                        ),
                                      ),
                                    )
                                  : 0.sbh,
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 3.sp,
                            ),
                            CustomText(
                              text: entry.node.name.toString(),
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor8,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomText(
                              text: entry.node.positionName.toString(),
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor15,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 10.sp,
                              maxLine: 2,
                              fontWeight: FontWeight.normal,
                            ),
                            SizedBox(
                              height: 3.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            var url = "tel://${entry.node.phone.toString()}";
                            if (!await launchUrl(Uri.parse(url))) {
                              showCustomSnackBar(
                                  "${AppString.unableToOpen} $url");
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.white,
                            backgroundImage:
                                const AssetImage(AppImages.callIcon),
                            radius: 10.sp,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(
                              () => UserProfileScreen(
                                  userId: entry.node.id.toString()),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.white,
                            backgroundImage:
                                const AssetImage(AppImages.accountIcon),
                            radius: 10.sp,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MessageAlertDialog(
                                  userId: entry.node.id.toString(),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.white,
                            backgroundImage:
                                const AssetImage(AppImages.emailIcon),
                            radius: 10.sp,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
