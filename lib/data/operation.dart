class Operation {
  final int card_id;
  final double start_meaning;
  final double operating;
  final int type_operation;
  final double finish_operation;
  final String currency;
  final String time;
  final String sender;

  Operation(
      this.card_id,
      this.start_meaning,
      this.operating,
      this.type_operation,
      this.finish_operation,
      this.currency,
      this.time,
      this.sender);
}
