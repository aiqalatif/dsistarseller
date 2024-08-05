class MediaFile {
  final String? id;
  final String? messageId;
  final String? userId;
  final String? originalFileName;
  final String? fileName;
  final String? fileUrl;
  final String? fileExtension;
  final String? fileSize;
  final String? dateCreated;

  MediaFile({
    this.id,
    this.messageId,
    this.userId,
    this.originalFileName,
    this.fileName,
    this.fileUrl,
    this.fileExtension,
    this.fileSize,
    this.dateCreated,
  });

  MediaFile copyWith({
    String? id,
    String? messageId,
    String? userId,
    String? originalFileName,
    String? fileName,
    String? fileUrl,
    String? fileExtension,
    String? fileSize,
    String? dateCreated,
  }) {
    return MediaFile(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      originalFileName: originalFileName ?? this.originalFileName,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      fileExtension: fileExtension ?? this.fileExtension,
      fileSize: fileSize ?? this.fileSize,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  MediaFile.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        messageId = json['message_id'] as String?,
        userId = json['user_id'] as String?,
        originalFileName = json['original_file_name'] as String?,
        fileName = json['file_name'] as String?,
        fileUrl = json['file_url'] as String?,
        fileExtension = json['file_extension'] as String?,
        fileSize = json['file_size'] as String?,
        dateCreated = json['date_created'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'message_id': messageId,
        'user_id': userId,
        'original_file_name': originalFileName,
        'file_name': fileName,
        'file_url': fileUrl,
        'file_extension': fileExtension,
        'file_size': fileSize,
        'date_created': dateCreated
      };
}
