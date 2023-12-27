import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_mahasiswa_controller.dart';

class AddMahasiswaView extends GetView<AddMahasiswaController> {
  const AddMahasiswaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("ADD PEGAWAI", style: TextStyle(color: Colors.black)),
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
              hintText: 'Masukkan Nama Lengkap',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: controller.nimC,
            decoration: const InputDecoration(
              labelText: 'NIP',
              hintText: 'Masukkan NIP Pegawai',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Masukkan Email Pegawai',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: controller.jobC,
            decoration: const InputDecoration(
              labelText: 'Job',
              hintText: 'Masukkan Job Pegawai',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: () => controller.addMahasiswa(),
            child: const Text("Add Pegawai"),
          ),
        ],
      ),
    );
  }
}
