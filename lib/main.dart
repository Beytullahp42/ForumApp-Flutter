import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:forum_app_ui/routes.dart';

void main() {
  runApp(const MyApp());
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      navigatorObservers: [routeObserver],
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
    );
  }
}

Future<void> checkConnection(BuildContext context) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  final noConnection =
      connectivityResult[0] ==
      ConnectivityResult.none; //no connection bağlantı yok

  if (noConnection) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.noConnectionPage,
      (route) => false,
    );
  }
}
