import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/widgets/button/basic_app_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../auth/pages/signup_or_signin.dart';
import '../bloc/theme_cubit.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.chooseModeBG),
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.15)),
          Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(AppImages.logo),
              ),
              Spacer(),
              Text(
                'Choose Mode',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<ThemeCubit>().updateTheme(
                            ThemeMode.dark,
                          );
                        },
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Color(0xff30393C).withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                AppVectors.moon,
                                fit: BoxFit.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 40),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<ThemeCubit>().updateTheme(
                            ThemeMode.light,
                          );
                        },
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Color(0xff30393C).withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                AppVectors.sun,
                                fit: BoxFit.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Light Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: BasicAppButton(
                  title: 'Continue',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return SignupOrSigninPage();
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
