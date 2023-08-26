class Cards {
  final int id;
  final int wallet_id;
  final int user_id;
  final int card_number;
  final DateTime expiration_time;
  final int score;
  final int bank_id;

  Cards(this.id, this.wallet_id, this.user_id, this.card_number,
      this.expiration_time, this.score, this.bank_id);
}
