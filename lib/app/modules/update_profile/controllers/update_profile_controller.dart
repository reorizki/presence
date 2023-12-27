import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController namaC = TextEditingController();
  TextEditingController nimC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);

    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nimC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "nama": namaC.text,
        };
        if (image != null) {
          isLoading.value = true;
          File file = File(image!.path);
          String ext = image!.name.split(".").last;

          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();

          data.addAll({"profile": urlImage});
        }
        await firestore.collection("mahasiswa").doc(uid).update(data);
        image = null;
        Get.back();
        Get.snackbar("Berhasil", "Berhasil Update Profile");
      } catch (e) {
        Get.snackbar("Eror", "Tidak Dapat Update Profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection("mahasiswa").doc(uid).update(
        {
          "profile": FieldValue.delete(),
        },
      );
      Get.back();
      Get.snackbar("Berhasil", "Berhasil Delete Profile Picture");
    } catch (e) {
      Get.snackbar("Eror", "Tidak Dapat Delete Profile Picture");
    } finally {
      isLoading.value = false;
    }
  }
}
