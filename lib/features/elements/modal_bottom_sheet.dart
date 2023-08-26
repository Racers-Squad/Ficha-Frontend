import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/card_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../data/bank.dart';
import '../../data/wallet.dart';
import '../../services/const.dart';
import '../../style/style_library.dart';

class ModalBottomSheetWidget extends StatefulWidget {
  final String email;
  final Wallet wallet;
  final List<Bank>? banks;

  ModalBottomSheetWidget(
      {required this.email, required this.wallet, required this.banks});

  @override
  _ModalBottomSheetWidgetState createState() => _ModalBottomSheetWidgetState();
}

class _ModalBottomSheetWidgetState extends State<ModalBottomSheetWidget> {
  Bank? selectedBank;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.banks!.isNotEmpty) {
        selectedBank = widget.banks!.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.banks!.isEmpty
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'В данный момент нет доступных банков с данной валютой!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Выберите банк в котором вы хотите открыть карту',
                  style: StyleLibrary.text.black20,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 250,
                  child: DropdownButton<Bank>(
                    isExpanded: true,
                    value: selectedBank,
                    onChanged: (newValue) {
                      setState(() {
                        selectedBank = newValue!;
                      });
                    },
                    items: widget.banks!.map<DropdownMenuItem<Bank>>(
                      (Bank value) {
                        return DropdownMenuItem<Bank>(
                          value: value,
                          child: Text(value.name),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: StyleLibrary.button.orangeButton,
                  onPressed: () async {
                    final url =
                        'http://${Const.ipurl}:8080/api/cards/${widget.email}/add';
                    final response = await http.post(
                      Uri.parse(url),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        "wallet_id": widget.wallet.id,
                        "bank_id": selectedBank!.id,
                      }),
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text('Создать'),
                  ),
                ),
              ],
            ),
          );
  }
}
