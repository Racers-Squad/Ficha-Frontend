import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/wallet.dart';
import 'package:hackathon2023_fitcha/data/wallet_provider.dart';
import 'package:hackathon2023_fitcha/style/style_library.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../data/currencies.dart';
import '../../services/const.dart';
import '../elements/dropdown_menu.dart';

class AddWalletPage extends StatefulWidget {
  final String email;
  final List<Currencies> banks;

  const AddWalletPage({super.key, required this.email, required this.banks});

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  final formKey = GlobalKey<FormState>();
  String selectedBank = '';

  void submit() async {
    final url = 'http://${Const.ipurl}:8080/api/wallets/add';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "currency": widget.banks
              .where((element) => element.short_name == selectedBank)
              .first
              .id,
          "email": widget.email
        }));
    Provider.of<WalletProvider>(context, listen: false)
        .addWallets(Wallet.fromJson(json.decode(response.body)));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    selectedBank = widget.banks.first.short_name;
  }

  void handleSelected(String? value) {
    setState(() {
      selectedBank = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleLibrary.color.orange,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 36),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Ionicons.chevron_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Добавление кошелька',
                      style: StyleLibrary.text.white20,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Выберите валюту:',
                            style: StyleLibrary.text.darkWhite12,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            child: BankDropDownMenu(
                                arrayOfElements: widget.banks,
                                onElementSelected: handleSelected),
                          ),
                          ElevatedButton(
                            style: StyleLibrary.button.orangeButton,
                            onPressed: submit,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Text(
                                        'Сохранить',
                                        style: StyleLibrary.text.white16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
