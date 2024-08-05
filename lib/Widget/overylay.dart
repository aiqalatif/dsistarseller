import 'package:flutter/material.dart';
import '../Helper/Color.dart';
import '../Helper/Constant.dart';

void showOverlay(
  String msg,
  BuildContext context,
) async {
  // Declaring and Initializing OverlayState
  // and OverlayEntry objects
  OverlayState overlayState = Overlay.of(context);
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      // You can return any widget you like
      // here to be displayed on the Overlay
      return Positioned(
        // left: MediaQuery.of(context).size.width,
        bottom: 0,
        child: Material(
          child: Container(
            color: Colors.white,
            // height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: black,
                    fontSize: textFontSize14,
                    fontFamily: 'ubuntu',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
  // Inserting the OverlayEntry into the Overlay
  overlayState.insert(overlayEntry);

  // Awaiting for 3 seconds
  await Future.delayed(const Duration(seconds: 2)).then(
    (value) {
      overlayEntry.remove();
    },
  );

  // Removing the OverlayEntry from the Overlay
}
