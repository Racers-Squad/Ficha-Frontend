import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/wallet_provider.dart';
import 'package:hackathon2023_fitcha/features/login_page/login_page.dart';
import 'package:hackathon2023_fitcha/features/main_page/main_page.dart';
import 'package:hackathon2023_fitcha/features/register_page/register_page.dart';
import 'package:hackathon2023_fitcha/services/auth_service.dart';
import 'package:hackathon2023_fitcha/services/storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<String?>(
          future: checkToken(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              String? user = snapshot.data;
              return Navigator(
                initialRoute:
                    user == null ? LoginPage.routeName : MainPage.routeName,
                onGenerateRoute: (RouteSettings settings) {
                  if (settings.name == MainPage.routeName) {
                    return MaterialPageRoute(
                        builder: (context) => const MainPage());
                  } else if (settings.name == LoginPage.routeName) {
                    return MaterialPageRoute(
                        builder: (context) => const LoginPage());
                  } else if (settings.name == RegisterPage.routeName) {
                    return MaterialPageRoute(
                        builder: (context) => const RegisterPage());
                  }
                  return null;
                },
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<String?> checkToken() async {
    AuthService auth = AuthService();
    String? user = await auth.check();
    if (user != null) {
      final SecureStorage secureStorage = SecureStorage();
      await secureStorage.writeSecureData('token', user);
    }
    return user;
  }
}
