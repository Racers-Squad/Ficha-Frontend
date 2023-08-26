class Currencies {
  final int id;
  final String name;
  final String short_name;

  Currencies({required this.id, required this.name, required this.short_name});

  factory Currencies.fromJson(Map<String, dynamic> json) {
    return Currencies(
        id: json['id'], name: json['name'], short_name: json['short_name']);
  }
}
