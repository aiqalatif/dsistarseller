import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/routes.dart';
import '../../../Widget/validation.dart';
import '../../Map/map.dart';
import '../Profile.dart';

class CommanDesingFields extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? variable;
  final String empty;
  final String addField;
  @override
  final GlobalKey<FormState>? key;
  final TextInputType? keybordtype;
  final String? Function(String?)? validation;
  final int index;
  final Function update;
  final bool fromMap;

  const CommanDesingFields({
    required this.icon,
    required this.title,
    required this.variable,
    required this.empty,
    required this.addField,
    this.keybordtype,
    required this.index,
    this.validation,
    this.key,
    required this.update,
    required this.fromMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              icon,
              color: primary,
              size: 27,
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: lightBlack2,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  index == 16 && profileProvider!.selectedAuthSign != null
                      ? Image.file(
                          profileProvider!.selectedAuthSign,
                          width: 100,
                          height: 100,
                        )
                      : variable != "" && variable != null
                          ? index == 16
                              ? DesignConfiguration.getCacheNotworkImage(
                                  boxFit: BoxFit.cover,
                                  context: context,
                                  heightvalue: 94,
                                  widthvalue: 64,
                                  imageurlString: variable!,
                                  placeHolderSize: 150,
                                )
                              : Text(
                                  variable!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: lightBlack,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                )
                          : Text(
                              empty,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: index == 12
                ? Container()
                : IconButton(
                    icon: Icon(
                      index == 11 ? Icons.my_location : Icons.edit,
                      size: 20,
                      color: index == 11 ? red : black,
                    ),
                    onPressed: () async {
                      if (index == 16) {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [
                            'jpg',
                            'jpeg',
                            'png',
                            'gif',
                            'bmp',
                            'eps'
                          ],
                        );
                        if (result != null) {
                          File image = File(result.files.single.path!);
                          profileProvider!.selectedAuthSign = image;
                          //profileProvider!.updateProfilePic(context, update);
                          update();
                        } else {}
                      } else if (index != 11) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: const EdgeInsets.all(0),
                              elevation: 2.0,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(circularBorderRadius5),
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 20.0, 0, 2.0),
                                    child: Text(
                                      addField,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: primary),
                                    ),
                                  ),
                                  const Divider(color: black),
                                  Form(
                                    key: key,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20.0, 0, 20.0, 0),
                                      child: TextFormField(
                                        keyboardType: keybordtype,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: lightBlack,
                                              fontWeight: FontWeight.normal,
                                            ),
                                        validator: validation,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: () {
                                          if (index == 0) {
                                            return profileProvider!.nameC;
                                          } else if (index == 1) {
                                            return profileProvider!.mobileC;
                                          } else if (index == 2) {
                                            return profileProvider!.emailC;
                                          } else if (index == 3) {
                                            return profileProvider!.addressC;
                                          } else if (index == 4) {
                                            return profileProvider!.storenameC;
                                          } else if (index == 5) {
                                            return profileProvider!.storeurlC;
                                          } else if (index == 6) {
                                            return profileProvider!.storeDescC;
                                          } else if (index == 7) {
                                            return profileProvider!.accnumberC;
                                          } else if (index == 8) {
                                            return profileProvider!.accnameC;
                                          } else if (index == 9) {
                                            return profileProvider!.bankcodeC;
                                          } else if (index == 10) {
                                            return profileProvider!.banknameC;
                                          } else if (index == 11) {
                                            return profileProvider!.latitututeC;
                                          } else if (index == 12) {
                                            return profileProvider!.longituteC;
                                          } else if (index == 13) {
                                            return profileProvider!.taxnameC;
                                          } else if (index == 14) {
                                            return profileProvider!.taxnumberC;
                                          } else if (index == 15) {
                                            return profileProvider!.pannumberC;
                                          }
                                          return profileProvider!.unusedC;
                                        }(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    getTranslated(context, "CANCEL")!,
                                    style: const TextStyle(
                                      color: lightBlack,
                                      fontSize: textFontSize15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Routes.pop(context);
                                    update();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    getTranslated(context, "SAVE_LBL")!,
                                    style: const TextStyle(
                                      color: primary,
                                      fontSize: textFontSize15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    final form = key!.currentState!;
                                    if (form.validate()) {
                                      form.save();
                                      () {
                                        if (index == 0) {
                                          profileProvider!.name =
                                              profileProvider!.nameC!.text;
                                        } else if (index == 1) {
                                          profileProvider!.mobile =
                                              profileProvider!.mobileC!.text;
                                        } else if (index == 2) {
                                          profileProvider!.email =
                                              profileProvider!.emailC!.text;
                                        } else if (index == 3) {
                                          profileProvider!.address =
                                              profileProvider!.addressC!.text;
                                        } else if (index == 4) {
                                          profileProvider!.storename =
                                              profileProvider!.storenameC!.text;
                                        } else if (index == 5) {
                                          profileProvider!.storeurl =
                                              profileProvider!.storeurlC!.text;
                                        } else if (index == 6) {
                                          profileProvider!.storeDesc =
                                              profileProvider!.storeDescC!.text;
                                        } else if (index == 7) {
                                          profileProvider!.accNo =
                                              profileProvider!.accnumberC!.text;
                                        } else if (index == 8) {
                                          profileProvider!.accname =
                                              profileProvider!.accnameC!.text;
                                        } else if (index == 9) {
                                          profileProvider!.bankcode =
                                              profileProvider!.bankcodeC!.text;
                                        } else if (index == 10) {
                                          profileProvider!.bankname =
                                              profileProvider!.banknameC!.text;
                                        } else if (index == 11) {
                                          profileProvider!.latitutute =
                                              profileProvider!
                                                  .latitututeC!.text;
                                        } else if (index == 12) {
                                          profileProvider!.longitude =
                                              profileProvider!.longituteC!.text;
                                        } else if (index == 13) {
                                          profileProvider!.taxname =
                                              profileProvider!.taxnameC!.text;
                                        } else if (index == 14) {
                                          profileProvider!.taxnumber =
                                              profileProvider!.taxnumberC!.text;
                                        } else if (index == 15) {
                                          profileProvider!.pannumber =
                                              profileProvider!.pannumberC!.text;
                                        }
                                      }();
                                      Routes.pop(context);
                                      update();
                                    }
                                  },
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        LocationPermission permission;
                        permission = await Geolocator.checkPermission();
                        if (permission == LocationPermission.denied) {
                          permission = await Geolocator.requestPermission();
                        }
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => MapScreen(
                              latitude: position.latitude,
                              longitude: position.longitude,
                              from: true,
                            ),
                          ),
                        ).then(
                          (value) {
                            profileProvider!.latitututeC!.text =
                                profileProvider!.latitutute!;
                            profileProvider!.longituteC!.text =
                                profileProvider!.longitude!;
                            update();
                          },
                        );
                      }
                    },
                  ),
          )
        ],
      ),
    );
  }
}

getDivider() {
  return const Divider(
    height: 1,
    color: lightBlack,
  );
}
