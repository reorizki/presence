import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("UPDATE PASSWORD",
            style: TextStyle(color: Colors.black)),
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
            controller: controller.currC,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Current Password',
              hintText: 'Enter your Current Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextFormField(
            controller: controller.newC,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              hintText: 'Enter your New Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextFormField(
            controller: controller.confirmC,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm New Password',
              hintText: 'Enter your Confirm New Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.updatePass();
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? "Update Password"
                  : "Loading..."),
            ),
          ),
        ],
      ),
    );
  }
}
