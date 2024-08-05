import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import '../Helper/Constant.dart';
import '../Model/MediaModel/MediaModel.dart';
import '../Repository/mediaRepositry.dart';
import '../Screen/MediaUpload/Media.dart';
import '../Widget/api.dart';
import '../Widget/security.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/snackbar.dart';
import '../Widget/validation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MediaProvider extends ChangeNotifier {
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool scrollLoadmore = true, scrollGettingData = false, scrollNodata = false;
  int scrollOffset = 0;
  List<MediaModel> mediaList = [];
  List<MediaModel> tempList = [];
  List<MediaModel> selectedList = [];
  ScrollController? scrollController;
  late List<String> variantImgList = [];
  late List<String> variantImgUrlList = [];
  late List<String> variantImgRelativePath = [];
  late List<String> otherImgList = [];
  late List<String> otherImgUrlList = [];
  var selectedImageFromGellery;

  String? uploadedVideoName;
  String currentSelectedName = "";
  bool isImageUploading = false;
  String? uploadedDocumentName;
  initializevariableClearData() {
    scrollLoadmore = true;
    scrollGettingData = false;
    scrollNodata = false;
    scrollOffset = 0;
    mediaList = [];
    tempList = [];
    selectedList = [];
    variantImgList = [];
    variantImgUrlList = [];
    variantImgRelativePath = [];
    otherImgList = [];
    otherImgUrlList = [];
    selectedImageFromGellery = null;
    videoFromGellery = null;
    uploadedVideoName = null;
    currentSelectedName = "";
    isImageUploading = false;
  }

  Future getMedia(
    Function update,
    BuildContext context,
    String from,
  ) async {
    try {
      isNetworkAvail = await isNetworkAvailable();
      if (isNetworkAvail) {
        if (mediaProvider!.scrollLoadmore) {
          mediaProvider!.scrollLoadmore = false;
          mediaProvider!.scrollGettingData = true;
          if (mediaProvider!.scrollOffset == 0) {
            mediaProvider!.mediaList = [];
          }
        }
        var parameter = {
          // SellerId: context.read<SettingProvider>().CUR_USERID!,
          LIMIT: perPage.toString(),
          OFFSET: mediaProvider!.scrollOffset.toString(),
        };
        if (from == "video") {
          parameter["type"] = "video";
        }
        if (from == "archive,document") {
          parameter["type"] = "archive,document";
        }
        var result = await MediaRepository.getMedia(parameter: parameter);
        bool error = result["error"];
        mediaProvider!.scrollGettingData = false;
        if (mediaProvider!.scrollOffset == 0) {
          mediaProvider!.scrollNodata = error;
        }
        if (!error) {
          mediaProvider!.tempList.clear();
          var data = result["data"];
          if (data.length != 0) {
            mediaProvider!.tempList = (data as List)
                .map((data) => MediaModel.fromJson(data))
                .toList();

            mediaProvider!.mediaList.addAll(mediaProvider!.tempList);
            mediaProvider!.scrollLoadmore = true;
            mediaProvider!.scrollOffset = mediaProvider!.scrollOffset + perPage;
            update();
          } else {
            mediaProvider!.scrollLoadmore = false;
            update();
          }
        } else {
          mediaProvider!.scrollLoadmore = false;
          update();
        }
        mediaProvider!.scrollLoadmore = false;
        update();
      } else {
        isNetworkAvail = false;
        mediaProvider!.scrollLoadmore = false;
        update();
      }
    } catch (e) {
      mediaProvider!.scrollLoadmore = false;
      setSnackbar(
        getTranslated(context, "somethingMSg")!,
        context,
      );
      update();
    }
  }

  Future<void> uploadMediaAPI(
    BuildContext context,
    Function update,
    String from,
  ) async {
    mediaProvider!.isImageUploading = true;
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", uploadMediaApi);
        request.headers.addAll(headers);
        // request.fields[SellerId] = context.read<SettingProvider>().CUR_USERID!;
        if (mediaProvider!.selectedImageFromGellery != null) {
          http.MultipartFile image;
          final mainImagepPath =
              lookupMimeType(mediaProvider!.selectedImageFromGellery.path);
          var extension = mainImagepPath!.split("/");
          image = await http.MultipartFile.fromPath(
            "documents[]",
            mediaProvider!.selectedImageFromGellery.path,
            contentType: MediaType(
              'image',
              extension[1],
            ),
          );
          request.files.add(image);
        }
        if (videoFromGellery != null) {
          final mainImagepPath = lookupMimeType(videoFromGellery!.path);

          var extension = mainImagepPath!.split("/");

          var video = await http.MultipartFile.fromPath(
            "documents[]",
            videoFromGellery!.path,
            contentType: MediaType(
              'video',
              extension[1],
            ),
          );
          request.files.add(video);
        }
        if (uploadedDocumentName != null) {
          final mainImagepPath = lookupMimeType(documentFromGellery!.path);

          var extension = mainImagepPath!.split("/");

          var video = await http.MultipartFile.fromPath(
            "documents[]",
            documentFromGellery!.path,
            contentType: MediaType(
              'application',
              extension[1],
            ),
          );
          request.files.add(video);
        }
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var getdata = json.decode(responseString);
        bool error = getdata["error"];
        String msg = getdata['message'];
        if (!error) {
          setSnackbar(
            msg,
            context,
          );
          mediaProvider!.scrollLoadmore = true;
          mediaProvider!.tempList.clear();
          mediaProvider!.mediaList.clear();
          Future.delayed(const Duration(seconds: 2), () {
            mediaProvider!.getMedia(update, context, from);
          });
          documentFromGellery = null;
          mediaProvider!.selectedImageFromGellery = null;
          mediaProvider!.isImageUploading = false;
          update();
        } else {
          mediaProvider!.isImageUploading = false;
          setSnackbar(
            msg,
            context,
          );
        }
      } on TimeoutException catch (_) {
        mediaProvider!.isImageUploading = false;
        setSnackbar(
          getTranslated(context, 'somethingMSg')!,
          context,
        );
      }
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          await mediaProvider!.buttonController!.reverse();
          isNetworkAvail = false;
          update();
        },
      );
    }
  }
}
