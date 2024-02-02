import 'package:flutter/material.dart';

class CustomExpandableWidget extends StatefulWidget {
  final Widget mainWidget;
  final Widget childWidget;
  final Function(bool)? onExpand;
  final bool isOpened;
  const CustomExpandableWidget(
      {super.key,
      required this.mainWidget,
      required this.childWidget,
      required this.isOpened,
      this.onExpand});

  @override
  State<CustomExpandableWidget> createState() => _CustomExpandableWidgetstate();
}

class _CustomExpandableWidgetstate extends State<CustomExpandableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;

  @override
  void initState() {
    super.initState();

    isShow = widget.isOpened;

    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  @override
  void didUpdateWidget(covariant CustomExpandableWidget oldWidget) {
    if (isShow != widget.isOpened) {
      setState(() {
        isShow = widget.isOpened;
        _runExpandCheck();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
            onTap: () {
              isShow = !isShow;
              _runExpandCheck();
              setState(() {});
              if (widget.onExpand != null) {
                widget.onExpand!(isShow);
              }
            },
            child: widget.mainWidget),
        SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: animation,
            child: widget.childWidget),
      ],
    );
  }
}
