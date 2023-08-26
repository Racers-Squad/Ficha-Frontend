import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/currencies.dart';
import 'package:hackathon2023_fitcha/data/wallet.dart';
import 'package:hackathon2023_fitcha/data/wallet_provider.dart';
import 'package:hackathon2023_fitcha/services/snack_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../services/const.dart';
import '../../style/style_library.dart';

class ChangeMoneyPage extends StatefulWidget {
  const ChangeMoneyPage({super.key, required this.values});

  final List<Currencies> values;

  @override
  State<ChangeMoneyPage> createState() => _ChangeMoneyPageState();
}

class _ChangeMoneyPageState extends State<ChangeMoneyPage> {
  final formKey = GlobalKey<FormState>();
  List<Wallet> wallets = [];
  late Wallet fromAccount;
  late Wallet toAccount;
  double amount = 0.0;

  String getShortNameOfCurrenciesById(int id) {
    return widget.values.where((element) => element.id == id).first.short_name;
  }

  @override
  void initState() {
    super.initState();
    wallets = Provider.of<WalletProvider>(context, listen: false).getWallet;
    fromAccount = wallets.first;
    toAccount = wallets.last;
  }

  void submit() async {
    if (amount <= 0) {
      SnackBarService.showSnackBar(
          context, "Введите пожалуйста корректную сумму!", true);
    } else {
      if (fromAccount.score < amount) {
        SnackBarService.showSnackBar(
            context, "Введите пожалуйста корректную сумму!", true);
      } else {
        final url = 'http://${Const.ipurl}:8080/api/wallets/change';
        final response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              "sender_wallet_id": fromAccount.id,
              "accept_wallet_id": toAccount.id,
              "money_sum": amount
            }));
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          List<Wallet> resultList = [];
          for (final wallet in jsonData) {
            resultList.add(Wallet.fromJson(wallet));
          }
          resultList.forEach((element) {
            Provider.of<WalletProvider>(context, listen: false)
                .setWalletById(element);
          });
          Navigator.pop(context);
        } else {
          SnackBarService.showSnackBar(
              context, "При конвертации произошла непредвиденная ошибка", true);
        }
      }
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
                      'Обмен валют между кошельками',
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            child: DropdownButton<Wallet>(
                              isExpanded: true,
                              value: fromAccount,
                              onChanged: (newValue) {
                                setState(() {
                                  if (toAccount != newValue) {
                                    fromAccount = newValue!;
                                  }
                                });
                              },
                              items: wallets.map<DropdownMenuItem<Wallet>>(
                                (Wallet value) {
                                  return DropdownMenuItem<Wallet>(
                                    value: value,
                                    child: Text(
                                      'Счет №${value.id} - ${value.score} ${getShortNameOfCurrenciesById(value.currency)}',
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                          SizedBox(height: 50),
                          Container(
                            width: 200,
                            child: DropdownButton<Wallet>(
                              isExpanded: true,
                              value: toAccount,
                              onChanged: (newValue) {
                                setState(() {
                                  if (fromAccount != newValue) {
                                    toAccount = newValue!;
                                  }
                                });
                              },
                              items: wallets.map<DropdownMenuItem<Wallet>>(
                                (Wallet value) {
                                  return DropdownMenuItem<Wallet>(
                                    value: value,
                                    child: Text(
                                      'Счет №${value.id} - ${value.score} ${getShortNameOfCurrenciesById(value.currency)}',
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
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
                                        'Обменять',
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
