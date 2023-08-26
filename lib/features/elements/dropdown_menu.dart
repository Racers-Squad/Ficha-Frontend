import 'package:flutter/material.dart';
import 'package:hackathon2023_fitcha/data/currencies.dart';
import 'package:ionicons/ionicons.dart';

class CustomDropDownMenu extends StatefulWidget {
  const CustomDropDownMenu(
      {super.key,
      required this.arrayOfElements,
      required this.onElementSelected});

  final List<String> arrayOfElements;
  final Function(String?) onElementSelected;

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  String? selectedDate;

  @override
  void initState() {
    selectedDate = widget.arrayOfElements[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedDate,
      onChanged: (String? value) {
        setState(() {
          selectedDate = value;
        });
        widget.onElementSelected(value);
      },
      menuMaxHeight: 400,
      isExpanded: true,
      icon: const Icon(Ionicons.chevron_down),
      items:
          widget.arrayOfElements.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class BankDropDownMenu extends StatefulWidget {
  const BankDropDownMenu(
      {super.key,
      required this.arrayOfElements,
      required this.onElementSelected});

  final List<Currencies> arrayOfElements;
  final Function(String?) onElementSelected;

  @override
  State<BankDropDownMenu> createState() => _BankDropDownMenuState();
}

class _BankDropDownMenuState extends State<BankDropDownMenu> {
  String? selectedDate;

  @override
  void initState() {
    selectedDate = widget.arrayOfElements[0].short_name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedDate,
      onChanged: (String? value) {
        setState(() {
          selectedDate = value;
        });
        widget.onElementSelected(value);
      },
      menuMaxHeight: 400,
      isExpanded: true,
      icon: const Icon(Ionicons.chevron_down),
      items: widget.arrayOfElements.map<DropdownMenuItem<String>>((Currencies value) {
        return DropdownMenuItem<String>(
          value: value.short_name,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value.name),
              Text(value.short_name),
            ],
          ),
        );
      }).toList(),
    );
  }
}
