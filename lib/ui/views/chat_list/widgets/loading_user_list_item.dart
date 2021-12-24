  import 'package:flutter/material.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

Widget loadingUserListItem(BuildContext context) {
    return ListTile(
      onTap: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      leading: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: RadialGradient(
            colors: [
              Colors.indigo.shade300.withAlpha(30),
              Colors.indigo.shade400.withAlpha(50),
            ],
            focal: Alignment.topLeft,
            radius: 0.8,
          ),
        ),
        height: 56.0,
        width: 56.0,
        child:  const Text(
          '',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          margin: EdgeInsets.only(
              right: screenWidthPercentage(context, percentage: 0.1)),
          decoration: BoxDecoration(
            color: Colors.indigo.shade400.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(''),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(
            right: screenWidthPercentage(context, percentage: 0.4)),
        decoration: BoxDecoration(
          color: Colors.indigo.shade300.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(''),
      ),
    );
  }