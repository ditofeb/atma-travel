import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';

import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/widgets/input_form.dart';

import 'package:tubes_5_c_travel/common/models/User.dart';
import 'package:tubes_5_c_travel/common/models/UserClient.dart';

import 'package:tubes_5_c_travel/authentication/screens/register_screen.dart';
import 'package:tubes_5_c_travel/history/screens/history_screen.dart';
import 'package:tubes_5_c_travel/home/screens/bottom_nav_home.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/screens/bottom_nav.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    User user = User(
      username: usernameController.text,
      password: passwordController.text,
    );

    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        text: 'Tunggu sebentar...',
      );

      //Fungsi memanggil api -> uncomment jika akan menggunakan database mysql
      await UserClient.login(user);
      Navigator.pop(context);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Berhasil Masuk',
        text: 'Selamat! Anda telah berhasil login.',
        confirmBtnText: 'Tutup',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BottomNavHomeScreen(),
            ),
          );
        },
      );
      ref.refresh(listPemesananProvider);
    } catch (err) {
      Navigator.pop(context);
      if (err.toString().contains('Username belum terdaftar') ||
          err.toString().contains('Invalid Credentials')) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Login Gagal',
          text: err.toString(),
          confirmBtnText: 'Mengerti',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Login Gagal',
          text: 'Terjadi kesalahan tak terduga. Silakan coba sesaat lagi.',
          confirmBtnText: 'Mengerti',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.788,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputForm(
              (p0) => p0 == null || p0.isEmpty
                  ? "Username tidak boleh kosong"
                  : null,
              controller: usernameController,
              titleTxt: "Username",
              hintTxt: "Username",
              iconData: Icons.person,
            ),
            InputForm(
              (p0) => p0 == null || p0.isEmpty ? "Password masih kosong" : null,
              password: true,
              controller: passwordController,
              titleTxt: "Password",
              hintTxt: "Password",
              iconData: Icons.password,
            ),
            const SizedBox(
              height: 150.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    if (_formKey.currentState!.validate()) {
                      if ("admin" == usernameController.text &&
                          "admin123" == passwordController.text) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomNavAdmin(),
                          ),
                        );
                      } else {
                        onSubmit();
                      }
                    }
                  } catch (e) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Login Gagal',
                      text:
                          'Terjadi kesalahan tak terduga. Silakan coba sesaat lagi.',
                      confirmBtnText: 'Mengerti',
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Login',
                  style:
                      TextStyles.poppinsBold(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }
}
