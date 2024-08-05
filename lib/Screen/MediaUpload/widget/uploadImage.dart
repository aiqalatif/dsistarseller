import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/snackbar.dart';
import '../../../Widget/validation.dart';
import '../Media.dart';

class UploadImage extends StatelessWidget {
  final Function update;
  final String from;
  const UploadImage({
    Key? key,
    required this.update,
    required this.from,
  }) : super(key: key);

  videoFromGallery(BuildContext context) async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp4',
        '3gp',
        'avchd',
        'avi',
        'flv',
        'mkv',
        'mov',
        'webm',
        'wmv',
        'mpg',
        'mpeg',
        'ogg'
      ],
    );
    if (result != null) {
      File video = File(result.files.single.path!);
      videoFromGellery = video;
      result.names[0] == null
          ? setSnackbar(
              getTranslated(
                  context, "Error in video uploading please try again...!")!,
              context,
            )
          : () {
              mediaProvider!.uploadedVideoName = result.names[0]!;
            }();
      update();
    } else {
      // User canceled the picker
    }
  }

  imageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'eps'],
    );
    if (result != null) {
      File image = File(result.files.single.path!);
      mediaProvider!.selectedImageFromGellery = image;
      update();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 10,
        bottom: 5,
        start: 10,
        end: 10,
      ),
      child: Card(
        child: InkWell(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getTranslated(context, "Upload media from Gellery")!,
                  style: const TextStyle(fontSize: textFontSize16),
                ),
              ),
              InkWell(
                onTap: () {
                  if (from == "video") {
                    videoFromGallery(context);
                  } else {
                    imageFromGallery();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(circularBorderRadius5),
                  ),
                  width: 120,
                  height: 40,
                  child: Center(
                    child: Text(
                      getTranslated(context, "Select File")!,
                      style: const TextStyle(
                        color: white,
                      ),
                    ),
                  ),
                ),
              ),
              mediaProvider!.selectedImageFromGellery == null
                  ? Container()
                  : const SizedBox(
                      height: 10,
                      width: double.infinity,
                    ),
              mediaProvider!.uploadedVideoName == null
                  ? Container()
                  : const SizedBox(
                      height: 10,
                      width: double.infinity,
                    ),
              mediaProvider!.selectedImageFromGellery == null
                  ? Container()
                  : Image.file(
                      mediaProvider!.selectedImageFromGellery!,
                      height: 200,
                      width: 200,
                    ),
              mediaProvider!.uploadedVideoName == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Text(mediaProvider!.uploadedVideoName!)),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
              mediaProvider!.selectedImageFromGellery == null
                  ? Container()
                  : const SizedBox(
                      height: 10,
                      width: double.infinity,
                    ),
              mediaProvider!.uploadedVideoName == null
                  ? Container()
                  : const SizedBox(
                      height: 10,
                      width: double.infinity,
                    ),
              mediaProvider!.selectedImageFromGellery == null
                  ? Container()
                  : InkWell(
                      onTap: () {
                        mediaProvider!.mediaList = [];
                        mediaProvider!.scrollOffset = 0;
                        mediaProvider!.isImageUploading;
                        update();
                        mediaProvider!.isImageUploading
                            ? ""
                            : mediaProvider!
                                .uploadMediaAPI(context, update, from);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              BorderRadius.circular(circularBorderRadius5),
                        ),
                        width: 120,
                        height: 40,
                        child: Center(
                          child: Text(
                            getTranslated(context, "Upload")!,
                            style: const TextStyle(
                              color: white,
                            ),
                          ),
                        ),
                      ),
                    ),
              mediaProvider!.uploadedVideoName == null
                  ? Container()
                  : InkWell(
                      onTap: () {
                        mediaProvider!.uploadMediaAPI(context, update, from);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              BorderRadius.circular(circularBorderRadius5),
                        ),
                        width: 120,
                        height: 40,
                        child: Center(
                          child: Text(
                            getTranslated(context, "Upload")!,
                            style: const TextStyle(
                              color: white,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
