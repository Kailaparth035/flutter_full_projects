import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReadMoreWidget extends StatefulWidget {
  const ReadMoreWidget({super.key, required this.text, required this.onTap});
  final String text;
  final Function onTap;
  @override
  State<ReadMoreWidget> createState() => _ReadMoreWidgetState();
}

class _ReadMoreWidgetState extends State<ReadMoreWidget> {
  bool _isShowViewMore = false;
  bool _isViewedMore = false;
  String _textToDisplay = "";

  @override
  void initState() {
    _manageText();
    super.initState();
  }

  _manageText() {
    if (widget.text.length > 200) {
      setState(() {
        _isShowViewMore = true;
        _isViewedMore = true;
        _textToDisplay = widget.text.substring(0, 200);
      });
    } else {
      setState(() {
        _isShowViewMore = false;
        _isViewedMore = false;
        _textToDisplay = widget.text;
      });
    }
  }

  // _manageView() {
  //   if (_isViewedMore == true) {
  //     setState(() {
  //       _textToDisplay = widget.text;
  //       _isViewedMore = !_isViewedMore;
  //     });
  //   } else {
  //     setState(() {
  //       _textToDisplay = widget.text.substring(0, 200);
  //       _isViewedMore = !_isViewedMore;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: _textToDisplay,
            style: TextStyle(
              color: AppColors.labelColor15,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          // WidgetSpan(
          //     child: Html(
          //   data: _textToDisplay,
          //   style: {
          //     "*": Style(
          //       color: AppColors.labelColor15,
          //       fontFamily: AppString.manropeFontFamily,
          //       fontSize: FontSize(8.5.sp),
          //     ),
          //   },
          // )),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // _manageView();

                widget.onTap();
              },
            text: _isShowViewMore
                ? _isViewedMore
                    ? ".. View more"
                    : "  View less"
                : "",
            style: TextStyle(
              color: AppColors.labelColor15,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
