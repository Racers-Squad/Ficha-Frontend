import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/wallet.dart';

import '../../data/cards.dart';
import '../../style/style_library.dart';
import '../transfer_page/transfer_page.dart';

class CardsList extends StatefulWidget {
  final List<Cards> cards;
  final double balance;
  final Wallet wallet;

  const CardsList(
      {super.key,
      required this.cards,
      required this.balance,
      required this.wallet});

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.cards.isEmpty
          ? Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Пусто!",
                  style: StyleLibrary.text.black20,
                ),
              ],
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.cards.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff6b19ae), width: 3),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.cards[index].card_number.substring(0, 4)} ${widget.cards[index].card_number.substring(4, 8)} ${widget.cards[index].card_number.substring(8, 12)} ${widget.cards[index].card_number.substring(12, 15)}',
                          style: StyleLibrary.text.black20,
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Срок годности ${widget.cards[index].expiration_time.substring(2, 4)}/${widget.cards[index].expiration_time.substring(5, 7)}',
                                textAlign: TextAlign.start,
                                style: StyleLibrary.text.black16,
                              ),
                              Text('Баланс: ${widget.cards[index].score}'),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Bank ID: ${widget.cards[index].bank_id}'),
                            ElevatedButton(
                                style: StyleLibrary.button.orangeButton,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TransferPage(
                                              balance: widget.balance,
                                              card: widget.cards[index],
                                              wallet: widget.wallet,
                                            )),
                                  );
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Пополнить')))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
