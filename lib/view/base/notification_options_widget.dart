import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/notification_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NotificationOptionWidget extends StatefulWidget {
  const NotificationOptionWidget({super.key, required this.data});
  final NotificationListData data;
  @override
  State<NotificationOptionWidget> createState() =>
      _NotificationOptionWidgetState();
}

class _NotificationOptionWidgetState extends State<NotificationOptionWidget> {
  // late InfoPopupController infocontroller;
  List<PopUpModel> _menuList = [];
  final _mainController = Get.find<MainController>();

  final tooltipController = AlignedTooltipController();

  @override
  void initState() {
    _menuList = [
      PopUpModel(
          title: AppString.delete,
          subTitle: '',
          image: AppImages.deleteGreyIc,
          onTap: () {
            _archive();
          }),
    ];

    super.initState();
  }

  _archive() async {
    var res = await _mainController.archiveInbox(
        widget.data.id.toString(), widget.data.notType.toString());

    if (res != null && res == true) {
      _mainController
          .removeNotificationItem(int.parse(widget.data.id.toString()));
    }
  }

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
        child: Padding(
          padding: EdgeInsets.only(top: 3.sp),
          child: SvgPicture.asset(
            SvgImage.moreIc,
          ),
        ),
      ),
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
        tooltipController.hideTooltip();
        data.onTap();
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
