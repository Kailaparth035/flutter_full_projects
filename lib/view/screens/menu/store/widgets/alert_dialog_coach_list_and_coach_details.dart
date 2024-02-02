import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/coach_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AlertDialogCoachListAndCoachDetails extends StatefulWidget {
  const AlertDialogCoachListAndCoachDetails({super.key});

  @override
  State<AlertDialogCoachListAndCoachDetails> createState() =>
      _AlertDialogCoachListAndCoachDetailsState();
}

class _AlertDialogCoachListAndCoachDetailsState
    extends State<AlertDialogCoachListAndCoachDetails> {
  var expandedlist = [];
  final _storeController = Get.find<StoreController>();

  @override
  void initState() {
    expandedlist = _storeController.storeData!.coachUsers!
        .map((e) =>
            e.coachId.toString() ==
            _storeController.storeData!.coachId.toString())
        .toList();

    super.initState();
  }

  _resetList(String coachId) {
    var data = _storeController.storeData!.coachUsers!
        .map((e) => e.coachId.toString() == coachId)
        .toList();

    setState(() {
      expandedlist = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonController.hideKeyboard(context);
      },
      child: PopScope(
        canPop: true,
        // onWillPop: () {
        //   return Future.value(true);
        // },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.sp))),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 5.sp),
          content: GetBuilder<StoreController>(builder: (storeController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.sp),
                color: Colors.white,
              ),
              width: context.getWidth,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(),
                  ...storeController.storeData!.coachUsers!
                      .map((data) => Column(
                            children: [
                              CoachBoxWidget(
                                  data: data,
                                  isSelected: expandedlist[storeController
                                          .storeData!.coachUsers!
                                          .indexOf(data)] ==
                                      true,
                                  onExpand: (id) {
                                    _resetList(id);
                                  }),
                              8.sp.sbh,
                            ],
                          )),
                  // 8.sp.sbh
                ],
              )),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: " ",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.labelColor15.withOpacity(0.5)),
              child: Icon(
                Icons.close,
                weight: 3,
                size: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
