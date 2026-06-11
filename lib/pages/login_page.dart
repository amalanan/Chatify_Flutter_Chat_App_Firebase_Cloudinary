// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
//
// import '../services/navigation_service.dart';
// import '../widgets/custom_input_fields.dart';
// import '../widgets/rounded_button.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   late double _deviceHeight;
//   late double _deviceWidth;
//
//   // late AuthenticationProvider _auth;
//   late NavigationService _navigation;
//
//   final _loginFormKey = GlobalKey<FormState>();
//
//   String? _email;
//   String? _password;
//
//   @override
//   Widget build(BuildContext context) {
//     _deviceHeight = MediaQuery.of(context).size.height;
//     _deviceWidth = MediaQuery.of(context).size.width;
//     // _auth = Provider.of<AuthenticationProvider>(context);
//     _navigation = GetIt.instance.get<NavigationService>();
//     return _buildUI();
//   }
//
//   Widget _buildUI() {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: _deviceWidth * 0.03,
//           vertical: _deviceHeight * 0.02,
//         ),
//         height: _deviceHeight * 0.98,
//         width: _deviceWidth * 0.97,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _pageTitle(),
//             SizedBox(height: _deviceHeight * 0.04),
//             _loginForm(),
//             SizedBox(height: _deviceHeight * 0.05),
//             _loginButton(),
//             SizedBox(height: _deviceHeight * 0.02),
//             _registerAccountLink(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _pageTitle() {
//     return Container(
//       height: _deviceHeight * 0.10,
//       child: Text(
//         'Chatify',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 40,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
//
//   Widget _loginForm() {
//     return Container(
//       height: _deviceHeight * 0.18,
//       child: Form(
//         key: _loginFormKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CustomTextFormField(
//               onSaved: (_value) {
//                 setState(() {
//                   _email = _value;
//                 });
//               },
//               regEx:
//                   r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
//               hintText: "Email",
//               obscureText: false,
//             ),
//             CustomTextFormField(
//               onSaved: (_value) {
//                 setState(() {
//                   _password = _value;
//                 });
//               },
//               regEx: r".{8,}",
//               hintText: "Password",
//               obscureText: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _loginButton() {
//     return RoundedButton(
//       name: "Login",
//       height: _deviceHeight * 0.065,
//       width: _deviceWidth * 0.65,
//       onPressed: () {
//         if (_loginFormKey.currentState!.validate()) {
//           _loginFormKey.currentState!.save();
//           _auth.loginUsingEmailAndPassword(_email!, _password!);
//         }
//       },
//     );
//   }
//
//   Widget _registerAccountLink() {
//     return GestureDetector(
//       onTap: () => _navigation.navigateToRoute('/register'),
//       child: Container(
//         child: Text(
//           'Don\'t have an account?',
//           style: TextStyle(color: Colors.blueAccent),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../widgets/custom_input_fields.dart';
// import '../widgets/rounded_button.dart';
// import '../services/navigation_service.dart';
// import 'package:get_it/get_it.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   bool _isLoading = false;
//
//   void _login() async {
//     setState(() => _isLoading = true);
//
//     try {
//       final email = _emailController.text.trim();
//       final password = _passwordController.text.trim();
//
//       // TODO: replace later with Firebase Auth / DatabaseService
//       if (email.isNotEmpty && password.isNotEmpty) {
//         await Future.delayed(Duration(seconds: 1));
//
//         GetIt.instance<NavigationService>().navigateToRoute('/home');
//       }
//     } catch (e) {
//       print("Login error: $e");
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // LOGO (same style as splash)
//               Container(
//                 height: size.height * 0.18,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/images/logo.png'),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: size.height * 0.05),
//
//               // EMAIL
//               CustomTextField(
//                 controller: _emailController,
//                 hintText: "Email",
//                 obscureText: false,
//                 onEditingComplete: (_) {},
//                 icon: Icons.email,
//               ),
//
//               SizedBox(height: 15),
//
//               // PASSWORD
//               CustomTextField(
//                 controller: _passwordController,
//                 hintText: "Password",
//                 obscureText: true,
//                 onEditingComplete: (_) {},
//                 icon: Icons.lock,
//               ),
//
//               SizedBox(height: size.height * 0.04),
//
//               // LOGIN BUTTON
//               _isLoading
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : RoundedButton(
//                     name: "Login",
//                     height: 50,
//                     width: double.infinity,
//                     onPressed: _login,
//                   ),
//
//               SizedBox(height: 15),
//
//               // REGISTER NAV
//               TextButton(
//                 onPressed: () {
//                   GetIt.instance<NavigationService>().navigateToRoute(
//                     '/register',
//                   );
//                 },
//                 child: Text(
//                   "Create new account",
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../providers/authentication_provider.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';
import '../services/navigation_service.dart';
import '../services/database_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  final _loginFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  bool _isLoading = false;

  final _navigation = GetIt.instance<NavigationService>();
  final _db = GetIt.instance<DatabaseService>();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),

      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),

        height: _deviceHeight,
        width: _deviceWidth,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pageTitle(),

            SizedBox(height: _deviceHeight * 0.04),

            _loginForm(),

            SizedBox(height: _deviceHeight * 0.05),

            _loginButton(),

            SizedBox(height: _deviceHeight * 0.02),

            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Text(
      'Chatify',
      style: TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          CustomTextFormField(
            onSaved: (value) {
              _email = value;
            },
            regEx:
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
            hintText: "Email",
            obscureText: false,
          ),

          SizedBox(height: 15),

          CustomTextFormField(
            onSaved: (value) {
              _password = value;
            },
            regEx: r".{8,}",
            hintText: "Password",
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return _isLoading
        ? CircularProgressIndicator(color: Colors.white)
        : RoundedButton(
          name: "Login",
          height: _deviceHeight * 0.065,
          width: _deviceWidth * 0.65,
          onPressed: _login,
        );
  }

  // void _login() async {
  //   if (!_loginFormKey.currentState!.validate()) return;
  //
  //   _loginFormKey.currentState!.save();
  //
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     // 🔥 هون لاحقاً تربطي Firebase Auth
  //     // حالياً مجرد dummy flow
  //
  //     await Future.delayed(Duration(seconds: 1));
  //
  //     _navigation.navigateToRoute('/home');
  //   } catch (e) {
  //     print("Login error: $e");
  //   }
  //
  //   setState(() => _isLoading = false);
  // }
  void _login() async {
    if (!_loginFormKey.currentState!.validate()) return;

    _loginFormKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final auth = GetIt.instance<AuthenticationProvider>();

      await auth.login(_email!, _password!);
    } catch (e) {
      print("Login error: $e");
    }

    setState(() => _isLoading = false);
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => _navigation.navigateToRoute('/register'),
      child: Text(
        'Don\'t have an account?',
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}
