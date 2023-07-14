import 'package:appnote/core/route/routing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/dashboard',
      defaultTransition: Transition.native,
      getPages: routing.route,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: Colors.amber[300]),
      ),
    ),
  );
}
