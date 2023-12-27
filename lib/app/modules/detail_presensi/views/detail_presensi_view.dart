import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;

  DetailPresensiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("DETAIL PRESENCE",
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
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DateFormat.yMMMMEEEEd()
                        .format(DateTime.parse(data['date'])),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Masuk",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    "Jam Masuk: ${DateFormat.jms().format(DateTime.parse(data["Masuk"]!["date"]))}"),
                Text(
                    "Posisi : ${data["Masuk"]!["lat"]}, ${data["Masuk"]!["long"]}"),
                Text("Status: ${data["Masuk"]!["status"]}"),
                Text(
                    "Distance: ${data["Masuk"]!["distance"].toString().split(".").first} meter"),
                Text("Address: ${data["Masuk"]!["address"]}"),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Keluar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(data["keluar"]?["date"] == null
                    ? "Jam Keluar : -"
                    : "Jam Keluar: ${DateFormat.jms().format(DateTime.parse(data["keluar"]!["date"]))}"),
                Text(data["keluar"]?["lat"] == null &&
                        data["keluar"]?["long"] == null
                    ? "Posisi : -"
                    : "Posisi : ${data["keluar"]!["lat"]}, ${data["keluar"]!["long"]}"),
                Text(data["keluar"]?["status"] == null
                    ? "Status : -"
                    : "Status: ${data["keluar"]!["status"]}"),
                Text(data["keluar"]?["distance"] == null
                    ? "Distance : - "
                    : "Distance: ${data["keluar"]!["distance"].toString().split(".").first} meter"),
                Text(data["keluar"]?["address"] == null
                    ? "Distance : - "
                    : "Address: ${data["keluar"]!["address"]}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
