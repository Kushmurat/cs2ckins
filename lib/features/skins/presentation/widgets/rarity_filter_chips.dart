import 'package:flutter/material.dart';

class RarityFilterChips extends StatelessWidget {
  final List<String> rarities;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const RarityFilterChips({
    super.key,
    required this.rarities,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All', style: TextStyle(fontSize: 12)),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
              selectedColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).cardColor,
              labelStyle: TextStyle(
                color: selected == null ? Colors.white : Colors.grey,
              ),
            ),
          ),
          ...rarities.map(
            (rarity) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(rarity, style: const TextStyle(fontSize: 12)),
                selected: selected == rarity,
                onSelected: (_) =>
                    onSelected(selected == rarity ? null : rarity),
                selectedColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).cardColor,
                labelStyle: TextStyle(
                  color: selected == rarity ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
