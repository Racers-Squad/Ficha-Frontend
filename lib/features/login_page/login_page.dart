import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackathon2023_fitcha/features/main_page/main_page.dart';
import 'package:hackathon2023_fitcha/features/register_page/register_page.dart';
import 'package:hackathon2023_fitcha/services/auth_service.dart';
import 'package:hackathon2023_fitcha/services/storage.dart';
import 'package:hackathon2023_fitcha/style/style_library.dart';
import 'package:ionicons/ionicons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();

    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    AuthService authService = AuthService();
    final SecureStorage secureStorage = SecureStorage();
    String? token = await authService.login(
        emailTextInputController.text.trim(),
        passwordTextInputController.text.trim(),
        context);
    if (token != null) {
      secureStorage.writeSecureData('token', token!);
      Navigator.pushNamedAndRemoveUntil(
          context, MainPage.routeName, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleLibrary.color.orange,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10, left: 20),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 0,
                      bottom: 40,
                      child: Text(
                        'Привет!',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Source Sans Pro',
                          fontSize: 34,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Positioned(
                        left: 0,
                        bottom: 0,
                        child: Opacity(
                          opacity: 0.9,
                          child: Text(
                            'Войдите, чтобы продолжить',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Source Sans Pro',
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        )),
                    SafeArea(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            alignment: Alignment.topRight,
                            child: const SizedBox(
                              height: 150,
                            )))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50)),
                      color: Colors.white),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 50, left: 30),
                          child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              'Почта',
                              style: TextStyle(
                                  fontFamily: 'Source Sans Pro',
                                  fontSize: 12,
                                  color: StyleLibrary.color.lightGray),
                            ),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailTextInputController,
                              validator: (value) {
                                if (value == null) {
                                  return 'Пожалуйста введите почту';
                                } else if (!RegExp(
                                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                    .hasMatch(value)) {
                                  return 'Пожалуйста введите корректную почту';
                                }
                                return null;
                              },
                            )),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 35, left: 30),
                          child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              'Пароль',
                              style: TextStyle(
                                  fontFamily: 'Source Sans Pro',
                                  fontSize: 12,
                                  color: StyleLibrary.color.lightGray),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            controller: passwordTextInputController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: _toggle,
                                    icon: Icon(_obscureText
                                        ? Ionicons.eye_sharp
                                        : Ionicons.eye_off_sharp))),
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Минимум 6 символов'
                                    : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 40, left: 30, right: 30),
                          child: ElevatedButton(
                            style: StyleLibrary.button.orangeButton,
                            onPressed: login,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Text('ВОЙТИ',
                                          style: StyleLibrary.text.white16),
                                    ),
                                  ),
                                ),
                                const Column(
                                  children: [
                                    Icon(
                                      Ionicons.arrow_forward_sharp,
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 33),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RegisterPage.routeName);
                              },
                              child: Text(
                                "Нет аккаунта?",
                                style:
                                    TextStyle(color: StyleLibrary.color.orange),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
