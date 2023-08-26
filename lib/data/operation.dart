class Operation {
  final int value;
  final int type_operation;

  Operation({required this.value, required this.type_operation});

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      value: json['value'],
      type_operation: json['type_operation']
    );
  }
}
