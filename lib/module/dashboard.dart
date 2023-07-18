import 'dart:io';

import 'package:appnote/core/helper/database_helper.dart';
import 'package:appnote/core/helper/function_helper.dart';
import 'package:appnote/core/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardState extends GetxController {
  int count = 0;
  List myData = <Note>[].obs;
  RxBool formSearch = false.obs;
  RxBool loading = false.obs;
  TextEditingController inputSearch = TextEditingController();
  RxBool checklist = false.obs;
  List valueChecklist = <bool>[].obs;
  RxBool checklistAll = false.obs;

  @override
  onInit() {
    loadData();
    super.onInit();
  }

  loadData() async {
    loading.value = true;
    myData.clear();
    valueChecklist.clear();
    final result = await DatabaseHelper.getItems();
    for (var element in result) {
      var data = Note.fromJson(element);
      myData.add(data);
      valueChecklist.add(false);
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
      valueChecklist.clear();
      final result = await DatabaseHelper.getItemsWithSearch(title: value);
      for (var element in result) {
        var data = Note.fromJson(element);
        myData.add(data);
        valueChecklist.add(false);
      }
      loading.value = false;
    } else {
      loadData();
    }
  }

  deleteData() async {
    Get.back();
    for (var i = 0; i < valueChecklist.length; i++) {
      if (valueChecklist[i]) {
        await DatabaseHelper.deleteItem(id: myData[i].id);
      }
    }
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
    checklist.value = false;
    inputSearch.clear();
    loadData();
  }

  switchChecklistMode(index) {
    if (checklist.isTrue) {
      for (var i = 0; i < valueChecklist.length; i++) {
        valueChecklist[i] = false;
      }
      if (inputSearch.text.isNotEmpty) {
        formSearch.value = true;
      }
      checklist.value = false;
    } else {
      if (formSearch.isTrue) {
        formSearch.value = false;
      }
      valueChecklist[index] = true;
      checklist.value = true;
    }
  }

  checkList(index) {
    if (valueChecklist[index]) {
      valueChecklist[index] = false;
    } else {
      valueChecklist[index] = true;
    }
    checkCheckList();
  }

  checkCheckList() {
    int countAll = 0;
    for (var i = 0; i < valueChecklist.length; i++) {
      if (valueChecklist[i]) {
        countAll++;
      }
    }
    if (countAll == valueChecklist.length) {
      checklistAll.value = true;
    } else {
      checklistAll.value = false;
    }
  }

  checkListAll() {
    if (checklistAll.isFalse) {
      for (var i = 0; i < valueChecklist.length; i++) {
        valueChecklist[i] = true;
      }
      checklistAll.value = true;
    } else {
      for (var i = 0; i < valueChecklist.length; i++) {
        valueChecklist[i] = false;
      }
      checklistAll.value = false;
    }
  }

  dialogDelete() {
    int count = 0;
    for (var i = 0; i < valueChecklist.length; i++) {
      if (valueChecklist[i] == true) {
        count++;
      }
    }
    if (count == 0) {
      return Get.snackbar("Hapus", "Pilih catatan yang akan dihapus",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    Get.defaultDialog(
      barrierDismissible: false,
      title: "Hapus",
      titlePadding: const EdgeInsets.only(top: 16),
      titleStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      middleText: "Yakin hapus $count catatan ?",
      middleTextStyle: const TextStyle(
        color: Colors.red,
      ),
      textConfirm: "Iya",
      confirmTextColor: Colors.white,
      onConfirm: () => deleteData(),
      textCancel: "Batal",
      onCancel: () => Get.back(),
    );
  }

  back() {
    if (checklist.isTrue) {
      switchChecklistMode(0);
    } else {
      SystemNavigator.pop();
    }
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
                controller.formSearch.isTrue
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
                    : const Text("Catatan"),
                controller.myData.isEmpty
                    ? Container()
                    : InkWell(
                        onTap: () => controller.checklist.isTrue
                            ? controller.checkListAll()
                            : controller.switchSearchMode(),
                        child: Icon(controller.checklist.isTrue
                            ? Icons.checklist_rtl_rounded
                            : controller.formSearch.isTrue
                                ? Icons.close
                                : Icons.search),
                      )
              ],
            ),
          ),
          body: WillPopScope(
            onWillPop: () => controller.back(),
            child: controller.loading.isTrue
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
                            children: [
                              for (var i = 0; i < controller.myData.length; i++)
                                SizedBox(
                                  height: 100,
                                  child: InkWell(
                                    onTap: () => controller.checklist.isTrue
                                        ? controller.checkList(i)
                                        : Get.toNamed('/form', arguments: [
                                            "Ubah Catatan",
                                            controller.myData[i].id,
                                            controller.myData[i].title,
                                            controller.myData[i].description,
                                          ])?.then((value) => value
                                            ? controller.loadData()
                                            : null),
                                    onLongPress: () =>
                                        controller.switchChecklistMode(i),
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
                                                  controller.myData[i].title,
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
                                                  controller
                                                      .myData[i].description,
                                                  maxLines: 1,
                                                ),
                                                FutureBuilder(
                                                    future: functionHelper
                                                        .formatedDate(controller
                                                            .myData[i]
                                                            .createdAt),
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
                                            controller.checklist.isTrue
                                                ? Checkbox(
                                                    value: controller
                                                        .valueChecklist[i],
                                                    onChanged: (value) =>
                                                        controller.checkList(i),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
          ),
          floatingActionButton: FloatingActionButton(
              heroTag: "add",
              shape: const CircleBorder(),
              backgroundColor: controller.checklist.isTrue
                  ? const Color.fromARGB(255, 253, 90, 78)
                  : const Color.fromARGB(255, 114, 173, 46),
              child: Icon(
                controller.checklist.isTrue ? Icons.delete_rounded : Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                if (controller.checklist.isTrue) {
                  controller.dialogDelete();
                } else {
                  Get.toNamed('/form', arguments: ["Tulis Catatan"])
                      ?.then((value) => value ? controller.loadData() : null);
                }
              }),
        ));
  }
}
