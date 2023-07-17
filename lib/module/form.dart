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
    Get.back(result: false);
  }
}

class FormPage extends GetView<FormPageState> {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: WillPopScope(
        onWillPop: () => controller.back(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
    );
  }
}
