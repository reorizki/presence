import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({super.key});
  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.namaC.text = user['nama'];
    controller.nimC.text = user['nim'];
    controller.emailC.text = user['email'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:
            const Text("UPDATE PROFILE", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20.0),
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TextFormField(
            controller: controller.namaC,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              hintText: 'Masukkan Nama Lengkap Anda',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: controller.nimC,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'NIP',
              hintText: 'Masukkan NIP Anda',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: controller.emailC,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Masukkan Emal Anda',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            "Photo Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(
                builder: (c) {
                  if (c.image != null) {
                    return ClipOval(
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Image.file(
                          File(c.image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    if (user['profile'] != null) {
                      return Column(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              height: 100.0,
                              width: 100.0,
                              child: Image.network(
                                user['profile'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                controller.deleteProfile(user['uid']);
                              },
                              child: const Text("Delete"))
                        ],
                      );
                    } else {
                      return const Text("profile kosong");
                    }
                  }
                },
              ),
              TextButton(
                  onPressed: () {
                    controller.pickImage();
                  },
                  child: const Text("Choosen Photo"))
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.updateProfile(user['uid']);
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? "Update Profile"
                  : "Loading..."),
            ),
          ),
        ],
      ),
    );
  }
}
