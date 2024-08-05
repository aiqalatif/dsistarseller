import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Helper/Color.dart';
import '../../../Widget/desing.dart';

class CommonRowBtn extends StatelessWidget {
  final String title;
  final VoidCallback onBtnSelected;

  const CommonRowBtn({Key? key, required this.title, required this.onBtnSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBtnAnimation(context);
  }

  Widget _buildBtnAnimation(BuildContext context) {
    return InkWell(
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(7), color: white),
        padding: const EdgeInsets.all(7),
        child: SvgPicture.asset(
          DesignConfiguration.setSvgPath(title),
          alignment: Alignment.center,
          height: 30,
          width: 30,
          fit: BoxFit.contain,
        ),
      ),
      onTap: () {
        onBtnSelected();
      },
    );
  }
}
