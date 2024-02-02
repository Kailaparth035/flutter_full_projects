import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget(
      {super.key,
      required this.value,
      required this.returnValue,
      required this.isEnable,
      this.isReset,
      this.min = 0.0,
      this.max = 10.0,
      this.interval = 1,
      this.sliderColor,
      this.isShowToolTilOnClick = true});
  final double value;
  final Function(double) returnValue;
  final bool isEnable;
  final Color? sliderColor;
  final bool? isReset;
  final double interval;
  final bool isShowToolTilOnClick;

  final double? min;
  final double? max;
  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double count = 0;
  @override
  void initState() {
    count = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SliderWidget oldWidget) {
    if (widget.isReset == true) {
      setState(() {
        count = widget.value;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 12.sp,
        inactiveTrackHeight: 12.sp,
        inactiveTrackColor: AppColors.labelColor61,
        tooltipBackgroundColor: widget.sliderColor ?? AppColors.secondaryColor,
        tooltipTextStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
        overlayRadius: 1,

        // thumbStrokeWidth: 20.sp,
        thumbColor: Colors.transparent,
        thumbRadius: 12.sp,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 11.5.sp),
              height: 13.sp,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(200.sp),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: SfSlider(
                  min: widget.min,
                  max: widget.max ?? 10.0,
                  trackShape: _SfTrackShape(widget.sliderColor),
                  interval: widget.interval,
                  inactiveColor: AppColors.labelColor19,
                  showTicks: false,
                  enableTooltip: widget.isShowToolTilOnClick,
                  stepSize: widget.interval,
                  thumbIcon: _buildThumIcon(),
                  shouldAlwaysShowTooltip: false,
                  value: count,
                  onChangeEnd: (newValue) {
                    if (widget.isEnable) {
                      widget.returnValue(widget.interval == 1
                          ? double.parse(newValue.toString()).toPrecision(2)
                          : double.parse(newValue.toString()).toPrecision(2));
                    }
                  },
                  onChanged: (dynamic newValue) {
                    if (widget.isEnable) {
                      setState(() {
                        count = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Transform _buildThumIcon() {
    return Transform.translate(
      offset: const Offset(0, 0),
      child: Container(
        height: 20.sp,
        width: 20.sp,
        padding: EdgeInsets.all(1.sp),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Container(
          height: 20.sp,
          width: 20.sp,
          padding: EdgeInsets.all(3.sp),
          decoration: BoxDecoration(
            gradient: widget.sliderColor == null
                ? CommonController.getLinearGradientSecondryAndPrimary()
                : LinearGradient(
                    colors: [widget.sliderColor!, widget.sliderColor!]),
            shape: BoxShape.circle,
          ),
          child: FittedBox(
            child: Text(
              widget.interval == 1 ? _getValue() : _getValue(),
              style: TextStyle(fontSize: 10.sp, color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }

  String _getValue() {
    var isPointValue = count % 1 == 0;
    if (widget.interval == 1) {
      return double.parse(count.toString()).toInt().toString();
    } else {
      return isPointValue
          ? double.parse(count.toString()).toInt().toString()
          : count.toPrecision(2).toString();
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SfSliderTheme(
  //     data: SfSliderThemeData(
  //       activeTrackHeight: 10.sp,
  //       inactiveTrackHeight: 10.sp,
  //       inactiveTrackColor: AppColors.labelColor61,
  //       tooltipBackgroundColor: widget.sliderColor ?? AppColors.secondaryColor,
  //       tooltipTextStyle: TextStyle(
  //         fontSize: 10.sp,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(vertical: 0.sp),
  //       child: FlutterSlider(
  //         tooltip: _buildToolTip(),
  //         trackBar: _buildLine(),
  //         handler: _buildTrackBall(),
  //         values: [count],
  //         max: 10,
  //         min: 0,
  //         step: FlutterSliderStep(step: widget.stoper),
  //         // touchSize: 0,
  //         // selectByTap: false,
  //         selectByTap: false,
  //         visibleTouchArea: true,
  //         disabled: widget.isEnable == false,
  //         onDragCompleted: (handlerIndex, lowerValue, upperValue) {
  //           if (widget.isEnable && count != lowerValue) {
  //             setState(() {
  //               count = lowerValue;
  //             });
  //             widget.returnValue(lowerValue);
  //           }
  //         },
  //         onDragging: (handlerIndex, lowerValue, upperValue) {},
  //       ),
  //     ),
  //   );
  // }

  // FlutterSliderHandler _buildTrackBall() {
  //   return FlutterSliderHandler(
  //     decoration: const BoxDecoration(),
  //     child: Stack(
  //       alignment: Alignment.topCenter,
  //       children: [
  //         Center(
  //           child: Container(
  //             height: 15.sp,
  //             decoration: BoxDecoration(
  //               border: Border.all(color: AppColors.white),
  //               gradient: LinearGradient(colors: [
  //                 widget.sliderColor ?? AppColors.secondaryColor,
  //                 widget.sliderColor ?? AppColors.primaryColor,
  //               ]),
  //               shape: BoxShape.circle,
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           child: RotatedBox(
  //             quarterTurns: 2,
  //             child: Transform.translate(
  //               offset: Offset(0, -5.sp),
  //               child: CustomPaint(
  //                 painter: TrianglePainter(
  //                   strokeColor: widget.sliderColor ?? AppColors.secondaryColor,
  //                   strokeWidth: 10,
  //                   paintingStyle: PaintingStyle.fill,
  //                 ),
  //                 child: SizedBox(
  //                   height: 5.sp,
  //                   width: 10.sp,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // FlutterSliderTrackBar _buildLine() {
  //   return FlutterSliderTrackBar(
  //     activeTrackBarHeight: 10.sp,
  //     inactiveTrackBarHeight: 10.sp,
  //     activeTrackBar: BoxDecoration(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(5.sp),
  //         bottomLeft: Radius.circular(5.sp),
  //       ),
  //       gradient: LinearGradient(colors: [
  //         widget.sliderColor ?? AppColors.secondaryColor,
  //         widget.sliderColor ?? AppColors.primaryColor
  //       ]),
  //       color: widget.sliderColor ?? AppColors.secondaryColor,
  //     ),
  //     inactiveTrackBar: BoxDecoration(
  //       borderRadius: BorderRadius.only(
  //         topRight: Radius.circular(5.sp),
  //         bottomRight: Radius.circular(5.sp),
  //       ),
  //     ),
  //   );
  // }

  // FlutterSliderTooltip _buildToolTip() {
  //   return FlutterSliderTooltip(
  //     format: (val) {
  //       if (widget.stoper == 1) {
  //         return (double.parse(val).toInt()).toString();
  //       } else {
  //         return val;
  //       }
  //     },
  //     alwaysShowTooltip: true,
  //     textStyle: TextStyle(
  //       fontSize: 8.sp,
  //       color: Colors.white,
  //       fontWeight: FontWeight.w600,
  //     ),
  //     boxStyle: FlutterSliderTooltipBox(
  //       transform: Matrix4.translationValues(0, -1.sp, 0),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10.sp),
  //         color: widget.sliderColor ?? AppColors.secondaryColor,
  //       ),
  //     ),
  //   );
  // }
}

// class _SfToolTipShape extends SfTooltipShape {
//   _SfToolTipShape(this.color);

//   final Color? color;
//   @override
//   void paint(PaintingContext context, Offset thumbCenter, Offset offset,
//       TextPainter textPainter,
//       {required RenderBox parentBox,
//       required SfSliderThemeData sliderThemeData,
//       required Paint paint,
//       required Animation<double> animation,
//       required Rect trackRect}) {

//     super.paint(context, offset, thumbCenter, textPainter,
//         parentBox: parentBox,
//         sliderThemeData: sliderThemeData,
//         animation: animation,
//         trackRect: trackRect,
//         paint: paint);
//   }
// }

class _SfTrackShape extends SfTrackShape {
  _SfTrackShape(this.color);

  final Color? color;
  @override
  void paint(PaintingContext context, Offset offset, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Animation<double> enableAnimation,
      required Paint? inactivePaint,
      required Paint? activePaint,
      required TextDirection textDirection}) {
    // Paint paint = Paint()
    //   ..color = AppColors.labelColor31
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 0.5;

    Rect rect = Rect.fromCircle(
      center: const Offset(165.0, 55.0),
      radius: 90.0,
    );
    final Gradient gradient = LinearGradient(
      colors: <Color>[
        color ?? AppColors.primaryColor,
        color ?? AppColors.secondaryColor,
      ],
    );

    final Paint paint1 = Paint()..shader = gradient.createShader(rect);

    super.paint(context, offset, thumbCenter, startThumbCenter, endThumbCenter,
        parentBox: parentBox,
        themeData: themeData,
        enableAnimation: enableAnimation,
        inactivePaint: inactivePaint,
        activePaint: paint1,
        textDirection: textDirection);
  }
}
