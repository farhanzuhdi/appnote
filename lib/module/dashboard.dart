import 'package:appnote/core/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardState extends GetxController {
  int count = 0;
  final myData = [].obs;

  @override
  onInit() {
    loadData();
    super.onInit();
  }

  loadData() async {
    myData.clear();
    final data = await DatabaseHelper.getItems();
    myData.addAll(data);
  }
}

class Dashboard extends GetView<DashboardState> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catatan"),
      ),
      body: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: controller.myData.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada Catatan",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView(
                  children: controller.myData
                      .map(
                        (i) => SizedBox(
                          height: 90,
                          child: InkWell(
                            onTap: () => Get.toNamed('/form', arguments: [
                              "Ubah Catatan",
                              i['id'],
                              i['title'],
                              i['description'],
                            ])?.then((value) =>
                                value ? controller.loadData() : null),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      i['title'],
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      i['description'],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: "add",
          child: const Icon(Icons.edit),
          onPressed: () {
            Get.toNamed('/form', arguments: ["Tulis Catatan"])
                ?.then((value) => value ? controller.loadData() : null);
          }),
    );
  }
}
