import 'package:flutter/material.dart';

class Clipper extends CustomClipper<Path> {
  final bool? isMe;
  final double radius;
  final double nipSize;

  Clipper({this.isMe, this.radius = 15, this.nipSize = 7});

  @override
  Path getClip(Size size) {
    var path = Path();

    if (isMe!) {
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius - nipSize, 0);
      path.arcToPoint(Offset(size.width - nipSize, radius),
          radius: Radius.circular(radius));

      path.lineTo(size.width - nipSize, size.height - nipSize);

      path.arcToPoint(Offset(size.width, size.height),
          radius: Radius.circular(nipSize), clockwise: false);

      path.arcToPoint(Offset(size.width - 2 * nipSize, size.height - nipSize),
          radius: Radius.circular(2 * nipSize));

      path.arcToPoint(Offset(size.width - 4 * nipSize, size.height),
          radius: Radius.circular(2 * nipSize));

      path.lineTo(radius, size.height);
      path.arcToPoint(Offset(0, size.height - radius),
          radius: Radius.circular(radius));
      path.lineTo(0, radius);
      path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
    } else {
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius),
          radius: Radius.circular(radius));

      path.lineTo(size.width, size.height - radius);

      path.arcToPoint(Offset(size.width - radius, size.height),
          radius: Radius.circular(radius));

      path.lineTo(4 * nipSize, size.height);
      path.arcToPoint(Offset(2 * nipSize, size.height - nipSize),
          radius: Radius.circular(2 * nipSize));

      path.arcToPoint(Offset(0, size.height),
          radius: Radius.circular(2 * nipSize));

      path.arcToPoint(Offset(nipSize, size.height - nipSize),
          radius: Radius.circular(nipSize), clockwise: false);

      path.lineTo(nipSize, radius);
      path.arcToPoint(Offset(radius + nipSize, 0),
          radius: Radius.circular(radius));
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
