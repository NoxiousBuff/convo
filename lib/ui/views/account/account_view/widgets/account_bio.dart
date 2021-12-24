import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

Widget cwAccountBio(BuildContext context, String bio) {
  return Text(
    bio,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.black),
  );
}
