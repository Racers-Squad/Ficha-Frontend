import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/features/main_page/main_page.dart';
import 'package:hackathon2023_fitcha/services/auth_service.dart';
import 'package:hackathon2023_fitcha/services/storage.dart';
import 'package:hackathon2023_fitcha/style/style_library.dart';
import 'package:ionicons/ionicons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const routeName = '/registerPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;

  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  TextEditingController phoneTextInputController = TextEditingController();
  TextEditingController nameTextInputController = TextEditingController();
  TextEditingController surnameTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    nameTextInputController.dispose();
    surnameTextInputController.dispose();
    phoneTextInputController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> register() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    AuthService authService = AuthService();
    final SecureStorage secureStorage = SecureStorage();
    String? token = await authService.register(
        emailTextInputController.text.trim(),
        nameTextInputController.text.trim(),
        surnameTextInputController.text.trim(),
        phoneTextInputController.text.trim(),
        passwordTextInputController.text.trim(),
        context);
    secureStorage.writeSecureData('token', token!);
    Navigator.pushNamedAndRemoveUntil(
        context, MainPage.routeName, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleLibrary.color.orange,
      appBar: null,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
                child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30, top: 18),
            )),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50)),
                  color: Colors.white),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin:
                            const EdgeInsets.only(left: 30, top: 10, bottom: 4),
                        child: Text('Привет!', style: StyleLibrary.text.gray34),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 30),
                        child: Text('Зарегистрируйтесь',
                            style: StyleLibrary.text.lightGray20),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 21, left: 30),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text('Почта',
                              style: StyleLibrary.text.darkWhite12),
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
                              return null; // Return null if the email is valid
                            },
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 41, left: 30),
                        child: Opacity(
                          opacity: 0.7,
                          child:
                              Text('Имя', style: StyleLibrary.text.darkWhite12),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: nameTextInputController,
                            validator: (value) {
                              if (value == null) {
                                return 'Пожалуйста введите имя';
                              } else if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ\s-]{2,30}$')
                                  .hasMatch(value)) {
                                return 'Пожалуйста введите корректное имя';
                              }
                              return null; // Return null if the email is valid
                            },
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 41, left: 30),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text('Фамилия',
                              style: StyleLibrary.text.darkWhite12),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: surnameTextInputController,
                            validator: (value) {
                              if (value == null) {
                                return 'Пожалуйста введите фамилию';
                              } else if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ\s-]{2,30}$')
                                  .hasMatch(value)) {
                                return 'Пожалуйста введите корректную фамилию';
                              }
                              return null; // Return null if the email is valid
                            },
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 41, left: 30),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text('Телефон',
                              style: StyleLibrary.text.darkWhite12),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phoneTextInputController,
                            validator: (value) {
                              if (value == null) {
                                return 'Пожалуйста введите телефон';
                              } else if (!RegExp(r'^\+\d{3}\d{8}$')
                                  .hasMatch(value)) {
                                return 'Пожалуйста введите корректный телефон';
                              }
                              return null;
                            },
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 25, left: 30),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text('Пароль',
                              style: StyleLibrary.text.darkWhite12),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 40, left: 30, right: 30, bottom: 18),
                        child: ElevatedButton(
                          style: StyleLibrary.button.orangeButton,
                          onPressed: register,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Text('РЕГИСТРАЦИЯ',
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
