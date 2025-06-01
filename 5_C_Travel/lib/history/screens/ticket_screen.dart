import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:share_plus/share_plus.dart';

import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/models/pemesanan.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

import 'package:tubes_5_c_travel/history/widgets/ticket_view.dart';

class TicketScreen extends StatefulWidget {
  final Pemesanan pemesanan;
  const TicketScreen({super.key, required this.pemesanan});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenshotController screenshotController = ScreenshotController();

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Ticket',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Screenshot(
                    controller: screenshotController,
                    child: TicketView(
                      pemesanan: widget.pemesanan,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final image =
                                      await screenshotController.capture();
                                  if (image != null) {
                                    final result =
                                        await ImageGallerySaverPlus.saveImage(
                                      image,
                                      name:
                                          'Ticket_${DateTime.now().millisecondsSinceEpoch}',
                                      isReturnImagePathOfIOS: true,
                                    );

                                    print(result);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                          "Tiket Berhasil Disimpan!",
                                          style: TextStyles.poppinsBold(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    print(
                                        "Error Download Button: Screenshot capture returned null.");
                                  }
                                } catch (error) {
                                  print(
                                      "Error capturing screenshot [Download Button]: $error");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                "Download Ticket",
                                style: TextStyles.poppinsBold(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                final image =
                                    await screenshotController.capture();
                                if (image != null) {
                                  final file = XFile.fromData(image,
                                      name: 'screenshot.png',
                                      mimeType: 'image/png');

                                  await Share.shareXFiles([file]);
                                } else {
                                  print(
                                      "Error Share Button: Screenshot capture returned null.");
                                }
                              } catch (error) {
                                print(
                                    "Error capturing screenshot [Share Button]: $error");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              shadowColor: Colors.grey.withOpacity(0.5),
                            ),
                            child: Icon(
                              Icons.share,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
