import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/style/style_library.dart';
import 'package:ionicons/ionicons.dart';

import '../../data/operation.dart';

class HistoryWidget extends StatefulWidget {
  final List<Operation>? history;

  const HistoryWidget({super.key, required this.history});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.history!.length == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Пусто!",
                  style: StyleLibrary.text.black20,
                ),
              ],
            )
          : Container(
              margin: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.history!.length,
                itemBuilder: (BuildContext context, int index) {
                  Operation operation = widget.history![index];
                  return Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        operation.type_operation == 0
                            ? const Icon(
                                Ionicons.trending_down,
                                size: 40,
                                color: Color(0xff8B0000),
                              )
                            : const Icon(
                                Ionicons.trending_up,
                                size: 40,
                                color: Color(0xff0000FF),
                              ),
                        Text(
                          "${operation.type_operation == 0 ? "-" : "+"} ${operation.value} ${operation.type_operation}",
                          style: StyleLibrary.text.black16,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
