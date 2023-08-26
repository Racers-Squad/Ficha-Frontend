import 'package:flutter/material.dart';

import '../../data/cards.dart';
import '../../style/style_library.dart';

class CardsList extends StatefulWidget {
  final List<Cards> cards;

  const CardsList({super.key, required this.cards});

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.cards!.isEmpty
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
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card ID: ${widget.cards[index].id}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text('Wallet ID: ${widget.cards[index].wallet_id}'),
                        Text('User ID: ${widget.cards[index].user_id}'),
                        Text('Card Number: ${widget.cards[index].card_number}'),
                        Text(
                            'Expiration Time: ${widget.cards[index].expiration_time}'),
                        Text('Score: ${widget.cards[index].score}'),
                        Text('Bank ID: ${widget.cards[index].bank_id}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
