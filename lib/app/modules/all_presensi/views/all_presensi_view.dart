import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title:
              const Text("ALL PRESENCE", style: TextStyle(color: Colors.black)),
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
        body: GetBuilder<AllPresensiController>(
          builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: controller.getAllPresence(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.docs.isEmpty || snapshot.data == null) {
                  return const Center(
                    child: Text("Tidak Ada history presensi"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        snapshot.data!.docs[index].data();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Material(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(
                              Routes.DETAIL_PRESENSI,
                              arguments: data,
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Masuk",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMMMEd()
                                          .format(DateTime.parse(data["date"])),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(data["Masuk"]?["date"] == null
                                    ? "-"
                                    : DateFormat.jms().format(DateTime.parse(
                                        data["Masuk"]!["date"]))),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const Text(
                                  "Keluar",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(data["keluar"]?["date"] == null
                                    ? "-"
                                    : DateFormat.jms().format(DateTime.parse(
                                        data["keluar"]!["date"]))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(
              Dialog(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  height: 400,
                  child: SfDateRangePicker(
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1),
                    selectionMode: DateRangePickerSelectionMode.range,
                    showActionButtons: true,
                    onCancel: () => Get.back(),
                    onSubmit: (obj) {
                      if (obj != null) {
                        if ((obj as PickerDateRange).endDate != null) {
                          controller.pickDate((obj).startDate!, (obj).endDate!);
                        }
                      }
                    },
                  ),
                ),
              ),
            );
          },
          child: const Icon(Icons.format_list_bulleted),
        ));
  }
}
