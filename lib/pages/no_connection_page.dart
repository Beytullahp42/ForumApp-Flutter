import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage({super.key});

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {


  Future<void> _checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    final noConnection = connectivityResult[0] == ConnectivityResult.none;

    if (!noConnection) { // bağlantı varsa
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    } else { // bağlantı yoksa
      Fluttertoast.showToast(msg: "Still no connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off, // Icon for no connection
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Connection\nTry again',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkConnection,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
