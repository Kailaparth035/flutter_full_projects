import 'dart:async';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/data/model/response/global_search_model.dart';
import 'package:aspirevue/data/model/response/hashtag_list_model.dart';
import 'package:aspirevue/util/animation.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_app_bar.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_search_text_filed_for_top_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/hashtag_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/profile/user_profile_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/hashtag_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.isFromHashTagScreen});
  final bool isFromHashTagScreen;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _insightStreamController = Get.find<InsightStreamController>();

  bool _isLoading = false;
  List<SearchData> _searchList = [];
  bool _isInitial = true;
  @override
  void initState() {
    super.initState();
  }

  _searchItem() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      var searchList = await _insightStreamController
          .searchUserHashtagList(_searchController.text);
      if (mounted) {
        setState(() {
          _searchList = searchList;
        });
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isInitial = false;
          _isLoading = false;
        });
      }
    }
  }

  Timer? searchOnStoppedTyping;

  onChangeHandler(value) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel());
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => _searchItem()));
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: GestureDetector(
        onTap: () {
          CommonController.hideKeyboard(context);
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: _buildAppbar(context),
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                10.sp.sbh,
                _buildSearchTextbox(),
                _isLoading
                    ? _buildSearchLoading()
                    : !_isInitial && _searchList.isEmpty
                        ? Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 0.h),
                                  child: Center(
                                    child:
                                        CustomNoDataFoundWidget(height: 20.h),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _buildHashTagSearch(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildSearchTextbox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: CustomSearchTextFieldForTopWidget(
        labelText: "Global Search",
        editColor: AppColors.labelColor12,
        suffixIcon: AppImages.searchRoundedIc,
        fontFamily: AppString.manropeFontFamily,
        textEditingController: _searchController,
        fontSize: 11.sp,
        onChanged: (val) {
          onChangeHandler(val);
        },
      ),
    );
  }

  Expanded _buildHashTagSearch() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  7.sp.sbh,
                  ..._searchList.map((e) {
                    if (e.type == SearchType.hashtag) {
                      return GestureDetector(
                        onTap: () {
                          if (widget.isFromHashTagScreen) {
                            Navigator.pop(context, e.name);
                          } else {
                            Get.to(() => HashTagPostStreamScreen(
                                  isFrom: PostTypeEnum.hashtag,
                                  hashTag: e.name.toString(),
                                ));
                          }
                        },
                        child: HashTagWidget(
                          data: HashtagData(
                            id: e.id,
                            name: e.name,
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => UserProfileScreen(
                                userId: e.id.toString(),
                              ));
                        },
                        child: HashTagWidget(
                          data: HashtagData(
                            id: e.id,
                            name: e.name,
                            image: e.photo,
                          ),
                        ),
                      );
                    }
                  })
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildSearchLoading() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(40.sp),
        child: Lottie.asset(AppAnimation.searchAnimation),
      ),
    );
  }

  CustomAppBar _buildAppbar(BuildContext context) {
    return CustomAppBar(
      onPressed: () {
        Navigator.pop(context);
      },
      title: AppString.search,
      onBackPressed: () {
        Get.back();
      },
      showActionIcon: false,
      textColor: AppColors.labelColor8,
      iconButtonColor: AppColors.labelColor5,
      context: context,
    );
  }
}
