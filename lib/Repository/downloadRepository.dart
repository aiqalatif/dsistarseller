import 'package:dio/dio.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';

class DownloadRepository {
  Future<void> downloadFile(
      {required String url,
      required String savePath,
      required CancelToken cancelToken,
      required Function updateDownloadedPercentage}) async {
    try {
      await ApiBaseHelper().downloadFile(
          cancelToken: cancelToken,
          url: url,
          savePath: savePath,
          updateDownloadedPercentage: updateDownloadedPercentage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
