import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        isLoading.value = true;
        UserCredential credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        print(credential);

        if (credential.user != null) {
          isLoading.value = true;
          if (credential.user!.emailVerified == true) {
            isLoading.value = true;
            if (passC.text == "password") {
              isLoading.value = true;
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              isLoading.value = true;
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: "Belum Verifikasi Email",
              middleText: "Silahkan verifikasi email anda terlebih dahulu",
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await credential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar("Berhasil", "Email verifikasi terkirim");
                    } catch (e) {
                      Get.snackbar("Terjadi Eror",
                          "Tidak Dapat mengirim email, Silahkah hubungi admin");
                    }
                  },
                  child: const Text("Kirim Ulang Email Verifikasi"),
                ),
              ],
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar("Gagal", "Email Tidak Terdarftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Gagal", "Password salah");
        }
      } catch (e) {
        Get.snackbar(
            "Terjadi Eror", "Tidak Dapat Login, Silahkah hubungi admin");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Gagal", "Email atau Password wajib di isi");
    }
  }
}
