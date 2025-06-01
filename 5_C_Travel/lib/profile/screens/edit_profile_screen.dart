import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';
import 'package:tubes_5_c_travel/home/screens/profile_screen.dart';
import 'package:tubes_5_c_travel/profile/widgets/edit_profile_form.dart';
import 'package:tubes_5_c_travel/profile/screens/camera_view.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userProfile = ref.watch(userProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            title: 'Edit Profile',
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: userProfile.when(
            data: (user) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 31.0,
                    ),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        ClipOval(
                          child: ImageFiltered(
                            imageFilter:
                                ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: user.imageUrl != null
                                  ? NetworkImage(user.imageUrl!)
                                  : null,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (_) => CameraView()),
                            // );
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: CameraView(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          iconSize: 35,
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: Color.fromRGBO(28, 39, 76, 1.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: EditProfileForm(),
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
