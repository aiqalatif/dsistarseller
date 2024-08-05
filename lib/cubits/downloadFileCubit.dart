import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Repository/downloadRepository.dart';

abstract class DownloadFileState {}

class DownloadFileInitial extends DownloadFileState {}

class DownloadFileInProgress extends DownloadFileState {
  final double downloadPercentage;

  DownloadFileInProgress(this.downloadPercentage);
}

class DownloadFileSuccess extends DownloadFileState {
  final String downloadedFileUrl;
  DownloadFileSuccess(this.downloadedFileUrl);
}

class DownloadFileProcessCanceled extends DownloadFileState {}

class DownloadFileFailure extends DownloadFileState {
  final String errorMessage;

  DownloadFileFailure(this.errorMessage);
}

class DownloadFileCubit extends Cubit<DownloadFileState> {
  final DownloadRepository _downloadRepository;
  DownloadFileCubit(this._downloadRepository) : super(DownloadFileInitial());

  final CancelToken _cancelToken = CancelToken();

  void _downloadedFilePercentage(double percentage) {
    emit(DownloadFileInProgress(percentage));
  }

  Future<void> writeFileFromTempStorage(
      {required String sourcePath, required String destinationPath}) async {
    final tempFile = File(sourcePath);
    final byteData = await tempFile.readAsBytes();
    final downloadedFile = File(destinationPath);
    //write into downloaded file
    await downloadedFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  void downloadFile(
      {required String fileUrl,
      required String fileName,
      required String fileExtension,
      required bool storeInExternalStorage}) async {
    emit(DownloadFileInProgress(0.0));
    try {
      //if wants to download the file then
      if (storeInExternalStorage) {
        //if user has given permission to download and view file
        if (await hasStoragePermissionGiven()) {
          //storing the fie temp
          final tempPath = await getTempStoragePath();
          final tempFileSavePath = '$tempPath/$fileName.$fileExtension';

          await _downloadRepository.downloadFile(
              cancelToken: _cancelToken,
              savePath: tempFileSavePath,
              updateDownloadedPercentage: _downloadedFilePercentage,
              url: fileUrl);

          //download file
          String downloadFilePath = await getExternalStoragePath();

          downloadFilePath = '$downloadFilePath/$fileName.$fileExtension';

          await writeFileFromTempStorage(
              sourcePath: tempFileSavePath, destinationPath: downloadFilePath);

          emit(DownloadFileSuccess(downloadFilePath));
        } else {
          //if user does not give permission to store files in download directory
          emit(DownloadFileFailure('Please give storage permission'));
        }
      } else {
        //download file for just to see
        final tempPath = await getTempStoragePath();
        final savePath = '$tempPath/$fileName.$fileExtension';

        await _downloadRepository.downloadFile(
            cancelToken: _cancelToken,
            savePath: savePath,
            updateDownloadedPercentage: _downloadedFilePercentage,
            url: fileUrl);

        emit(DownloadFileSuccess(savePath));
      }
    } catch (e) {
      if (_cancelToken.isCancelled) {
        emit(DownloadFileProcessCanceled());
      } else {
        emit(DownloadFileFailure(e.toString()));
      }
    }
  }

  void cancelDownloadProcess() {
    _cancelToken.cancel();
  }
}
