import 'package:flutter/material.dart';
import 'activePhoto.dart';
import 'inActivePhoto.dart';

class SelectedPhoto extends StatelessWidget {
  final int? numberOfDots;
  final int? photoIndex;

  const SelectedPhoto({Key? key, this.numberOfDots, this.photoIndex})
      : super(key: key);

  List<Widget> _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots!; i++) {
      dots.add(
        i == photoIndex ? const ActivePhoto() : const InActivePhoto(),
      );
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(),
      ),
    );
  }
}
