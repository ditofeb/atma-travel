import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

class SingleButtonAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback onPressed;

  const SingleButtonAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyles.poppinsBold(fontSize: 20),
      ),
      content: Text(
        content,
        style: TextStyles.poppinsNormal(fontSize: 15),
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyles.poppinsNormal(fontSize: 15, color: themeColor),
          ),
        ),
      ],
    );
  }
}

class TwoButtonAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String rightButtonText;
  final String leftButtonText;
  final VoidCallback onRightPressed;
  final VoidCallback onLeftPressed;

  const TwoButtonAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.rightButtonText,
    required this.leftButtonText,
    required this.onRightPressed,
    required this.onLeftPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyles.poppinsBold(fontSize: 20),
      ),
      content: Text(
        content,
        style: TextStyles.poppinsNormal(fontSize: 15),
      ),
      actions: [
        TextButton(
          onPressed: onLeftPressed,
          child: Text(
            leftButtonText,
            style: TextStyles.poppinsNormal(fontSize: 15),
          ),
        ),
        TextButton(
          onPressed: onRightPressed,
          child: Text(
            rightButtonText,
            style: TextStyles.poppinsNormal(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
