import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon2023_fitcha/data/currencies.dart';
import 'package:hackathon2023_fitcha/data/wallet_provider.dart';
import 'package:hackathon2023_fitcha/features/change_money_page/change_money_page.dart';
import 'package:hackathon2023_fitcha/features/elements/history_widget.dart';
import 'package:hackathon2023_fitcha/services/const.dart';
import 'package:hackathon2023_fitcha/services/storage.dart';
import 'package:hackathon2023_fitcha/style/style_library.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

import '../../data/operation.dart';
import '../../data/wallet.dart';
import '../add_wallet_page/add_wallet_page.dart';
import '../elements/wallet_widget.dart';
import 'package:http/http.dart' as http;

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

List<List<Operation>> histories = [
  [
    Operation(1, 10, 100, 0, 15, "RUB", "10.12.23 17:00", "Frank"),
    Operation(1, 20, 100, 1, 25, "USD", "10.12.23 17:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank"),
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank"),
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank"),
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank")
  ],
  [
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank"),
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank"),
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank"),
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 20, 10000, 1, 40, "KS", "10.12.23 20:27", "Frank")
  ],
  [
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank"),
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank"),
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 25, 500, 1, 35, "USDT", "10.12.23 17:50", "Frank"),
    Operation(1, 10, 700, 0, 15, "KZ", "10.12.23 18:20", "Frank"),
    Operation(1, 20, 10000, 1, 40, "KS", "10.12.23 20:27", "Frank")
  ]
];

class _CardsPageState extends State<CardsPage> {
  int currentWalletIndex = 0;
  String email = '';
  List<Currencies> banks = [];
  List<Wallet> wallets = [];
  bool isLoading = true;

  Future<String?> getTokenFromSecureStorage() async {
    final storage = SecureStorage();
    String? token = await storage.readSecureData('token');
    return token;
  }

  Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  Future<void> getAllWallets(String email) async {
    final url = 'http://${Const.ipurl}:8080/api/wallets/$email';
    final response = await http.get(Uri.parse(url));
    List<Wallet> wallets = [];
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      for (final wallet in jsonData) {
        wallets.add(Wallet.fromJson(wallet));
      }
    }
    Provider.of<WalletProvider>(context, listen: false).setWallets(wallets);
  }

  Future<void> initialization() async {
    final url = 'http://${Const.ipurl}:8080/api/currencies/';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      for (final bank in jsonData) {
        setState(() {
          banks.add(Currencies.fromJson(bank));
        });
      }
    }
  }

  Future<void> initialize() async {
    initialization();
    final token = await getTokenFromSecureStorage();
    if (token != null) {
      setState(() {
        email = decodeToken(token)["email"];
      });
      getAllWallets(email);
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      wallets = Provider.of<WalletProvider>(context).getWallet;
    });
    const duration = Duration(milliseconds: 250);
    Timer(duration, () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void copyToClipboard() {
    Clipboard.setData(
        ClipboardData(text: wallets[currentWalletIndex].toString()));
  }

  Currencies? getCurrenciesById(int id) {
    final matchingCurrencies = banks.where((element) => element.id == id);
    return matchingCurrencies.isNotEmpty ? matchingCurrencies.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            isLoading
                ? CircularProgressIndicator()
                : Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CarouselSlider.builder(
                      itemCount: wallets.length + 1,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        if (index < wallets.length && wallets != []) {
                          return WalletWidget(wallets[index],
                              getCurrenciesById(wallets[index].currency));
                        } else {
                          return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                ),
                                iconSize: 100,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddWalletPage(
                                            email: email, banks: banks)),
                                  );
                                },
                              ));
                        }
                      },
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentWalletIndex = index;
                          });
                        },
                        height: 250,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enlargeCenterPage: true,
                      ),
                    ),
                  ),
            if (currentWalletIndex != wallets.length)
              Container(
                margin: const EdgeInsets.only(top: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeMoneyPage(
                                  values: banks,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6b19ae),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Icon(
                            Icons.refresh,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Обмен',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: copyToClipboard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6b19ae),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Icon(
                            Icons.sticky_note_2_outlined,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Реквизиты',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    )
                  ],
                ),
              ),
            if (currentWalletIndex != wallets.length)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'История:',
                          style: StyleLibrary.text.black20,
                        ),
                      ),
                      HistoryWidget(
                          history: histories.length > currentWalletIndex
                              ? histories[currentWalletIndex]
                              : [])
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
