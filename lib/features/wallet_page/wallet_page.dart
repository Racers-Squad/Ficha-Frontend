import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/currencies.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

import '../../data/bank.dart';
import '../../data/wallet.dart';
import '../../services/const.dart';
import '../../style/style_library.dart';
import '../../data/cards.dart';
import '../elements/cards_list.dart';
import '../elements/modal_bottom_sheet.dart';

class WalletPage extends StatefulWidget {
  final String email;
  final Wallet wallet;
  final Currencies? currencies;
  final List<Cards> cards;

  const WalletPage(
      {super.key,
      required this.email,
      required this.wallet,
      required this.currencies,
      required this.cards});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final formKey = GlobalKey<FormState>();
  List<Bank> banks = [];
  late Bank selectedBank;

  void _openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ModalBottomSheetWidget(
          email: widget.email,
          wallet: widget.wallet,
          banks: banks,
        );
      },
    );
  }

  void init() async {
    var queryParams = {'currency_id': widget.wallet.currency.toString()};
    final uri = Uri.parse('http://${Const.ipurl}:8080/api/banks/all')
        .replace(queryParameters: queryParams);
    final response = await http.get(uri);
    final jsonData = json.decode(response.body);
    for (final bank in jsonData) {
      banks.add(Bank.fromJson(bank));
    }
    setState(() {
      selectedBank = banks.first;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleLibrary.color.orange,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
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
                    'Добавление кошелька',
                    style: StyleLibrary.text.white20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Баланс: ${widget.wallet.score}',
                        style: StyleLibrary.text.black20,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: ElevatedButton(
                          style: StyleLibrary.button.orangeButton,
                          onPressed: () => {_openModal(context)},
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Оформление виртуальной карты',
                                    style: StyleLibrary.text.white20,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Icon(Icons.add)
                              ],
                            ),
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Карты:',
                        style: StyleLibrary.text.black20,
                      ),
                    ),
                    CardsList(
                      cards: widget.cards,
                      balance: widget.wallet.score,wallet: widget.wallet,
                    ),
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
