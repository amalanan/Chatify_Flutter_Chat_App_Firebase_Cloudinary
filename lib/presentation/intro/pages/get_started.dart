import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/button/basic_app_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../choose_mode/pages/choose_mode.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

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
                image: AssetImage(AppImages.signin),
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.15)),
          Column(
            children: [
              SizedBox(height: 140),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(AppImages.logo2),
              ),
              Spacer(),
              Text(
                'Enjoy Chatting with Friends',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'Welcome to Chatify 💜,\n where conversations come alive. Connect with friends, share your moments, and enjoy seamless communication anytime, anywhere.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: context.isDarkMode ? Colors.grey : Colors.white,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: BasicAppButton(
                  title: 'Get Started',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ChooseModePage();
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
