import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/admin/kendaraan/widgets/form_tambah_kendaraan.dart';

class InputKendaraanScreen extends StatefulWidget {
  const InputKendaraanScreen({super.key});

  @override
  _InputKendaraanScreenState createState() => _InputKendaraanScreenState();
}

class _InputKendaraanScreenState extends State<InputKendaraanScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Tambah Kendaraan',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: InputKendaraanForm(),
          ),
        ),
      ),
    );
  }
}
