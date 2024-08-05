import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Constant.dart';
import '../../Provider/settingProvider.dart';
import '../../Provider/walletProvider.dart';
import '../../Widget/ProductDescription.dart';
import '../../Widget/api.dart';
import '../../Widget/appBar.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/snackbar.dart';
import '../MediaUpload/Media.dart';

class SendMail extends StatefulWidget {
  final String email, orderId, orderIteamId, productName, userName;
  const SendMail({
    Key? key,
    required this.email,
    required this.orderId,
    required this.orderIteamId,
    required this.productName,
    required this.userName,
  }) : super(key: key);

  @override
  _SendMailState createState() => _SendMailState();
}

String selectedUploadFileSubDic = '';

class _SendMailState extends State<SendMail> with TickerProviderStateMixin {
  ScrollController controller = ScrollController();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  String? message;
  bool sending = true;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
        context.read<WalletTransactionProvider>().getUserTransaction(context));
    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    selectedUploadFileSubDic = '';
    emailController.text = widget.email;
    subjectController.text =
        "Attachment for Download Product : ${widget.productName}";
    message =
        '''Hello Dear, You have purchase our digital product and we are happy to share the product with you, you can get product with this mail attachment. Thank You ...!''';
  }

  @override
  Widget build(BuildContext context) {
    print("order iteam id : ${widget.orderIteamId}");
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightWhite,
      body: isNetworkAvail
          ? Stack(
              children: [
                !sending
                    ? const Center(child: CircularProgressIndicator())
                    : Container(),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GradientAppBar(
                        "Send Email",
                      ),
                      const Padding(
                        padding: EdgeInsets.all(
                          8.0,
                        ),
                        child: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextField(
                            controller: emailController,
                            style: Theme.of(context).textTheme.titleSmall,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: primary.withOpacity(0.1),
                              hintText: 'Enter Email Id',
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(
                          8.0,
                        ),
                        child: Text(
                          "Subject",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextField(
                            controller: subjectController,
                            style: Theme.of(context).textTheme.titleSmall,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: primary.withOpacity(0.1),
                              hintText: 'Enter Email Id',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(
                                8.0,
                              ),
                              child: Text(
                                "Message",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute<String>(
                                      builder: (context) =>
                                          ProductDescription("", "Message"),
                                    ),
                                  ).then((changed) {
                                    message = changed;
                                    setState(() {});
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        circularBorderRadius5),
                                    color: primary,
                                  ),
                                  height: 35,
                                  child: const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 08),
                                      child: Text(
                                        "Edit Message",
                                        style: TextStyle(
                                          fontSize: textFontSize16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      message == null || message == ''
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      circularBorderRadius5),
                                  border: Border.all(
                                    color: primary,
                                  ),
                                ),
                                width: width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: HtmlWidget(
                                    message ?? '',
                                    onErrorBuilder: (context, element, error) =>
                                        Text('$element error: $error'),
                                    onLoadingBuilder:
                                        (context, element, loadingProgress) =>
                                            const CircularProgressIndicator(),
                                    onTapUrl: (url) {
                                      launchUrl(
                                        Uri.parse(url),
                                      );
                                      return true;
                                    },
                                    renderMode: RenderMode.column,
                                    textStyle: const TextStyle(
                                        fontSize: textFontSize14),
                                  ),
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(
                                8.0,
                              ),
                              child: Text(
                                "File",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => const Media(
                                        from: "archive,document",
                                        pos: 0,
                                        type: "email",
                                      ),
                                    ),
                                  ).then(
                                    (value) => setState(() {
                                      //
                                    }),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        circularBorderRadius5),
                                    color: primary,
                                  ),
                                  height: 35,
                                  child: const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 08),
                                      child: Text(
                                        "Upload",
                                        style: TextStyle(
                                          fontSize: textFontSize16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      selectedUploadFileSubDic == ''
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.upload_file,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, top: 8.0),
                                    child: Text(selectedUploadFileSubDic),
                                  ),
                                ],
                              ),
                            ),
                      InkWell(
                        onTap: () {
                          if (sending) {
                            setState(() {
                              sending = false;
                            });
                            getDeliveryBoy();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius5),
                              color: primary,
                            ),
                            height: 35,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 08),
                                child: Text(
                                  "Send Mail",
                                  style: TextStyle(
                                    fontSize: textFontSize16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  Future<void> getDeliveryBoy() async {
    var parameter = {
      'order_id': widget.orderId,
      'order_item_id': widget.orderIteamId,
      'customer_email': emailController.text,
      'subject': subjectController.text,
      'message': message,
      'attachment': selectedUploadFileSubDic,
      'username': widget.userName,
    };

    ApiBaseHelper().postAPICall(sendDigitalProductMailApi, parameter).then(
      (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          setSnackbar(
            msg!,
            context,
          );
        } else {
          setSnackbar(
            msg!,
            context,
          );
        }
        setState(() {
          sending = true;
        });
      },
      onError: (error) {
        setSnackbar(
          error.toString(),
          context,
        );
      },
    );
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Future.delayed(Duration.zero).then((value) => context
              .read<WalletTransactionProvider>()
              .getUserTransaction(context));
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }
}
