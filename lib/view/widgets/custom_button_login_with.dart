import 'package:flutter/material.dart';
import '../../app/theme.dart';

class CustomButtonLoginWith extends StatelessWidget {
  final String logoLoginWith;
  final String textLoginWith;
  final Function() onPressed;
  const CustomButtonLoginWith({
    Key? key,
    required this.logoLoginWith,
    required this.textLoginWith,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(66),
        color: Colors.green,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 25.0,
            height: 25.0,
            margin: const EdgeInsets.only(
              right: 8.0,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(logoLoginWith),
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(textLoginWith, style: kWhiteTextStyle),
          ),
        ],
      ),
    );
  }
}
