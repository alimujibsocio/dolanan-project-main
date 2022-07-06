import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.textButton,
    required this.onPressFunc,
    this.isPrimary = false,
    this.width = double.infinity,
    this.buttonColor = const Color(0xff4141A4),
  }) : super(key: key);

  final bool isPrimary;
  final double width;
  final Color buttonColor;
  final String textButton;
  final Function() onPressFunc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(66),
        color: buttonColor,
      ),
      child: TextButton(
          onPressed: onPressFunc,
          child: Text(
            textButton,
            style: GoogleFonts.poppins(
              color: isPrimary ? kPrimaryColor : kWhiteColor,
              fontWeight: medium,
            ),
          )),
    );
  }
}
