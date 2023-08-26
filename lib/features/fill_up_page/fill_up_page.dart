import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/wallet.dart';
import 'package:hackathon2023_fitcha/data/wallet_provider.dart';
import 'package:hackathon2023_fitcha/services/snack_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../services/const.dart';
import '../../style/style_library.dart';
import 'package:http/http.dart' as http;

class FillUpPage extends StatefulWidget {
  final Wallet wallet;

  const FillUpPage({super.key, required this.wallet});

  @override
  State<FillUpPage> createState() => _FillUpPageState();
}

class _FillUpPageState extends State<FillUpPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _moneySumController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();

  void submit() async {
    final url =
        'http://${Const.ipurl}:8080/api/wallets/${widget.wallet.id}/replenishment';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "money_sum": int.parse(_moneySumController.text),
          "card_number": int.parse(_cardNumberController.text)
        }));
    if (response.statusCode == 200) {
      Wallet result = widget.wallet;
      result.score = result.score + double.parse(_moneySumController.text);
      Provider.of<WalletProvider>(context, listen: false).setWalletById(result);
      Navigator.pop(context);
    } else {
      SnackBarService.showSnackBar(
          context, "Возникли проблемы с пополнением", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleLibrary.color.orange,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 36),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Ionicons.chevron_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Пополнение кошелька:',
                      style: StyleLibrary.text.white20,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.all(20),
                              child: Text("Введите сумму пополнения:")),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: TextFormField(
                              controller: _moneySumController,
                              decoration: const InputDecoration(
                                  labelText: 'Введите сумму'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Пожалуйста введите сумму пополнения';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(20),
                              child: Text("Введите номер карты")),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: TextFormField(
                              controller: _cardNumberController,
                              decoration: const InputDecoration(
                                  labelText: 'Введите номер карты'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Пожалуйста введите номер карты';
                                }
                                return null;
                              },
                            ),
                          ),
                          ElevatedButton(
                            style: StyleLibrary.button.orangeButton,
                            onPressed: submit,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Text(
                                        'Сохранить',
                                        style: StyleLibrary.text.white16,
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
