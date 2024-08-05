import 'package:flutter/material.dart';
import 'package:sellermultivendor/Screen/FAQ/faq.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/validation.dart';

class UploadFaQWidget extends StatelessWidget {
  final String id;
  final Function setStateNow;
  const UploadFaQWidget({
    Key? key,
    required this.id,
    required this.setStateNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 10,
        bottom: 10,
        start: 10,
        end: 10,
      ),
      child: Card(
        elevation: 10,
        child: InkWell(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onFieldSubmitted: (v) {
                    FocusScope.of(context)
                        .requestFocus(faqProvider!.tagsController);
                  },
                  controller: faqProvider!.mobilenumberController,
                  decoration: InputDecoration(
                    counterStyle: const TextStyle(color: white, fontSize: 0),
                    hintText: getTranslated(context, "Enter New Question")!,
                    icon: const Icon(Icons.live_help_outlined),
                    iconColor: primary,
                    labelStyle: const TextStyle(
                      color: black,
                      fontSize: 17.0,
                    ),
                    hintStyle: const TextStyle(
                      color: black,
                      fontSize: 17.0,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: TextInputType.text,
                  focusNode: faqProvider!.tagsController,
                  onSaved: (String? value) {
                    faqProvider!.tagvalue = value;
                  },
                  onChanged: (String? value) {
                    faqProvider!.tagvalue = value;
                  },
                  style: const TextStyle(
                    color: black,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(faqProvider!.ansFocus);
                  },
                  controller: faqProvider!.answerController,
                  decoration: InputDecoration(
                    counterStyle: const TextStyle(color: white, fontSize: 0),
                    hintText:
                        getTranslated(context, "Enter Your Answer (Optional)")!,
                    icon: const Icon(Icons.edit_note),
                    iconColor: primary,
                    labelStyle: const TextStyle(
                      color: black,
                      fontSize: 17.0,
                    ),
                    hintStyle: const TextStyle(
                      color: black,
                      fontSize: 17.0,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: TextInputType.text,
                  focusNode: faqProvider!.ansFocus,
                  onSaved: (String? value) {
                    faqProvider!.ansValue = value;
                  },
                  onChanged: (String? value) {
                    faqProvider!.ansValue = value;
                  },
                  style: const TextStyle(
                    color: black,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  faqProvider!.tagList.clear();
                  faqProvider!.scrollLoadmore = true;
                  if (faqProvider!.tagvalue != '' &&
                      faqProvider!.tagvalue != null) {
                    faqProvider!.addTagAPI(context, id, setStateNow);
                  } else {
                    setSnackbar(
                        getTranslated(context, "Please Add Questions Value")!,
                        context);
                  }
                  Future.delayed(const Duration(seconds: 2)).then(
                    (_) async {
                      faqProvider!.scrollLoadmore = true;
                      faqProvider!.scrollOffset = 0;
                      faqProvider!.getFaQs(
                        context,
                        setStateNow,
                        id,
                      );
                      setStateNow();
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(circularBorderRadius5),
                  ),
                  width: 120,
                  height: 40,
                  child: Center(
                    child: Text(
                      getTranslated(context, "Add Question")!,
                      style: const TextStyle(
                        color: white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
