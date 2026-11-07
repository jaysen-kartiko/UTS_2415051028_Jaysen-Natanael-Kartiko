import 'package:flutter/material.dart';

class MovieFilterChips extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onSelected;

  const MovieFilterChips({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
          const SizedBox(width: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(item),
                  selected: selectedItem == item,
                  selectedColor: Colors.brown,
                  labelStyle: TextStyle(
                    color: selectedItem == item ? Colors.white : Colors.brown,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      onSelected(item);
                    }
                  },
                ),
              )),
        ],
      ),
    );
  }
}