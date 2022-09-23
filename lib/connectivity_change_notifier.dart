import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityChangeNotifier extends ChangeNotifier {
  ConnectivityChangeNotifier() {
    //runs when connectivity changed
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      //call function for handling result
      resultHandler(result);
    });
  }
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool _isconnected = true;

//get methods
  //ConnectivityResult get connectivity => _connectivityResult;
  bool get connection_status => _isconnected;

  void initialLoad() async {
    //runs at start to to get primary connection status when starting the app
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    resultHandler(connectivityResult);
  }

//result handler function
  void resultHandler(ConnectivityResult result) {
    _connectivityResult = result;
    if (result == ConnectivityResult.none) {
      _isconnected = false;
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      _isconnected = true;
    }
    notifyListeners();
  }
}
