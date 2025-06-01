import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/admin/driver/widgets/form_tambah_driver.dart';

class InputDriverScreen extends StatefulWidget {
  const InputDriverScreen({super.key});

  @override
  _InputDriverScreenState createState() => _InputDriverScreenState();
}

class _InputDriverScreenState extends State<InputDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Tambah Driver',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: InputDriverForm(),
          ),
        ),
      ),
    );
  }
}
