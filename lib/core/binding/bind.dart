import 'package:get/get.dart';

import '../../module/dashboard.dart';
import '../../module/form.dart';

class Bind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardState>(() => DashboardState());
    Get.lazyPut<FormPageState>(() => FormPageState());
  }
}
