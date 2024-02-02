import 'package:aspirevue/view/screens/insight_stream/widget/story_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 8.h,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return const StoryWidget();
          },
        ),
      ),
    );
  }
}
