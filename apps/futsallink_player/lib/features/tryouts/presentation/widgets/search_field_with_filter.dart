import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class SearchFieldWithFilter extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;
  final bool autofocus;

  const SearchFieldWithFilter({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.onFilterTap,
    this.hintText = 'Pesquise peneiras',
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Campo de busca
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              autofocus: autofocus,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.6),
                  size: 22,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white.withOpacity(0.6),
                          size: 20,
                        ),
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              cursorColor: FutsallinkColors.primary,
            ),
          ),
        ),
        
        // Botão de filtro
        Container(
          margin: const EdgeInsets.only(left: 12),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: FutsallinkColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: FutsallinkColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
              size: 24,
            ),
            onPressed: onFilterTap,
          ),
        ),
      ],
    );
  }
} 