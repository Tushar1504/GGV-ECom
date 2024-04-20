import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/constants/my_colors.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.title,
    required this.onPressed,
  });
  final String title;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryColor,
        minimumSize: Size(
          MediaQuery.of(context).size.width,
          42.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            11.r,
          ),
        ),
      ),
      child: title.text
          .color(Colors.white)
          .size(16.sp)
          .fontWeight(FontWeight.w700)
          .make(),
    );
  }
}