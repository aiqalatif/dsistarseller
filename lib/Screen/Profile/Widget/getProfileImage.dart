import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/parameterString.dart';
import '../Profile.dart';

class GetProfileImage extends StatelessWidget {
  final Function update;
  const GetProfileImage({
    Key? key,
    required this.update,
  }) : super(key: key);

  imageFromGallery(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'eps'],
    );
    if (result != null) {
      File image = File(result.files.single.path!);
      profileProvider!.isLoading = false;
      profileProvider!.selectedImageFromGellery = image;
      profileProvider!.updateProfilePic(context, update);
      update();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: primary,
        child: GestureDetector(
          onTap: () {
            imageFromGallery(context);
          },
          child: LOGO != ''
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        BorderRadius.circular(circularBorderRadius100),
                    border: Border.all(
                      color: primary,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(LOGO),
                    radius: 100,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        BorderRadius.circular(circularBorderRadius100),
                    border: Border.all(
                      color: primary,
                    ),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    size: 100,
                  ),
                ),
        ),
      ),
    );
  }
}
