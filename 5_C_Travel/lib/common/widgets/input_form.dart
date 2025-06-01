import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

class InputForm extends StatefulWidget {
  final String titleTxt;
  final String? hintTxt;
  final TextEditingController controller;
  final bool password;
  final String keyboardType;
  final Function(String?) validasi;
  final IconData? iconData;

  const InputForm(
    this.validasi, {
    super.key,
    required this.titleTxt,
    this.hintTxt,
    required this.controller,
    this.password = false,
    this.keyboardType = 'text',
    this.iconData,
  });

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  bool _isObscured = true;

  OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: themeColor,
      width: 1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.titleTxt,
            style: TextStyles.poppinsBold(fontSize: 13, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 20),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => widget.validasi(value),
              controller: widget.controller,
              obscureText: widget.password ? _isObscured : false,
              keyboardType: widget.keyboardType == 'text'
                  ? TextInputType.text
                  : TextInputType.number,
              cursorColor: themeColor,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: widget.iconData != null
                    ? EdgeInsets.all(0)
                    : EdgeInsets.only(left: 15),
                hintText: widget.hintTxt,
                hintStyle: TextStyles.poppinsBold(
                  fontSize: 13,
                  color: const Color.fromARGB(76, 0, 0, 0),
                ),
                enabledBorder: outlineInputBorder,
                focusedBorder: outlineInputBorder,
                errorBorder: outlineInputBorder,
                focusedErrorBorder: outlineInputBorder,
                prefixIcon:
                    widget.iconData != null ? Icon(widget.iconData) : null,
                suffixIcon: widget.password
                    ? IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
