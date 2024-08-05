import '../../Widget/parameterString.dart';

class FaqsModel {
  String? id, question, answer, status, uname, ansBy;

  FaqsModel(
      {this.id,
      this.question,
      this.answer,
      this.status,
      this.uname,
      this.ansBy});

  factory FaqsModel.fromJson(Map<String, dynamic> json) {
    return FaqsModel(
        id: json[Id],
        question: json[QUESTION],
        answer: json[ANSWER],
        status: json[STATUS],
        uname: json[Username],
        ansBy: json["answered_by_name"]);
  }
}
