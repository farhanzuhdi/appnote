import 'package:appnote/core/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormPageState extends GetxController {
  final data = Get.arguments;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  int id = 0;

  @override
  void onInit() {
    if (data.length > 1) {
      id = data[1];
      title.text = data[2];
      description.text = data[3];
    }
    super.onInit();
  }

  addNote() async {
    if (id == 0) {
      if (description.text.isEmpty) {
        return Get.defaultDialog(
          backgroundColor: const Color.fromARGB(255, 224, 174, 6),
          title: "Tidak ada catatan",
          titlePadding: const EdgeInsets.only(top: 16),
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          middleText: "Tulis catatan dulu",
          middleTextStyle: const TextStyle(
            color: Colors.white,
          ),
        );
      }
      if (title.text.isEmpty) {
        title.text = description.text.split(" ")[0];
      }
      await DatabaseHelper.createItem(
        title: title.text,
        description: description.text,
      );
      Get.back(result: true);
      Get.defaultDialog(
        backgroundColor: const Color.fromARGB(255, 114, 173, 46),
        title: "Berhasil",
        titlePadding: const EdgeInsets.only(top: 16),
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        middleText: "Catatan baru disimpan",
        middleTextStyle: const TextStyle(
          color: Colors.white,
        ),
      );
    } else {
      if (title.text == data[2] && description.text == data[3]) {
        return Get.defaultDialog(
          backgroundColor: const Color.fromARGB(255, 224, 174, 6),
          title: "Ubah catatan",
          titlePadding: const EdgeInsets.only(top: 16),
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          middleText: "Tidak ada perubahan",
          middleTextStyle: const TextStyle(
            color: Colors.white,
          ),
        );
      }
      await DatabaseHelper.updateItem(
        id: id,
        title: title.text,
        description: description.text,
      );
      Get.back(result: true);
      Get.defaultDialog(
        backgroundColor: const Color.fromARGB(255, 224, 174, 6),
        title: "Berhasil",
        titlePadding: const EdgeInsets.only(top: 16),
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        middleText: "Perubahan telah tersimpan",
        middleTextStyle: const TextStyle(
          color: Colors.white,
        ),
      );
    }
  }

  back() {
    if (data.length > 1) {
      if (data[2] != title.text || data[3] != description.text) {
        Get.defaultDialog(
          title: "Batal ubah",
          middleText: "Yakin buang perubahan ?",
          textCancel: "Batal",
          onConfirm: () {
            Get.back();
            FocusManager.instance.primaryFocus?.unfocus();
            Get.back(result: false);
          },
          textConfirm: "Iya",
        );
      }
    } else {
      Get.back(result: false);
    }
  }
}

class FormPage extends GetView<FormPageState> {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => controller.back(),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.data[0]),
            InkWell(
              onTap: () => controller.addNote(),
              child: const Icon(Icons.save_rounded),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: () => controller.back(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: TextFormField(
                    controller: controller.title,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Judul",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller.description,
                    minLines: 8,
                    maxLines: 40,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Catatan",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
