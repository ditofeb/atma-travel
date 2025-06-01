import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tubes_5_c_travel/admin/customer/screens/customer_screen.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/models/UserClient.dart';
import 'package:tubes_5_c_travel/common/widgets/alert_dialog.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/home/screens/profile_screen.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  Future<void>? _initializeCameraFuture;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeCameraFuture = _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_initializeCameraFuture == null || _cameraController == null) {
    if (_initializeCameraFuture == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    print(screenWidth);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: CustomAppBar(
            title: 'Take Photo',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                FutureBuilder<void>(
                  future: _initializeCameraFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_cameraController);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _initializeCameraFuture;

                      final image = await _cameraController.takePicture();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            debugPrint(image.path);
                            return DisplayPictureScreen(
                              imageFile: image,
                            );
                          },
                        ),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Color.fromRGBO(217, 217, 217, 1.0),
                    padding: EdgeInsets.all(screenWidth * 0.048),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                    size: screenWidth * 0.095,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: const SizedBox(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends ConsumerWidget {
  final XFile imageFile;

  const DisplayPictureScreen({super.key, required this.imageFile});

  void onSubmit(BuildContext context, WidgetRef ref) async {
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
      await UserClient.updateProfilePicture(File(imageFile.path));
      Navigator.pop(dialogContext!);
      Navigator.pop(context);
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
            title: 'Update Profile Picture Gagal',
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: CustomAppBar(
            title: 'Take Photo',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 5.0,
                ),
                Image.file(
                  File(imageFile.path),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                      color: themeColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            onSubmit(context, ref);
                          },
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
