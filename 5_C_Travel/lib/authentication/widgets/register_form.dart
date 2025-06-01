import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tubes_5_c_travel/admin/customer/screens/customer_screen.dart';

import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/UserClient.dart';
import 'package:tubes_5_c_travel/common/widgets/input_form.dart';
import 'package:tubes_5_c_travel/common/models/User.dart';

import 'package:tubes_5_c_travel/authentication/screens/login_screen.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    notelpController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    User user = User(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      nomorTelp: notelpController.text,
    );

    try {
      //hardcode data sementara
      Map<String, dynamic> formData = {};
      formData['username'] = usernameController.text;
      formData['password'] = passwordController.text;
      formData['email'] = emailController.text;
      formData['notelp'] = notelpController.text;
      formData['image'] = 'assets/images/profile_pic.jpeg';

      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        text: 'Sedang memproses pendaftaran Anda...',
      );

      //Fungsi memanggil api -> uncomment jika akan menggunakan database mysql
      await UserClient.register(user);
      Navigator.pop(context);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Pendaftaran Sukses',
        text: 'Anda telah berhasil mendaftar! Silakan masuk untuk melanjutkan.',
        confirmBtnText: 'Tutup',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoginScreen(),
            ),
          );
        },
      );

      ref.refresh(listUserProvider);
    } catch (e) {
      Navigator.pop(context);
      if (e.toString().contains('Username') || e.toString().contains('Email')) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: e.toString(),
          confirmBtnText: 'Mengerti',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text:
              // 'Terjadi kesalahan tak terduga. Silakan coba sesaat lagi. ${err.toString()}',
              e.toString(),
          confirmBtnText: 'Mengerti',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.788,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputForm(
                  (p0) => p0 == null || p0.isEmpty
                      ? 'Username tidak boleh kosong'
                      : null,
                  controller: usernameController,
                  titleTxt: "Username",
                  hintTxt: "Username",
                  iconData: Icons.person,
                ),
                InputForm(
                  (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (p0.length < 5) return 'Password minimal 5 karakter';
                    return null;
                  },
                  controller: passwordController,
                  titleTxt: "Password",
                  hintTxt: "Password",
                  iconData: Icons.lock,
                  password: true,
                ),
                InputForm(
                  (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!p0.contains('@')) {
                      return 'Masukkan email yang valid (mis. user@gmail.com)';
                    }
                    return null;
                  },
                  controller: emailController,
                  titleTxt: "Email",
                  hintTxt: "Email",
                  iconData: Icons.email,
                ),
                InputForm(
                  (p0) => p0 == null || p0.isEmpty
                      ? 'Nomor Telepon tidak boleh kosong'
                      : null,
                  controller: notelpController,
                  titleTxt: "No Telp",
                  hintTxt: "No Telp",
                  keyboardType: 'number',
                  iconData: Icons.phone_android,
                ),
              ],
            ),
            const SizedBox(
              height: 32.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Register',
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
}
