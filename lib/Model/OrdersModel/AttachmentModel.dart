import 'package:sellermultivendor/Widget/parameterString.dart';

class Attachment {
  String? id, attachment;

  Attachment({
    this.id,
    this.attachment,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json[Id],
      attachment: json[ATTACHMENT],
    );
  }
}
