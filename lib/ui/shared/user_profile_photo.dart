import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;


Widget userProfilePhoto(BuildContext context, String imageUrl,
    {double height = 48, double width = 48, BorderRadius? borderRadius}) {
  return SizedBox(
    width: width,
    height: height,
    child: ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Smiley(),
        errorWidget: (context, url, error) => const Smiley(),
        // imageBuilder: (context, imageProvider) => const Smiley(),
      ),
    ),
  );
}

class Smiley extends StatelessWidget {
  const Smiley({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SmileyPainter(),
    );
  }
}

class SmileyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    // Draw the body
    final paint = Paint()..color = Colors.grey.shade700;
    canvas.drawCircle(center, radius, paint);
    // Draw the mouth
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius / 2), 0,
        math.pi, false, smilePaint);
    // Draw the eyes
    canvas.drawCircle(
        Offset(center.dx - radius / 3, center.dy - radius / 2), 1, Paint());
    canvas.drawCircle(
        Offset(center.dx + radius / 3, center.dy - radius / 2), 1, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}