import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PostSelfPopUpWidget extends StatefulWidget {
  const PostSelfPopUpWidget({
    super.key,
    required this.onDeleting,
    required this.onEditing,
    required this.shareUrl,
  });
  final Function onEditing;
  final Function onDeleting;
  final String shareUrl;

  @override
  State<PostSelfPopUpWidget> createState() => _PostSelfPopUpWidgetState();
}

class _PostSelfPopUpWidgetState extends State<PostSelfPopUpWidget> {
  // late InfoPopupController infocontroller;
  final List<PopUpModel> _menuList = [
    PopUpModel(
      title: AppString.edit,
      subTitle: '',
      image: AppImages.editGreyIc,
      onTap: () {},
    ),
    PopUpModel(
        title: AppString.delete,
        subTitle: '',
        image: AppImages.deleteGreyIc,
        onTap: () {}),
    PopUpModel(
      title: "Share Via",
      subTitle: '',
      image: AppImages.shareBlackIc,
      onTap: () {},
    ),
  ];

  final tooltipController = AlignedTooltipController();
  @override
  Widget build(BuildContext context) {
    return AlignedTooltip(
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: AppColors.backgroundColor1,
      controller: tooltipController,
      shadow: const Shadow(color: Colors.transparent),
      isModal: true,
      content: _buildView(),
      child: GestureDetector(
          onTap: () {
            tooltipController.showTooltip();
          },
          child: Image.asset(AppImages.optionMenu, height: 3.h)),
    );
  }

  Widget _buildView() => Container(
        width: 100.sp,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor1,
          border: Border.all(
            color: AppColors.labelColor,
          ),
          borderRadius: BorderRadius.circular(5.sp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [..._menuList.map((e) => _buildListTile(e))],
        ),
      );

  Widget _buildListTile(PopUpModel data) {
    int index = _menuList.indexOf(data);
    bool isLast = index + 1 == _menuList.length;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          widget.onEditing();
        } else if (index == 1) {
          widget.onDeleting();
        } else {
          CommonController.sharePostToEveryWhere(widget.shareUrl);
        }
        tooltipController.hideTooltip();
      },
      child: Column(
        children: [
          5.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 5.sp),
            child: Row(
              children: [
                Image.asset(data.image, height: 13.sp),
                10.sbw,
                CustomText(
                  text: data.title,
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor14,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 11.sp,
                  maxLine: 2,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          5.sp.sbh,
          isLast
              ? 0.sbh
              : Column(
                  children: [
                    0.sp.sbh,
                    const Divider(
                      color: AppColors.labelColor,
                      height: 0,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
