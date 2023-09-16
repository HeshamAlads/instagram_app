import 'package:flutter/material.dart';
import 'package:instagram_app/shared/colors.dart';

const decorationTextField = InputDecoration(
// To delete borders

  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 3,
      color: Colors.blueGrey,
    ),
  ),
  fillColor: secondaryColor,
  filled: true,
  contentPadding: EdgeInsets.all(10),
);
