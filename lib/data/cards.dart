import 'package:flutter/material.dart';

class Cards {
  final int id;
  final int wallet_id;
  final int user_id;
  final String card_number;
  final String expiration_time;
  final int score;
  final int bank_id;

  Cards(
      {required this.id,
      required this.wallet_id,
      required this.user_id,
      required this.card_number,
      required this.expiration_time,
      required this.score,
      required this.bank_id});

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
        id: json['id'],
        wallet_id: json['wallet_id'],
        user_id: json['user_id'],
        card_number: json['card_number'],
        expiration_time: json['expiration_time'],
        score: json['score'],
        bank_id: json['bank_id']);
  }
}
