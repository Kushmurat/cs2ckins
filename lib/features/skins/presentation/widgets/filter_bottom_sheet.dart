import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_cloude/features/skins/presentation/bloc/skins_list/skins_list_bloc.dart';

class FilterBottomSheet extends StatelessWidget {
  final ScrollController scrollController;

  const FilterBottomSheet({super.key, required this.scrollController});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<SkinsListBloc>(),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, controller) =>
              FilterBottomSheet(scrollController: controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkinsListBloc, SkinsListState>(
      builder: (context, state) {
        if (state is! SkinsListLoaded) return const SizedBox.shrink();

        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (state.hasActiveFilters)
                  TextButton(
                    onPressed: () {
                      context.read<SkinsListBloc>().add(ClearAllFilters());
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Clear All',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Rarity
            _buildFilterSection(
              context,
              title: 'Rarity',
              options: state.rarities,
              selected: state.currentRarity,
              onSelected: (val) =>
                  context.read<SkinsListBloc>().add(FilterByRarity(val)),
            ),

            // Weapon
            _buildFilterSection(
              context,
              title: 'Weapon',
              options: state.weapons,
              selected: state.currentWeapon,
              onSelected: (val) =>
                  context.read<SkinsListBloc>().add(FilterByWeapon(val)),
            ),

            // Category
            _buildFilterSection(
              context,
              title: 'Category',
              options: state.categories,
              selected: state.currentCategory,
              onSelected: (val) =>
                  context.read<SkinsListBloc>().add(FilterByCategory(val)),
            ),

            // Toggle filters
            const Text(
              'Special',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('StatTrak'),
                  selected: state.stattrakFilter == true,
                  onSelected: (selected) {
                    context.read<SkinsListBloc>().add(
                          FilterByStatTrak(selected ? true : null),
                        );
                  },
                  selectedColor: Colors.orange,
                  backgroundColor: Theme.of(context).cardColor,
                  labelStyle: TextStyle(
                    color:
                        state.stattrakFilter == true ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                FilterChip(
                  label: const Text('Souvenir'),
                  selected: state.souvenirFilter == true,
                  onSelected: (selected) {
                    context.read<SkinsListBloc>().add(
                          FilterBySouvenir(selected ? true : null),
                        );
                  },
                  selectedColor: Colors.amber,
                  backgroundColor: Theme.of(context).cardColor,
                  labelStyle: TextStyle(
                    color:
                        state.souvenirFilter == true ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Apply button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94560),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Show ${state.totalCount} skins',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterSection(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected == option;
            return FilterChip(
              label: Text(
                option,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(isSelected ? null : option),
              selectedColor: const Color(0xFFE94560),
              backgroundColor: Theme.of(context).cardColor,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
