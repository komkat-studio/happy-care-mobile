import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:happy_care/core/utils/shared_pref.dart';
import 'package:happy_care/routes/app_pages.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  var isNotFirstTime = await SharedPrefUtils.getBoolKey("first_time") ?? true;
  var token = await SharedPrefUtils.getStringKey('token');
  runApp(MyApp(
    isNotFirstTime: isNotFirstTime,
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isNotFirstTime, this.token})
      : super(key: key);
  final bool isNotFirstTime;
  final String? token;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Happy Care",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: isNotFirstTime
          ? AppRoutes.rOnboarding
          : (token != null ? AppRoutes.rMain : AppRoutes.rSignIn),
      getPages: AppPages.routes,
    );
  }
}
