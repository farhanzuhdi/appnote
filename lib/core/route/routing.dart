import 'package:get/get.dart';

import '../../module/dashboard.dart';
import '../../module/form.dart';
import '../binding/bind.dart';

class Routing {
  List<GetPage> route = [
    GetPage(
      name: '/dashboard',
      page: () => const Dashboard(),
      binding: Bind(),
    ),
    GetPage(
      name: '/form',
      page: () => const FormPage(),
      binding: Bind(),
    )
  ];
}

var routing = Routing();
