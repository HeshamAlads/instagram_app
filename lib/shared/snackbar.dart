import 'package:flutter/material.dart';
import 'package:instagram_app/shared/colors.dart';

showSnackBar(
  BuildContext context,
  String text,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(15), bottom: Radius.circular(3)),
      ),
      behavior: SnackBarBehavior.fixed,
      showCloseIcon: true,
      padding: const EdgeInsets.all(5),
      backgroundColor: secondaryColor,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 3),
      content: Center(
          child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
      )),
    ),
  );
}
