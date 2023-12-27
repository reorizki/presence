import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    pageIndex.value = i;
    switch (i) {
      case 0:
        Get.offAllNamed(Routes.HOME);
        break;
      case 1:
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse["eror"] != true) {
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address =
              "${placemarks[1].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";

          await updatePosition(position, address);

          //Cek Distatance between 2 position
          double distance = Geolocator.distanceBetween(3.689941880105543,
              98.64595571083261, position.latitude, position.longitude);

          //presensi
          await presensi(position, address, distance);
        } else {
          Get.snackbar("Error", dataResponse["message"]);
        }
        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colPresence =
        firestore.collection("mahasiswa").doc(uid).collection("presence");
    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime now = DateTime.now();
    String date = DateFormat("dd-MM-yyyy").format(now);

    String status = "Di Luar Area Jangkauan";

    if (distance <= 100) {
      //didalam area
      status = "Di dalam Area Jangkauan";
      if (snapPresence.docs.isEmpty) {
        // belum pernah absen & set absen masuk
        Get.defaultDialog(
            title: "Absen Masuk",
            content: const Column(
              children: [
                Text("Kamu Akan Melakukan Absen Masuk"),
                SizedBox(
                  height: 10,
                ),
                Text("Apakah Kamu Yakin ?"),
              ],
            ),
            textConfirm: "Yakin",
            textCancel: "Batal",
            onConfirm: () async {
              Get.back();
              Get.snackbar("berhasil", "Kamu Telah Berhasil Absen");
              await colPresence.doc(date).set({
                "date": now.toIso8601String(),
                "Masuk": {
                  "date": now.toIso8601String(),
                  "lat": position.latitude,
                  "long": position.longitude,
                  "address": address,
                  "status": status,
                  "distance": distance,
                }
              });
            },
            onCancel: () {
              Get.back();
            });
      } else {
        // sudah Pernah Absen -> cek uda absen atau belum hari ini
        DocumentSnapshot<Map<String, dynamic>> todayDoc =
            await colPresence.doc(date).get();
        if (todayDoc.exists == true) {
          //Tanggal absen hari ini sudah ada
          Map<String, dynamic>? dataPresenceToday = todayDoc.data();
          if (dataPresenceToday?["keluar"] != null) {
            //Sudah Absen masuk dan keluar
            Get.snackbar(
                "Berhasil", "Kamu telah Absen Masuk Dan Keluar Hari Ini");
          } else {
            //Absen Keluar
            Get.defaultDialog(
                title: "Absen Keluar",
                content: const Column(
                  children: [
                    Text("Kamu Akan Melakukan Absen keluar"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Apakah Kamu Yakin ?"),
                  ],
                ),
                textConfirm: "Yakin",
                textCancel: "Batal",
                onConfirm: () async {
                  Get.back();
                  Get.snackbar("Berhasil", "Kamu telah Absen Keluar Hari Ini");
                  await colPresence.doc(date).update({
                    "date": now.toIso8601String(),
                    "keluar": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  });
                },
                onCancel: () {
                  Get.back();
                });
          }
        } else {
          //absen masuk
          Get.defaultDialog(
              title: "Absen Masuk",
              content: const Column(
                children: [
                  Text("Kamu Akan Melakukan Absen Masuk"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Apakah Kamu Yakin ?"),
                ],
              ),
              textConfirm: "Yakin",
              textCancel: "Batal",
              onConfirm: () async {
                Get.back();
                Get.snackbar("berhasil", "Kamu Telah Berhasil Absen");
                await colPresence.doc(date).set({
                  "date": now.toIso8601String(),
                  "Masuk": {
                    "date": now.toIso8601String(),
                    "lat": position.latitude,
                    "long": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                  }
                });
              },
              onCancel: () {
                Get.back();
              });
        }
      }
    } else {
      Get.snackbar("Dilarang", "Anda Diluar Area Kantor");
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;
    firestore.collection("mahasiswa").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    }).then((value) {
      print("Success");
    }).catchError((e) {
      print("Error");
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // return Future.error('Location services are disabled.');
      return {
        "message":
            "Layanan Lokasi Tidak Aktif, Ubah Pada Settingan Handphone Terlebih Dahulu",
        "eror": false
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "message":
              "Izin Lokasi Tidak Diizinkan, Ubah Pada Settingan Handphone Terlebih Dahulu",
          "eror": false
        };
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        "message":
            "Settingan Handphone Tidak Menginjinkan untuk Mengakses Lokasi, UBah Pada Settingan handphone terleih dahulu",
        "eror": false
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return {"position": position, "message": "success", "eror": false};
  }
}
