import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/currencies.dart';
import 'package:ionicons/ionicons.dart';

import '../../data/wallet.dart';
import '../../style/style_library.dart';
import '../../data/cards.dart';
import '../elements/cards_list.dart';

class WalletPage extends StatefulWidget {
  final Wallet wallet;
  final Currencies? currencies;

  const WalletPage({super.key, required this.wallet, required this.currencies});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final formKey = GlobalKey<FormState>();

  void _openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Выберите банк в котором вы хотите открыть карту',
                style: StyleLibrary.text.black20,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 250,
                child: DropdownButton<String>(
                  isExpanded: true,
                  items: <String>['Option 1', 'Option 2', 'Option 3']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) => {},
                  hint: const Text('Выберите банк'),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: StyleLibrary.button.orangeButton,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text('Создать')),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Cards> cards = [
    Cards(1, 101, 201, 1234567890123456, DateTime(2023, 12, 31), 800, 301),
    Cards(2, 102, 202, 9876543210987654, DateTime(2024, 6, 30), 750, 302),
    Cards(3, 103, 203, 1111222233334444, DateTime(2025, 3, 15), 850, 303),
    Cards(4, 104, 204, 5555666677778888, DateTime(2026, 8, 20), 720, 304),
    Cards(5, 105, 205, 4444333322221111, DateTime(2027, 2, 28), 700, 305),
    Cards(6, 106, 206, 6666777788889999, DateTime(2028, 9, 10), 780, 306),
    Cards(7, 107, 207, 8888999900001111, DateTime(2029, 11, 5), 820, 307),
    Cards(8, 108, 208, 2222111133334444, DateTime(2030, 4, 25), 760, 308),
    Cards(9, 109, 209, 7777666655554444, DateTime(2031, 7, 8), 790, 309),
    Cards(10, 110, 210, 9999888877776666, DateTime(2032, 1, 12), 830, 310),
  ];

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
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Добавление кошелька',
                    style: StyleLibrary.text.black20,
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
                      cards: cards,
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
