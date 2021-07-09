import 'dart:io';

import 'package:data_connection_checker_tv/data_connection_checker.dart';

///To check the internet connection and data connection
Future<bool> connected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    //the first [if] will check if the device is connected to wifi or mobile data
    //but it dosen't check if there is internet or not(i.e. you nay have connection but you cant browse any thing)
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //this will check the actual intenet connection
      if (await DataConnectionChecker().hasConnection) {
        // 'connected';
        return true;
      } else {
        return false;
      }
    }
  } catch (_) {
    // 'not connected';
    return false;
  }
  return false;
}
