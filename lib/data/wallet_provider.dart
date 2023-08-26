import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/wallet.dart';

class WalletProvider with ChangeNotifier {
  List<Wallet> _wallet = [];

  List<Wallet> get getWallet => _wallet;

  Future<void> setWallets(List<Wallet> futureData) async {
    _wallet = futureData;
    notifyListeners();
  }

  Future<void> addWallets(Wallet data) async {
    _wallet.add(data);
    notifyListeners();
  }

  Future<Wallet> getWalletById(int id) async {
    return _wallet.where((element) => element.id == id).first;
  }

  Future<void> setWalletById(Wallet wallet) async {
    final index = _wallet.indexWhere((element) => element.id == wallet.id);
    if (index != -1) {
      _wallet[index] = wallet;
      notifyListeners();
    }
  }
}
