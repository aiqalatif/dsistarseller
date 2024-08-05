import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import '../Helper/Color.dart';
import '../Helper/Constant.dart';
import '../Model/OrdersModel/OrderModel.dart';
import '../Repository/ordeListRepositry.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';

class OrderListProvider extends ChangeNotifier {
  String currentSelectedOrderType = '';
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  String searchText = "", lastsearch = "";
  int scrollOffset = 0;
  ScrollController? scrollController;
  bool scrollLoadmore = true, scrollGettingData = false, scrollNodata = false;
  final TextEditingController controller = TextEditingController();
  List<Order_Model> orderList = [];
  Icon iconSearch = const Icon(
    Icons.search,
    color: primary,
    size: 25,
  );
  Widget? appBarTitle;
  List<Order_Model> tempList = [];
  String? activeStatus;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? start, end;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? all,
      received,
      orderTrackingTotal,
      processed,
      shipped,
      delivered,
      cancelled,
      returned,
      awaiting;
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
  ];

  initializeAllVariable() {
    searchText = "";
    lastsearch = "";
    // isSearching = null;
    scrollOffset = 0;
    scrollLoadmore = true;
    scrollGettingData = false;
    scrollNodata = false;
    controller.clear();
    orderList = [];
    iconSearch = const Icon(
      Icons.search,
      color: primary,
      size: 25,
    );
    appBarTitle = null;
    tempList = [];
    activeStatus = null;
    startDate = DateTime.now();
    endDate = DateTime.now();
    start = null;
    end = null;
    all = null;
    received = null;
    orderTrackingTotal = null;
    processed = null;
    shipped = null;
    delivered = null;
    cancelled = null;
    returned = null;
    awaiting = null;
    statusList = [
      ALL,
      PLACED,
      PROCESSED,
      SHIPED,
      DELIVERD,
      CANCLED,
      RETURNED,
    ];
  }

  Future<void> getOrder(Function update, BuildContext context) async {
    //if (readOrder) {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (scrollLoadmore) {
        scrollLoadmore = false;
        scrollGettingData = true;
        if (scrollOffset == 0) {
          orderList = [];
        }
        update();
        /*  context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
        CUR_USERNAME = await getPrefrence(Username); */
        var parameter = {
          // SellerId: context.read<SettingProvider>().CUR_USERID,
          LIMIT: perPage.toString(),
          OFFSET: scrollOffset.toString(),
          SEARCH: searchText.trim(),
        };

        if (currentSelectedOrderType != '') {
          parameter["order_type"] = currentSelectedOrderType;
        }
        if (start != null) {
          parameter[START_DATE] = "${startDate.toLocal()}".split(' ')[0];
        }
        if (end != null) {
          parameter[END_DATE] = "${endDate.toLocal()}".split(' ')[0];
        }
        if (activeStatus != null) {
          if (activeStatus == awaitingPayment) activeStatus = "awaiting";
          parameter[ActiveStatus] = activeStatus!;
        }
        var result = await OrderListRepository.getOrders(parameter: parameter);
        bool error = result["error"];
        scrollGettingData = false;
        if (scrollOffset == 0) scrollNodata = error;
        if (!error) {
          all = result["total"];
          received = result["received"];
          processed = result["processed"];
          shipped = result["shipped"];
          delivered = result["delivered"];
          cancelled = result["cancelled"];
          returned = result["returned"];
          awaiting = result["awaiting"];
          tempList.clear();
          var data = result["data"];
          if (data.length != 0) {
            tempList = (data as List)
                .map((data) => Order_Model.fromJson(data))
                .toList();
            print("tempList order: " + tempList.length.toString());

            orderList.addAll(tempList);
            print("orderlist: " + orderList.length.toString());
            scrollLoadmore = true;
            scrollOffset = scrollOffset + perPage;
          } else {
            scrollLoadmore = false;
          }
        } else {
          scrollLoadmore = false;
        }
        scrollLoadmore = false;
        update();
      }
    } else {
      isNetworkAvail = false;
      scrollLoadmore = false;
      update();
    }
    return;
    /*  } else {
      setSnackbar(
        getTranslated(
            context, "You have not authorized permission for read order!!")!,
        context,
      );
    }*/
  }
}
