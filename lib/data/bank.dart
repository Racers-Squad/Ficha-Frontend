class Bank {
  final int id;
  final String name;
  final String country;

  Bank({required this.id, required this.name, required this.country});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
      country: json['country'],
    );
  }
}
