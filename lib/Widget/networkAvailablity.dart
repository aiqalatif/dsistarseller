//------------------------------------------------------------------------------
//============ connectivity_plus for checking internet connectivity ============

import 'package:connectivity_plus/connectivity_plus.dart';

bool isNetworkAvail = true;

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || 
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
