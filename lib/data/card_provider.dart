import 'package:flutter/material.dart';

import 'cards.dart';

class CardsProvider with ChangeNotifier {
  List<Cards> _cards = [];

  List<Cards> get getCards => _cards;

  Future<void> setCards(List<Cards> futureData) async {
    _cards = futureData;
    notifyListeners();
  }

  Future<void> addCards(Cards data) async {
    _cards.add(data);
    notifyListeners();
  }

  Future<Cards> getCardsById(int id) async {
    return _cards.where((element) => element.id == id).first;
  }


  Future<void> setCardsById(Cards wallet) async {
    final index = _cards.indexWhere((element) => element.id == wallet.id);
    if (index != -1) {
      _cards[index] = wallet;
      notifyListeners();
    }
  }
}
