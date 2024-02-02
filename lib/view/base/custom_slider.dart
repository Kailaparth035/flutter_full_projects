import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/alert_dialogs/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider(
      {super.key,
      required this.percent,
      required this.isEditable,
      this.onChange});
  final double percent;
  final bool isEditable;
  final Function(double)? onChange;
  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  GlobalKey<State<StatefulWidget>> mywidgetkey = GlobalKey();
  // double _percent = 0;

  @override
  void initState() {
    super.initState();

    // _percent = widget.percent;
  }

  @override
  Widget build(BuildContext context) {
    return SliderWidget(
        interval: 1,
        max: 100,
        isEnable: widget.isEditable,
        value: widget.percent,
        isReset: false,
        isShowToolTilOnClick: false,
        returnValue: (val) {
          if (widget.onChange != null) {
            widget.onChange!(val);
          }
        });
  }

  // Row _buildView(BuildContext context) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Expanded(
  //         child: GestureDetector(
  //           onTapDown: (details) {
  //             if (widget.isEditable) {
  //               var position = details.globalPosition;

  //               RenderBox renderbox =
  //                   mywidgetkey.currentContext!.findRenderObject() as RenderBox;

  //               if (position.dx < MediaQuery.of(context).size.width / 2) {
  //                 if (position.dx < renderbox.size.width) {
  //                   var per = position.dx / renderbox.size.width;

  //                   if (per > 0 && per < 100) {
  //                     setState(() {
  //                       _percent = per;
  //                     });
  //                   }
  //                 }

  //                 // tap left side
  //               } else {
  //                 if (position.dx < renderbox.size.width) {
  //                   var per = (position.dx - 20.sp) / renderbox.size.width;

  //                   if (per > 0 && per < 100) {
  //                     setState(() {
  //                       _percent = per;
  //                     });
  //                   }
  //                 }

  //                 // tap rigth size
  //               }

  //               if (widget.onChange != null) {
  //                 widget.onChange!(_percent);
  //               }
  //             }
  //           },
  //           onPanUpdate: (details) {
  //             if (widget.isEditable) {
  //               var position = details.globalPosition;

  //               RenderBox renderbox =
  //                   mywidgetkey.currentContext!.findRenderObject() as RenderBox;

  //               // Swiping in right direction.
  //               if (details.delta.dx > 0) {
  //                 if (position.dx < renderbox.size.width) {
  //                   var per = position.dx / renderbox.size.width;

  //                   if (per > 0 && per < 100) {
  //                     setState(() {
  //                       _percent = per;
  //                     });
  //                   }
  //                 }
  //               }

  //               // Swiping in left direction.
  //               if (details.delta.dx < 0) {
  //                 if (position.dx < renderbox.size.width) {
  //                   var per = position.dx / renderbox.size.width;

  //                   if (per > 0 && per < 100) {
  //                     setState(() {
  //                       _percent = per;
  //                     });
  //                   }
  //                 }
  //               }
  //               if (widget.onChange != null) {
  //                 widget.onChange!(_percent);
  //               }
  //             }
  //           },
  //           child: Stack(
  //             children: [
  //               SizedBox(
  //                 height: 16.sp,
  //                 child: Center(
  //                   child: Container(
  //                     key: mywidgetkey,
  //                     height: 12.sp,
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(20.sp),
  //                         border: Border.all(
  //                           width: 0.5.sp,
  //                           color: AppColors.labelColor31,
  //                         ),
  //                         color: AppColors.labelColor19),
  //                     child: Center(
  //                       child: !(_percent * 100.round() <= 10)
  //                           ? 0.sbh
  //                           : Text(
  //                               "${(_percent * 100).round()}%",
  //                               style: TextStyle(
  //                                 color: AppColors.white,
  //                                 fontSize: 10.sp,
  //                               ),
  //                             ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SecondWidget(
  //                 isEditable: widget.isEditable,
  //                 mywidgetkey: mywidgetkey,
  //                 percent: _percent,
  //               ),
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}

class SecondWidget extends StatefulWidget {
  const SecondWidget({
    super.key,
    required this.mywidgetkey,
    required this.percent,
    required this.isEditable,
  });
  final GlobalKey<State<StatefulWidget>> mywidgetkey;
  final double percent;
  final bool isEditable;
  @override
  State<SecondWidget> createState() => _SecondWidgetState();
}

class _SecondWidgetState extends State<SecondWidget> {
  double width = 0;
  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  startAnimation() {
    Future.delayed(const Duration(milliseconds: 10), () {
      RenderBox renderbox =
          widget.mywidgetkey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        width = renderbox.size.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.sp,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: _getWidth(),
            height: 12.sp,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                gradient:
                    CommonController.getLinearGradientSecondryAndPrimary(),
                color: AppColors.labelColor19),
            child: Stack(
              children: [
                widget.percent >= 0.11
                    ? Center(
                        child: Text(
                          "${(widget.percent * 100).round()}%",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      )
                    : 0.sbh,
                !widget.isEditable
                    ? 0.sbh
                    : Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(1.sp),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(1.sp),
                            decoration: BoxDecoration(
                              gradient: CommonController
                                  .getLinearGradientSecondryAndPrimary(),
                              shape: BoxShape.circle,
                            ),
                            height: 10.sp,
                            width: 10.sp,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getWidth() {
    if (widget.percent <= 0.02) {
      return 12.sp;
    } else if (widget.percent > 0.9) {
      return width * widget.percent;
    } else {
      return width * widget.percent;
    }
  }
}
