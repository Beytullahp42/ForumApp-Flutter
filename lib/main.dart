import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:forum_app_ui/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forum_app_ui/components/responsive_wrapper.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
      themeMode: ThemeMode.light,
      builder: (context, child) => ResponsiveWrapper(child: child!),
    );
  }
}

Future<void> checkConnection(BuildContext context) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  final noConnection =
      connectivityResult[0] ==
      ConnectivityResult.none; //no connection bağlantı yok

  if (!context.mounted) return;

  if (noConnection) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.noConnectionPage,
      (route) => false,
    );
  }
}
