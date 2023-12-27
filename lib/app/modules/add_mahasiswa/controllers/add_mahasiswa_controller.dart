import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMahasiswaController extends GetxController {
  TextEditingController namaC = TextEditingController();
  TextEditingController nimC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddMahasiswa() async {
    if (passAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

        final credentialAdmin = await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );

        final credential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (credential.user != null) {
          String uid = credential.user!.uid;

          await firestore.collection("mahasiswa").doc(uid).set({
            "nama": namaC.text,
            "nim": nimC.text,
            "email": emailC.text,
            "job": jobC.text,
            "uid": uid,
            "role": "Pegawai",
            "createdAt": DateTime.now().toIso8601String(),
          });

          await credential.user!.sendEmailVerification();

          await auth.signOut();

          final credentialAdmin = await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back(); //TUtup Dialog
          Get.back(); //TUtup to Home
          Get.snackbar("Succes", "Berhasil Menambahkan Mahasiswa");
        }

        print(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("Error", "Password Terlalu Lemah");
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Error", "Email sudah digunakan");
          print('The account already exists for that email.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Eror", "Password Admin Salah");
        } else {
          Get.snackbar("Error", "${e.code}})");
        }
      } catch (e) {
        Get.snackbar("Error", "Silahkan Isi Semua Data");
      }
    } else {
      Get.snackbar("Error", "Password Admin Kosong");
    }
  }

  void addMahasiswa() async {
    if (namaC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        nimC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
        title: "Validasi Admin!!",
        content: Column(
          children: [
            const Text("Masukkan Password Untuk Validasi"),
            TextField(
              controller: passAdminC,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await prosesAddMahasiswa();
            },
            child: const Text("Add Pegawai"),
          ),
        ],
      );
    } else {
      Get.snackbar("Error", "Silahkan Isi Semua Data");
    }
  }
}
