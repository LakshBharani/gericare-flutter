import 'package:flutter/material.dart';
import 'package:gericare/constants.dart';

// common title widget
Widget title(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: appBarTitle,
    ),
  );
}
