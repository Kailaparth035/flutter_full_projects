import 'package:flutter/material.dart';

class LottiePage extends StatefulWidget {
  const LottiePage({super.key});

  @override
  State<LottiePage> createState() => _LottiePageState();
}

class _LottiePageState extends State<LottiePage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animation"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),

            // AnimatedIcon(
            //   icon: AnimatedIconData,

            // ),
            // Container(
            //   child: Lottie.asset(
            //     'assets/animation/search_animation.json',
            //     repeat: false,
            //     reverse: true,
            //     // animate: false,
            //     filterQuality: FilterQuality.high,
            //     onLoaded: (composition) {
            //       // Configure the AnimationController with the duration of the
            //       // Lottie file and start the animation.
            //       _controller
            //         ..duration = composition.duration
            //         ..forward();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
