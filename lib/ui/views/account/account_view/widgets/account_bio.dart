import 'package:flutter/cupertino.dart';

Widget cwAccountBio(BuildContext context, String bio) {
  return Text(
    bio,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );
}
