import 'package:flutter/cupertino.dart';

class ContainerClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final width = size.width / 2;

    Path path = Path();
    //start Point to 0.33  => axis - point(x= 0, y=0)
    path.moveTo(width - 60, 0);
    path.lineTo(width, 60);
    path.lineTo(width + 60, 0);
    path.lineTo(size.width * 0.97, 0);
    //path.moveTo(width,70 );
    //path.lineTo(size.width, 0);
    // path.lineTo(width , 50);
    //down line
    // path.lineTo(width * 0.495, height * 0.12);
    // //down to bit straight
    // path.lineTo(width * 0.505, height * 0.12);
    // //up side
    // path.lineTo(width * 0.83, -(height * 0.12));
    // // it end => axis - point(x= 0, y=1)
    // path.lineTo(size.width * (0.97), 0);
    //for top right curve
    path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.03);
    //curve to down => axis - point(x= 1, y= 1)
    path.lineTo(size.width, size.height * (0.97));
    //for bottom right curve
    path.quadraticBezierTo(
        size.width, size.height, size.width * (0.98), size.height);
    // left to right line => axis - point(x= 1, y=0)
    path.lineTo(size.width * (0.03), size.height);
    //for bottom left curve
    path.quadraticBezierTo(0, size.height, 0, size.height * (0.97));
    // down to up => axis - point(x= 0, y=0)
    path.lineTo(0, size.height * (0.03));
    //for top left curve
    path.quadraticBezierTo(0, 0, size.width * (0.03), 0);
    //path.lineTo(width-60, 0);

    // let's pack it.
    //path.close();
    //Old code with out circular border

    // path.lineTo(width * (0.2), 0);
    // path.lineTo(width * (0.33), 0);
    // path.lineTo(width * 0.495, height * 0.12);
    // path.lineTo(width * 0.505, height * 0.12);
    // //  path.quadraticBezierTo(width * (0.5), height * (0.2), width * (0.6), 0);
    // path.lineTo(width * 0.83, -(height * 0.12));
    // // path.quadraticBezierTo(size.width, 0, size.width * 0.9, size.height * 0.05);

    // path.lineTo(width, 0);
    // path.lineTo(width, height);
    // path.lineTo(0, height);
    // path.lineTo(0, height * 2);

    //  path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
