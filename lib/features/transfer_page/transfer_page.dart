import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/card_provider.dart';
import 'package:hackathon2023_fitcha/data/cards.dart';
import 'package:hackathon2023_fitcha/data/wallet_provider.dart';
import 'package:hackathon2023_fitcha/services/snack_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../data/wallet.dart';
import '../../services/const.dart';
import '../../style/style_library.dart';

class TransferPage extends StatefulWidget {
  final Cards card;
  final double balance;
  final Wallet wallet;

  const TransferPage(
      {super.key,
      required this.balance,
      required this.card,
      required this.wallet});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final formKey = GlobalKey<FormState>();
  double amount = 0;

  void submit() async {
    if (amount > 0 && amount <= widget.wallet.score) {
      final response = await http.post(
        Uri.parse(
            'http://${Const.ipurl}:8080/api/wallets/${widget.wallet.id}/withdraw'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {"card_number": widget.card.card_number, "money_sum": amount}),
      );
      final data = json.decode(response.body);
      Wallet res = Wallet.fromJson(data[0]);
      Provider.of<WalletProvider>(context, listen: false).setWalletById(res);
      Cards result = Cards.fromJson(data[1]);
      Provider.of<CardsProvider>(context, listen: false).setCardsById(result);
      Navigator.pop(context);
      Navigator.pop(context);
      SnackBarService.showSnackBar(
          context, 'Средства упешно переведенны', false);
    } else {
      SnackBarService.showSnackBar(
          context, 'Произошла ошибка при переводе средств!', true);
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
                    Flexible(
                      child: Text(
                        'Перевод средств на виртуальную карту',
                        style: StyleLibrary.text.white20,
                      ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              'Баланс: ${widget.balance.toString()}',
                              style: StyleLibrary.text.black20,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  amount = double.tryParse(value) ?? 0.0;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Сумма',
                              ),
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
                                        'Перевести',
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
