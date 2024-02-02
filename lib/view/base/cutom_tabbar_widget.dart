import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_tab_bar_style.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTabBarWidget extends StatefulWidget {
  const CustomTabBarWidget(
      {super.key,
      required this.child,
      required this.title1,
      required this.title2,
      this.length,
      required this.selectedIndex,
      this.bgColor});
  final Widget child;
  final String title1;
  final String title2;
  final int selectedIndex;
  final int? length;
  final Color? bgColor;
  @override
  State<CustomTabBarWidget> createState() => _CustomTabBarWidgetState();
}

class _CustomTabBarWidgetState extends State<CustomTabBarWidget> {
  int index = 0;
  final bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() {
    index = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CustomLoadingWidget(),
          )
        : DefaultTabController(
            length: widget.length ?? 2,
            initialIndex: index,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DecoratedTabBar(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.labelColor,
                        width: 1.sp,
                      ),
                    ),
                  ),
                  tabBar: TabBar(
                    isScrollable: false,
                    indicatorPadding: EdgeInsets.only(top: 0.5.sp),
                    indicatorWeight: 1.sp,
                    labelPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    indicator: ShapeDecoration(
                      shape: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2.0.sp,
                              style: BorderStyle.solid)),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor
                        ],
                      ),
                    ),
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: widget.length == 1
                        ? [
                            _buildSecondTab(),
                          ]
                        : [
                            _buildFirstTab(),
                            _buildSecondTab(),
                          ],
                  ),
                ),
                widget.child
              ],
            ),
          );
  }

  StatefulBuilder _buildSecondTab() {
    return StatefulBuilder(builder: (context, setState) {
      DefaultTabController.of(context).addListener(() {
        setState(() {
          index = DefaultTabController.of(context).index;
        });
      });
      return Container(
        height: 35.sp,
        alignment: Alignment.center,
        color: widget.bgColor ?? AppColors.backgroundColor1,
        child: CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: index == 1 ? AppColors.black : AppColors.labelColor52,
          text: widget.title2,
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
      );
    });
  }

  StatefulBuilder _buildFirstTab() {
    return StatefulBuilder(builder: (context, setState) {
      DefaultTabController.of(context).addListener(() {
        setState(() {
          index = DefaultTabController.of(context).index;
        });
      });
      return Container(
        height: 35.sp,
        alignment: Alignment.center,
        color: widget.bgColor ?? AppColors.backgroundColor1,
        child: CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: index == 0 ? AppColors.black : AppColors.labelColor52,
          text: widget.title1,
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
      );
    });
  }
}
