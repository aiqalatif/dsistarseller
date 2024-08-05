import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import '../Helper/Constant.dart';
import '../Model/SalesReportModel/SalesReportModel.dart';
import '../Repository/salesReportRepositry.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/snackbar.dart';

class SalesReportProvider extends ChangeNotifier {
  List<SalesReportModel> tranList = [];
  bool isLoading = true;
  String totalReports = "",
      totalDeliveryCharge = "",
      grandFinalTotal = "",
      grandTotal = "";
  bool isLoadingmore = true;
  int offset = 0;
  int total = 0;
  TextEditingController amountController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  String? amount, msg;
  ScrollController controller = ScrollController();
  TextEditingController? amtC, bankDetailC;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  List<SalesReportModel> tempList = [];
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? start, end;

  initializaedVariableWithDefualtValue() {
    tranList = [];
    isLoading = true;
    totalReports = "";
    totalDeliveryCharge = "";
    grandFinalTotal = "";
    grandTotal = "";
    amount = null;
    msg = null;
    tempList = [];
    isLoadingmore = true;
    offset = 0;
    total = 0;
  }

  Future<void> getSalesReportRequest(
    BuildContext context,
    Function update,
    bool fromdate,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      var parameter = {
        // SellerId: context.read<SettingProvider>().CUR_USERID,
        //    OFFSET: "0",
      };
      if (fromdate) {
        parameter['start_date'] = "${startDate.toLocal()}".split(' ')[0];
        parameter['end_date'] = "${endDate.toLocal()}".split(' ')[0];
      }
      var result = await SalesReportRepository.getSalesReportRequest(
        parameter: parameter,
      );

      bool error = result["error"];
      String msgtest = result["message"];
      if (!error) {
        totalReports = result["total"];
        totalDeliveryCharge = result["grand_total"];
        grandFinalTotal = result["total_delivery_charge"];
        grandTotal = result["grand_final_total"];
        total = int.parse(
          result["total"],
        );
        if ((offset) < total) {
          tempList.clear();
          var data = result["rows"];

          tempList = (data as List)
              .map((data) => SalesReportModel.fromJson(data))
              .toList();
          tranList.addAll(tempList);
          offset = offset + perPage;
        }
        isLoading = false;
        update();
      } else {
        setSnackbar(msgtest, context);
        isLoading = true;
        update();
      }
    } else {
      isNetworkAvail = false;
      update();
    }
    return;
  }
}
