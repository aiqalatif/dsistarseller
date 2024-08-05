import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Screen/EditProduct/EditProduct.dart' as edit;
import '../../Helper/Constant.dart';
import '../../Model/MediaModel/MediaModel.dart';
import '../../Provider/mediaProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/routes.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/validation.dart';
import '../AddProduct/Add_Product.dart' as add;
import '../../Widget/noNetwork.dart';
import '../EmailSend/email.dart';

class Media extends StatefulWidget {
  final from, pos, type;
  const Media({
    Key? key,
    this.from,
    this.pos,
    this.type,
  }) : super(key: key);
  @override
  _MediaState createState() => _MediaState();
}

MediaProvider? mediaProvider;
File? videoFromGellery;
File? documentFromGellery;

class _MediaState extends State<Media> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    mediaProvider!.initializevariableClearData();
    super.initState();
    mediaProvider!.scrollOffset = 0;
    mediaProvider!.getMedia(setStateNow, context, widget.from);

    mediaProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    mediaProvider!.scrollController = ScrollController(keepScrollOffset: true);
    mediaProvider!.scrollController!.addListener(_transactionscrollListener);

    mediaProvider!.buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: mediaProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  _transactionscrollListener() {
    if (mediaProvider!.scrollController!.offset >=
            mediaProvider!.scrollController!.position.maxScrollExtent &&
        !mediaProvider!.scrollController!.position.outOfRange) {
      if (mounted) {
        setState(
          () {
            mediaProvider!.scrollLoadmore = true;
            mediaProvider!.getMedia(setStateNow, context, widget.from);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(getTranslated(context, 'Media')!, context),
      body: isNetworkAvail
          ? _showContent()
          : noInternet(
              context,
              setStateNoInternate,
              mediaProvider!.buttonSqueezeanimation,
              mediaProvider!.buttonController),
    );
  }

  _showContent() {
    return mediaProvider!.scrollNodata
        ? Column(
            children: [
              uploadImage(),
              DesignConfiguration.getNoItem(context),
            ],
          )
        : NotificationListener<ScrollNotification>(
            child: Column(
              children: [
                uploadImage(),
                Expanded(
                  child: ListView.builder(
                    controller: mediaProvider!.scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsetsDirectional.only(
                        bottom: 5, start: 10, end: 10),
                    itemCount: mediaProvider!.mediaList.length,
                    itemBuilder: (context, index) {
                      MediaModel? item;

                      item = mediaProvider!.mediaList.isEmpty
                          ? null
                          : mediaProvider!.mediaList[index];

                      return item == null ? Container() : getMediaItem(index);
                    },
                  ),
                ),
                mediaProvider!.scrollGettingData
                    ? const Padding(
                        padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ],
            ),
          );
  }

  uploadImage() {
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
                  if (widget.from == "archive,document") {
                    digitalProductGallery();
                  }
                  if (widget.from == "video") {
                    videoFromGallery();
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
              documentFromGellery == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.file_open,
                              color: primary,
                            ),
                          ),
                          Expanded(
                            child: Text(documentFromGellery!.path),
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
                        setState(() {});
                        mediaProvider!.isImageUploading
                            ? ""
                            : mediaProvider!.uploadMediaAPI(
                                context, setStateNow, widget.from);
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
                        mediaProvider!
                            .uploadMediaAPI(context, setStateNow, widget.from);
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
              documentFromGellery == null
                  ? Container()
                  : InkWell(
                      onTap: () {
                        mediaProvider!
                            .uploadMediaAPI(context, setStateNow, widget.from);
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

  digitalProductGallery() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'doc',
        'docx',
        'txt',
        'pdf',
        'ppt',
        'pptx',
      ],
    );
    if (result != null) {
      File document = File(result.files.single.path!);
      setState(
        () {
          documentFromGellery = document;
          result.names[0] == null
              ? setSnackbar(
                  getTranslated(context,
                      "Error in video uploading please try again...!")!,
                  context,
                )
              : () {
                  mediaProvider!.uploadedDocumentName = result.names[0]!;
                }();
        },
      );
      if (mounted) setState(() {});
    } else {
      // User canceled the picker
    }
  }

  videoFromGallery() async {
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
      setState(
        () {
          videoFromGellery = video;
          result.names[0] == null
              ? setSnackbar(
                  getTranslated(context,
                      "Error in video uploading please try again...!")!,
                  context,
                )
              : () {
                  mediaProvider!.uploadedVideoName = result.names[0]!;
                }();
        },
      );
      if (mounted) setState(() {});
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
      setState(
        () {
          mediaProvider!.selectedImageFromGellery = image;
        },
      );
    } else {}
  }

  getAppBar(String title, BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: white,
      leading: Builder(
        builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: DesignConfiguration.shadow(),
            child: InkWell(
              borderRadius: BorderRadius.circular(circularBorderRadius5),
              onTap: () => Navigator.of(context).pop(),
              child: const Center(
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: primary,
                  size: 30,
                ),
              ),
            ),
          );
        },
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: grad2Color,
        ),
      ),
      actions: [
        (widget.from == "other" ||
                widget.from == 'variant' ||
                (widget.from == "main" && widget.type == "add"))
            ? TextButton(
                onPressed: () {
                  if (widget.from == "other") {
                    if (widget.type == "add") {
                      // add.otherPhotos.addAll(otherImgList);
                      // add.otherImageUrl.addAll(otherImgUrlList);
                      for (var element in mediaProvider!.mediaList) {
                        if (element.isSelected) {
                          add.addProvider!.otherPhotos.add(element.path!);
                          add.addProvider!.otherImageUrl.add(element.image!);
                        }
                      }
                    }
                    if (widget.type == "edit") {
                      edit.editProvider!.otherPhotos
                          .addAll(mediaProvider!.otherImgList);
                      if (edit.editProvider!.showOtherImages.isNotEmpty) {
                        if (mediaProvider!.otherImgList.isNotEmpty) {
                          for (int i = 0;
                              i < edit.editProvider!.showOtherImages.length;
                              i++) {
                            edit.editProvider!.showOtherImages.removeLast();
                          }
                        }
                      }
                      edit.editProvider!.showOtherImages
                          .addAll(mediaProvider!.otherImgUrlList);
                    }
                  } else if (widget.from == 'variant') {
                    if (widget.type == "add") {
                      add.addProvider!.variationList[widget.pos].images =
                          mediaProvider!.variantImgList;
                      add.addProvider!.variationList[widget.pos].imagesUrl =
                          mediaProvider!.variantImgUrlList;
                      add.addProvider!.variationList[widget.pos]
                              .imageRelativePath =
                          mediaProvider!.variantImgRelativePath;
                    }
                    if (widget.type == "edit") {
                      edit.editProvider!.variationList[widget.pos].images =
                          mediaProvider!.variantImgList;
                      edit.editProvider!.variationList[widget.pos].imagesUrl =
                          mediaProvider!.variantImgUrlList;
                      edit.editProvider!.variationList[widget.pos]
                              .imageRelativePath =
                          mediaProvider!.variantImgRelativePath;
                    }
                  }
                  Routes.pop(context);
                },
                child: Text(
                  getTranslated(context, "Done")!,
                ),
              )
            : Container()
      ],
    );
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => super.widget)).then(
            (value) {
              setState(
                () {},
              );
            },
          );
        } else {
          await mediaProvider!.buttonController!.reverse();
          if (mounted) {
            setState(
              () {},
            );
          }
        }
      },
    );
  }

  Future<void> _playAnimation() async {
    try {
      await mediaProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  getMediaItem(int index) {
    return Card(
      child: InkWell(
        onTap: () {
          setState(
            () {
              mediaProvider!.mediaList[index].isSelected =
                  !mediaProvider!.mediaList[index].isSelected;

              if (widget.from == "main") {
                if (widget.type == "add") {
                  mediaProvider!.currentSelectedName =
                      mediaProvider!.mediaList[index].id!;
                  add.addProvider!.productImage =
                      "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
                  add.addProvider!.productImageUrl =
                      mediaProvider!.mediaList[index].image!;
                }
                if (widget.type == "edit") {
                  edit.editProvider!.productImage =
                      "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
                  edit.editProvider!.productImageUrl =
                      mediaProvider!.mediaList[index].image!;
                  edit.editProvider!.productImageRelativePath =
                      mediaProvider!.mediaList[index].path!;
                }
              } else if (widget.from == "video") {
                if (widget.type == "add") {
                  add.addProvider!.uploadedVideoName =
                      "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
                }
                if (widget.type == "edit") {
                  edit.editProvider!.uploadedVideoName =
                      "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
                }
                Routes.pop(context);
              } else if (widget.from == "archive,document") {
                if (widget.type == 'email') {
                  selectedUploadFileSubDic =
                      mediaProvider!.mediaList[index].subDic! +
                          mediaProvider!.mediaList[index].name!;
                }
                if (widget.type == "add") {
                  add.addProvider!.digitalProductName =
                      "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
                }
                if (widget.type == "edit") {
                  edit.editProvider!.digitalProductNamePathNameForSelectedFile =
                      "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
                }
                Routes.pop(context);
              } else if (widget.from == "other") {
                if (mediaProvider!.mediaList[index].isSelected) {
                  mediaProvider!.otherImgList
                      .add(mediaProvider!.mediaList[index].path!);
                  mediaProvider!.otherImgUrlList
                      .add(mediaProvider!.mediaList[index].image!);
                } else {
                  mediaProvider!.otherImgList
                      .add(mediaProvider!.mediaList[index].path!);
                  mediaProvider!.otherImgUrlList
                      .remove(mediaProvider!.mediaList[index].image!);
                }
              } else if (widget.from == 'variant') {
                if (mediaProvider!.mediaList[index].isSelected) {
                  mediaProvider!.variantImgList.add(
                      "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}");
                  mediaProvider!.variantImgUrlList
                      .add(mediaProvider!.mediaList[index].image!);
                  mediaProvider!.variantImgRelativePath
                      .add(mediaProvider!.mediaList[index].path!);
                } else {
                  mediaProvider!.variantImgList.remove(
                      "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}");
                  mediaProvider!.variantImgUrlList
                      .remove(mediaProvider!.mediaList[index].image!);
                  mediaProvider!.variantImgRelativePath
                      .remove(mediaProvider!.mediaList[index].path!);
                }
              }
            },
          );
        },
        child: Stack(
          children: [
            Row(
              children: [
                Image.network(
                  mediaProvider!.mediaList[index].image!,
                  height: 200,
                  width: 200,
                  errorBuilder: (context, error, stackTrace) =>
                      DesignConfiguration.erroWidget(200),
                  color: Colors.black.withOpacity(
                      mediaProvider!.mediaList[index].isSelected ? 1 : 0),
                  colorBlendMode: BlendMode.color,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${getTranslated(context, "Name")!} : ${mediaProvider!.mediaList[index].name!}'),
                        Text(
                            '${getTranslated(context, "Sub Directory")!} : ${mediaProvider!.mediaList[index].subDic!}'),
                        Text(
                            '${getTranslated(context, "Size")!} : ${mediaProvider!.mediaList[index].size!}'),
                        Text(
                            '${getTranslated(context, "extension")!} : ${mediaProvider!.mediaList[index].extention!}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.black.withOpacity(
                  mediaProvider!.mediaList[index].isSelected ? 0.1 : 0),
            ),
            widget.from != "main"
                ? mediaProvider!.mediaList[index].isSelected
                    ? const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check_circle,
                            color: primary,
                          ),
                        ),
                      )
                    : Container()
                : mediaProvider!.currentSelectedName ==
                        mediaProvider!.mediaList[index].id!
                    ? const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check_circle,
                            color: primary,
                          ),
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
