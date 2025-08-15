import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_service_interface.dart';

class NetworkService implements INetworkService {
  @override
  Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();

    final hasConnection = results.any(
      (r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn,
    );

    if (!hasConnection) return false;

    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}
