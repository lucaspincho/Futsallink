import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class CustomDropdownSelector<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final Function(T?) onChanged;
  final String Function(T)? itemToString;

  const CustomDropdownSelector({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemToString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isDense: false,
          value: value,
          hint: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          icon: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 24,
            ),
          ),
          dropdownColor: FutsallinkColors.darkBackground,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              alignment: AlignmentDirectional.center,
              child: Text(
                itemToString != null ? itemToString!(item) : item.toString(),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
          alignment: AlignmentDirectional.center,
          menuMaxHeight: 300,
        ),
      ),
    );
  }
} 