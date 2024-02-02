import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomPaintScreen extends StatefulWidget {
  const CustomPaintScreen({super.key});

  @override
  State<CustomPaintScreen> createState() => _CustomPaintScreenState();
}

class _CustomPaintScreenState extends State<CustomPaintScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          50.sp.sbh,

          // ClipPath(
          //   clipper: Clipper2(
          //     sizeA: 140,
          //   ),
          //   // clipper: RoundedDiagonalPathClipper(),
          //   child: Container(
          //     width: context.getWidth,
          //     height: 200.sp,
          //     color: Colors.pink,
          //     child: Image.network(
          //       "https://images.unsplash.com/photo-1682686580024-580519d4b2d2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8",
          //     ),
          //   ),
          // ),
          // ClipPath(
          //   clipper: MyCustomClipper(),
          //   child: Container(
          //     width: double.infinity,
          //     height: 500,
          //     color: Colors.amberAccent,
          //   ),
          // ),
        ],
      ),
    );
  }

  // _buildItem(int index) {
  //   return Positioned(
  //     child: GestureDetector(
  //         onTap: () {},
  //         child: Column(
  //           children: [
  //             Container(
  //               height: 65.sp,
  //               width: 65.sp,
  //               decoration: BoxDecoration(
  //                 image: const DecorationImage(
  //                   image: NetworkImage('http://i.imgur.com/QSev0hg.jpg'),
  //                   fit: BoxFit.cover,
  //                 ),
  //                 borderRadius: const BorderRadius.all(Radius.circular(50.0)),
  //                 border: Border.all(
  //                   color: AppColors.redColor,
  //                   width: 1.0,
  //                 ),
  //               ),
  //             ),
  //             0.5.h.sbh,
  //             CustomText(
  //               color: AppColors.white,
  //               maxLine: 1,
  //               fontSize: 10.sp,
  //               text: 'Richa',
  //               textAlign: TextAlign.start,
  //               fontFamily: "AppFonts.poppinsRegular",
  //               fontWeight: FontWeight.normal,
  //             ),
  //           ],
  //         )),
  //   );
  // }
}

class Clipper2 extends CustomClipper<Path> {
  Clipper2({required this.sizeA});

  double sizeA;
  @override
  Path getClip(Size size) {
    var factorW = size.width / 100;
    var factorH = size.height / 100;
    return Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(
        100.0 * factorW,
        0.0,
      )
      ..lineTo(
        100.0 * factorW,
        72.6 * factorH,
      )
      ..cubicTo(
        sizeA + 50.7 * factorW,
        72.6 * factorH,
        sizeA + 57.3 * factorW,
        72.6 * factorH,
        sizeA + 48.4 * factorW,
        72.6 * factorH,
      )
      ..cubicTo(
        sizeA + 41.1 * factorW,
        72.6 * factorH,
        sizeA + 38.6 * factorW,
        75.2 * factorH,
        sizeA + 38.6 * factorW,
        88.3 * factorH,
      )
      ..cubicTo(
        sizeA + 38.6 * factorW,
        97.3 * factorH,
        sizeA + 38.2 * factorW,
        100.0 * factorH,
        sizeA + 33.5 * factorW,
        100.0 * factorH,
      )
      ..cubicTo(
        sizeA + 19 * factorW,
        100.0 * factorH,
        sizeA * factorW,
        100.0 * factorH,
        0.0,
        100.0 * factorH,
      )
      ..lineTo(0.0, 0.0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
