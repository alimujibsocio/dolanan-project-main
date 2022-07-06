import 'package:flutter/material.dart';

import '../../app/theme.dart';

class CustomTextField extends StatelessWidget {
  final String nameTextField;
  final Widget iconTextField;
  final TextEditingController controller;
  final bool isPassword;
  final bool isEnabled;

  const CustomTextField({
    Key? key,
    required this.nameTextField,
    required this.iconTextField,
    required this.controller,
    this.isEnabled = true,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: isEnabled,
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: nameTextField,
              hintStyle: kBlackTextStyle.copyWith(
                fontWeight: regular,
                fontSize: 16,
                color: isEnabled
                    ? const Color.fromARGB(255, 92, 92, 92)
                    : Colors.green,
              ),
              filled: true,
              fillColor: kGreyColor,
              suffixIcon: iconTextField,
              suffixIconColor: const Color.fromARGB(255, 92, 92, 92),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
