import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/currencies.dart';
import 'package:hackathon2023_fitcha/data/wallet.dart';
import 'package:hackathon2023_fitcha/features/wallet_page/wallet_page.dart';
import 'package:hackathon2023_fitcha/style/style_library.dart';

import '../../data/cards.dart';
import '../fill_up_page/fill_up_page.dart';

class WalletWidget extends StatelessWidget {
  final String email;
  final Wallet card;
  final Currencies? currencies;
  final List<Cards> cards;

  WalletWidget(this.card, this.currencies, this.email, this.cards, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WalletPage(wallet: card, currencies: currencies,email: email, cards: cards)),
        )
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff3f51b5), Color(0xff9c27b0)],
            stops: [0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text('Баланс:', style: StyleLibrary.text.white25)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      card.score.toString(),
                      style: StyleLibrary.text.white20,
                    ),
                    Text(
                      currencies!.short_name,
                      style: StyleLibrary.text.white20,
                    )
                  ],
                ),
              ],
            ),
            if (currencies!.short_name == 'RUB')
              ElevatedButton(
                  onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FillUpPage(
                                    wallet: card,
                                  )),
                        )
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffcb19ae),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text("Пополнить"))
          ],
        ),
      ),
    );
  }
}
