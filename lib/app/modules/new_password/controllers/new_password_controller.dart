import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        try {
          String email = auth.currentUser!.email!;
          await auth.currentUser!.updatePassword(newPassC.text);
          await auth.signOut();
          auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text,
          );
          Get.offAllNamed(Routes.LOGIN);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Gagal", "Password terlalu lemah");
          }
        } catch (e) {
          Get.snackbar("Error", "Terjadi kesalahan");
        }
      } else {
        Get.snackbar("Error", "Password tidak boleh sama dengan password lama");
      }
    } else {
      Get.snackbar("Error", "Password tidak boleh kosong");
    }
  }
}
