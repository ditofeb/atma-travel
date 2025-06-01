import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/admin/jadwal/widgets/form_input_jadwal.dart';

class InputJadwalScreen extends StatefulWidget {
  const InputJadwalScreen({super.key});

  @override
  _InputJadwalScreenState createState() => _InputJadwalScreenState();
}

class _InputJadwalScreenState extends State<InputJadwalScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Tambah Jadwal',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: InputJadwalForm(),
          ),
        ),
      ),
    );
  }
}
