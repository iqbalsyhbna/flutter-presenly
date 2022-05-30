import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: "password");

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            if (passwordC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: "Perhatian!",
              middleText:
                  "Kamu belum verifikiasi email ini, Silahkan verifikasi terlebih dahulu",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "CANCEL",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar("Berhasil",
                          "Email Verifikasi Berhasil di Kirim Ulang");
                    } catch (e) {
                      Get.snackbar("Terjadi Kesalahan",
                          "Tidak dapat mengirim email verifikasi");
                      Get.back();
                    }
                  },
                  child: Text(
                    "KIRIM ULANG",
                  ),
                ),
              ],
            );
          }
          print(userCredential);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan", "email sudah ada");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "password yang dimasukkan salah");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat Login");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password harus diisi");
    }
  }
}
