import 'package:flutter/material.dart';

import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

import 'package:tubes_5_c_travel/authentication/screens/login_screen.dart';
import 'package:tubes_5_c_travel/authentication/widgets/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              color: themeColor,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.76,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        'Register',
                        style: TextStyles.poppinsBold(
                            fontSize: 32, color: themeColor),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      const RegisterForm(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Already have an account?',
                          style: TextStyles.poppinsBold(
                              fontSize: 11, color: themeColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
