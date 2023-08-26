class Wallet {
  final int user_id;
  final int id;
  final int currency;
  double score;
  final int status;



  @override
  String toString() {
    return 'Wallet{user_id: $user_id, id: $id, currency: $currency, score: $score, status: $status}';
  }

  Wallet(
      {required this.user_id,
      required this.id,
      required this.currency,
      required this.score,
      required this.status});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      user_id: json['user_id'],
      id: json['id'],
      currency: json['currency'],
      score: double.parse(json['score'].toString()),
      status: json['status'],
    );
  }
}
