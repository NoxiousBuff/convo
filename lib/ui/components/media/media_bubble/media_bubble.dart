import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

Widget mediaBubble(
    {required BuildContext context,
    required bool isRead,
    required Widget child}) {
  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.2,
          maxWidth: MediaQuery.of(context).size.width * 0.65,
          minHeight: MediaQuery.of(context).size.width * 0.2,
          maxHeight: MediaQuery.of(context).size.height * 0.35,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: child,
        ),
      ), 
      isRead
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: Text(
                'unread',
                style: GoogleFonts.roboto(
                  color: lightBlue,
                  fontSize: 10.0,
                ),
              ),
            ),
    ],
  );
}
