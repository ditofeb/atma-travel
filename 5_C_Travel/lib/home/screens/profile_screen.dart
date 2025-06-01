import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tubes_5_c_travel/admin/customer/screens/customer_screen.dart';
import 'package:tubes_5_c_travel/authentication/screens/login_screen.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/models/User.dart';
import 'package:tubes_5_c_travel/common/models/UserClient.dart';
import 'package:tubes_5_c_travel/common/widgets/alert_dialog.dart';
import 'package:tubes_5_c_travel/profile/screens/edit_profile_screen.dart';

final userProvider = FutureProvider<User>((ref) async {
  return await UserClient.getUserProfile();
});

class ProfileScreen extends ConsumerWidget {
  String? username;
  String? email;
  String? noTelp;

  ProfileScreen({super.key});

  void logout(context, ref) async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TwoButtonAlertDialog(
          title: 'Konfirmasi Logout',
          content: 'Apakah Anda yakin ingin logout?',
          rightButtonText: 'Ya',
          leftButtonText: 'Tidak',
          onRightPressed: () => Navigator.of(context).pop(true),
          onLeftPressed: () => Navigator.of(context).pop(false),
        );
      },
    );

    if (confirmLogout) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
                child: CircularProgressIndicator(
              color: themeColor,
            ));
          },
        );

        await UserClient.logout();
        Navigator.pop(context);

        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
          (_) => false,
        );
        ref.refresh(listUserProvider);
        ref.refresh(userProvider);
      } catch (err) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleButtonAlertDialog(
              title: 'Logout Gagal',
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

  void deleteAccount(context, ref) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TwoButtonAlertDialog(
          title: 'Konfirmasi Hapus Akun',
          content: 'Apakah Anda yakin ingin menghapus akun?',
          rightButtonText: 'Ya',
          leftButtonText: 'Tidak',
          onRightPressed: () => Navigator.of(context).pop(true),
          onLeftPressed: () => Navigator.of(context).pop(false),
        );
      },
    );

    if (confirmDelete) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
                child: CircularProgressIndicator(
              color: themeColor,
            ));
          },
        );

        await UserClient.deleteAccount();
        Navigator.pop(context);

        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
          (_) => false,
        );
        ref.refresh(listUserProvider);
        ref.refresh(userProvider);
      } catch (err) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleButtonAlertDialog(
              title: 'Gagal Hapus Akun',
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
  Widget build(BuildContext context, WidgetRef ref) {
    var userProfile = ref.watch(userProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: userProfile.when(
            data: (user) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeColor,
                          ),
                          height: MediaQuery.of(context).size.height * 0.127,
                        ),
                        Positioned(
                          top: 55,
                          left: 0,
                          right: 0,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              ClipOval(
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.matrix(
                                      Matrix4.identity().storage),
                                  child: CircleAvatar(
                                    radius: 52,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: user.imageUrl != null
                                        ? NetworkImage(user.imageUrl!)
                                        : null,
                                    child: user.imageUrl == null
                                        ? Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                    Text(
                      '@${user.username ?? '-'}',
                      style: TextStyles.poppinsNormal(
                          fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      user.username ?? '-',
                      style: TextStyles.poppinsBold(
                          fontSize: 27, color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Yogyakarta',
                          style: TextStyles.poppinsNormal(
                              fontSize: 15, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text('  |  '),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Joined December 2024',
                          style: TextStyles.poppinsNormal(
                              fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: EditProfileScreen(),
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: themeColor,
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyles.poppinsBold(
                              fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Information',
                            style: TextStyles.poppinsBold(
                                fontSize: 27, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.email_rounded),
                                  const SizedBox(
                                    width: 13.0,
                                  ),
                                  Text(
                                    'Email',
                                    style: TextStyles.poppinsNormal(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                user.email ?? '-',
                                style: TextStyles.poppinsNormal(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 17.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.phone_rounded),
                                  const SizedBox(
                                    width: 13.0,
                                  ),
                                  Text(
                                    'Phone',
                                    style: TextStyles.poppinsNormal(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                user.nomorTelp ?? '-',
                                style: TextStyles.poppinsNormal(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                          TextButton(
                            onPressed: () {
                              deleteAccount(context, ref);
                            },
                            child: Text(
                              'Hapus Akun',
                              style: TextStyles.poppinsNormal(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                          TextButton(
                            onPressed: () {
                              logout(context, ref);
                            },
                            child: Text(
                              'Keluar',
                              style: TextStyles.poppinsNormal(
                                  fontSize: 15, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (err, stack) {
              return Center(
                child: Text('Error: ${err.toString()}'),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: themeColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
