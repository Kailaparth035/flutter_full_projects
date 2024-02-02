import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/screens/insight_stream/hashtag_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PostBodyWidget extends StatefulWidget {
  const PostBodyWidget(
      {super.key,
      required this.description,
      required this.isParent,
      this.onHashtagReload,
      required this.isFrom});

  final String description;
  final PostTypeEnum isFrom; // insight , hashtag , user
  final bool isParent;
  final Function? onHashtagReload;

  @override
  State<PostBodyWidget> createState() => _PostBodyWidgetState();
}

class _PostBodyWidgetState extends State<PostBodyWidget> {
  Widget _buildDescription(String description, {required bool isParent}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isParent ? 15.sp : 10.sp),
      child: Column(
        children: [
          _buildDescriptionText(description),
          description != "" ? SizedBox(height: 5.sp) : const SizedBox(),
        ],
      ),
    );
  }

  _buildDescriptionText(String text) {
    return RichText(
      text: TextSpan(
        children: _buildDescriptionTextTile(text)

        // ...text.split(" ").map(
        //   (e) {
        //     if (e.startsWith("#")) {
        //       return _buildDescriptionTextTile(e)
        //     } else {
        //       return TextSpan(
        //         text: " $e",
        //         style: TextStyle(
        //           fontSize: 11.sp,
        //           fontFamily: AppString.manropeFontFamily,
        //           fontWeight: FontWeight.w500,
        //           color: AppColors.labelColor14,
        //         ),
        //       );
        //     }
        //     // return _buildDescriptionTextTile(e);
        //   },
        // ),
        ,
      ),
    );
  }

  List<InlineSpan> _buildDescriptionTextTile(String text) {
    List<InlineSpan> widget = [];

    var textArray = text.split(" ");

    for (var textElement in textArray) {
      if (textElement.startsWith("#")) {
        var mainHashtag = RegExp(r'#\w+').stringMatch(textElement);
        String modifiedString =
            textElement.replaceAll(mainHashtag.toString(), "");

        widget.add(TextSpan(
          text: mainHashtag,
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: AppString.manropeFontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              onTapOfHas(mainHashtag);
            },
        ));

        widget.add(TextSpan(
          text: " $modifiedString",
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: AppString.manropeFontFamily,
            fontWeight: FontWeight.w500,
            color: AppColors.labelColor14,
          ),
        ));
      } else {
        widget.add(TextSpan(
          text: " $textElement",
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: AppString.manropeFontFamily,
            fontWeight: FontWeight.w500,
            color: AppColors.labelColor14,
          ),
        ));
      }
    }

    return widget;
  }

  onTapOfHas(mainHashtag) async {
    debugPrint("====> Go To =====>  $mainHashtag");
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HashTagPostStreamScreen(
          isFrom: PostTypeEnum.hashtag,
          hashTag: mainHashtag.toString().replaceAll("#", "").trim(),
        ),
      ),
    );

    if (widget.isFrom == PostTypeEnum.hashtag) {
      if (widget.onHashtagReload != null) {
        widget.onHashtagReload!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildDescription(widget.description, isParent: widget.isParent);
  }
}
