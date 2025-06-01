import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_5_c_travel/admin/customer/screens/customer_screen.dart';
import 'package:tubes_5_c_travel/home/screens/profile_screen.dart';
import 'package:tubes_5_c_travel/common/widgets/alert_dialog.dart';
import 'package:tubes_5_c_travel/common/widgets/input_form.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/User.dart';
import 'package:tubes_5_c_travel/common/models/UserClient.dart';

class EditProfileForm extends ConsumerStatefulWidget {
  const EditProfileForm({super.key});

  @override
  ConsumerState<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    notelpController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User user = await UserClient.getUserProfile();
      setState(() {
        usernameController.text = user.username!;
        emailController.text = user.email!;
        passwordController.text = '';
        notelpController.text = user.nomorTelp!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void update() async {
    bool confirmUpdate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TwoButtonAlertDialog(
          title: 'Konfirmasi Update',
          content: 'Apakah Anda yakin ingin update profile?',
          rightButtonText: 'Ya',
          leftButtonText: 'Tidak',
          onRightPressed: () => Navigator.of(context).pop(true),
          onLeftPressed: () => Navigator.of(context).pop(false),
        );
      },
    );

    User user = User(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      nomorTelp: notelpController.text,
    );

    if (confirmUpdate) {
        BuildContext? dialogContext;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            dialogContext = context;
            return Center(
                child: CircularProgressIndicator(
              color: themeColor,
            ));
          },
        );

      try {
        print("010101010101 -> $user");
        await UserClient.update(user);
        Navigator.pop(dialogContext!);
        Navigator.pop(context);

        ref.refresh(listUserProvider);
        ref.refresh(userProvider);
      } catch (err) {
        Navigator.pop(dialogContext!);
        print(err.toString());
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleButtonAlertDialog(
              title: 'Update Gagal',
              content: 'Terjadi kesalahan tak terduga. Silakan coba lagi.',
              buttonText: 'Mengerti',
              onPressed: () {
                Navigator.pop(context);
              },
            );
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
        width: MediaQuery.of(context).size.width * 0.91,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputForm(
                  (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Email Tidak Boleh Kosong';
                    }
                    if (!p0.contains('@')) {
                      return 'Email harus menggunakan @';
                    }
                    return null;
                  },
                  controller: emailController,
                  titleTxt: "Email",
                  hintTxt: "Email",
                ),
                InputForm(
                  (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Username Tidak Boleh Kosong';
                    }
                    return null;
                  },
                  controller: usernameController,
                  titleTxt: "Username",
                  hintTxt: "Username",
                ),
                InputForm(
                  (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Password Tidak Boleh Kosong';
                    }
                    if (p0.length < 5) {
                      return 'Password minimal 5 digit';
                    }
                    return null;
                  },
                  controller: passwordController,
                  titleTxt: "Password",
                  hintTxt: "Password",
                  password: true,
                ),
                InputForm(
                  (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Nomor Telepon Tidak Boleh Kosong';
                    }
                    return null;
                  },
                  controller: notelpController,
                  titleTxt: "No Telp",
                  hintTxt: "No Telp",
                  keyboardType: 'number',
                ),
              ],
            ),
            const SizedBox(
              height: 44.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Simpan',
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
