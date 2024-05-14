import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../core/constants/my_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,  // Example height, adjust as necessary
      child: VxTextField(
        controller: controller,
        hint: hint,
        fillColor: Colors.transparent,
        borderColor: MyColors.primaryColor,
        borderType: VxTextFieldBorderType.underLine,
        keyboardType: keyboardType,
      ),
    );
  }
}
