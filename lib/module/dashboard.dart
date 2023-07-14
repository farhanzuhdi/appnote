import 'package:appnote/core/helper/database_helper.dart';
import 'package:appnote/core/helper/function_helper.dart';
import 'package:appnote/core/models/note.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardState extends GetxController {
  int count = 0;
  final myData = <Note>[].obs;
  var searching = false.obs;
  var formSearch = false.obs;
  var loading = false.obs;
  TextEditingController inputSearch = TextEditingController();

  @override
  onInit() {
    loadData();
    super.onInit();
  }

  loadData() async {
    loading.value = true;
    myData.clear();
    final result = await DatabaseHelper.getItems();
    for (var element in result) {
      var data = Note.fromJson(element);
      myData.add(data);
    }
    if (myData.isNotEmpty) {
      searching = true.obs;
    } else {
      searching = false.obs;
    }
    loading.value = false;
  }

  switchSearchMode() {
    if (formSearch.isTrue) {
      formSearch.value = false;
      inputSearch.clear();
      loadData();
    } else {
      formSearch.value = true;
    }
  }

  searchData(value) async {
    if (value.length > 0) {
      loading.value = true;
      myData.clear();
      final result = await DatabaseHelper.getItemsWithSearch(title: value);
      for (var element in result) {
        var data = Note.fromJson(element);
        myData.add(data);
      }
      loading.value = false;
    } else {
      loadData();
    }
  }

  deleteData(id) async {
    Get.back();
    await DatabaseHelper.deleteItem(id: id);
    Get.defaultDialog(
      backgroundColor: Colors.red,
      title: "Berhasil",
      titlePadding: const EdgeInsets.only(top: 16),
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      middleText: "Catatan telah dihapus",
      middleTextStyle: const TextStyle(
        color: Colors.white,
      ),
    );
    loadData();
  }
}

class Dashboard extends GetView<DashboardState> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => controller.formSearch.isTrue
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: TextFormField(
                          controller: controller.inputSearch,
                          onChanged: controller.searchData,
                          decoration: const InputDecoration(
                              hintText: "Cari Judul", border: InputBorder.none),
                        ),
                      )
                    : const Text("Catatan")),
                controller.searching.isTrue
                    ? InkWell(
                        onTap: () => controller.switchSearchMode(),
                        child: Icon(controller.formSearch.isTrue
                            ? Icons.close
                            : Icons.search),
                      )
                    : Container()
              ],
            ),
          ),
          body: controller.loading.isTrue
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                                  height: 100,
                                  child: InkWell(
                                    onTap: () => Get.toNamed('/form',
                                        arguments: [
                                          "Ubah Catatan",
                                          i.id,
                                          i.title,
                                          i.description,
                                        ])?.then((value) =>
                                        value ? controller.loadData() : null),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 4, 8, 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  i.title,
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  i.description,
                                                  maxLines: 1,
                                                ),
                                                FutureBuilder(
                                                    future: functionHelper
                                                        .formatedDate(
                                                            i.createdAt),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<String>
                                                            snapshot) {
                                                      return Text(
                                                        "${snapshot.data}",
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      );
                                                    }),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () => Get.defaultDialog(
                                                barrierDismissible: false,
                                                title: "Hapus",
                                                titlePadding:
                                                    const EdgeInsets.only(
                                                        top: 16),
                                                titleStyle: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                                middleText:
                                                    "Yakin hapus catatan ?",
                                                middleTextStyle:
                                                    const TextStyle(
                                                  color: Colors.red,
                                                ),
                                                textConfirm: "Iya",
                                                confirmTextColor: Colors.white,
                                                onConfirm: () =>
                                                    controller.deleteData(i.id),
                                                textCancel: "Batal",
                                                onCancel: () => Get.back(),
                                              ),
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            )
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
          floatingActionButton: FloatingActionButton(
              heroTag: "add",
              child: const Icon(Icons.edit),
              onPressed: () {
                Get.toNamed('/form', arguments: ["Tulis Catatan"])
                    ?.then((value) => value ? controller.loadData() : null);
              }),
        ));
  }
}
