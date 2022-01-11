import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/account/edit_account/change_bio/change_bio_view.dart';

Widget cwAccountBio(BuildContext context, String? bio) {
  return bio != null ? Text(
    bio,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.black),
  ) : InkWell(
    onTap: () {
      navService.materialPageRoute(context, const ChangeBioView());
    },
    child: Text(
      'Add Your bio',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.black),
    ),
  );
}
