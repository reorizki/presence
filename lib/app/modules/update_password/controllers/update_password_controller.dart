import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController newC = TextEditingController();
  TextEditingController currC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (currC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currC.text);

          await auth.currentUser!.updatePassword(newC.text);

          Get.back();

          Get.snackbar("Success", "Password Berhasil diupdate");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar("Error", "Curent Password Salah");
          } else {
            Get.snackbar("Error", e.code.toLowerCase());
          }
        } catch (e) {
          Get.snackbar("Error", "Tidak Dapat Mengupdate Password");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
            "Error", "Confirm Password tidak sama dengan New Password");
      }
    } else {
      Get.snackbar("Error", "Semua inputan Harus diisi");
    }
  }
}
