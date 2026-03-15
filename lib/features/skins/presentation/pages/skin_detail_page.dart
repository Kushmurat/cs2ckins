import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_cloude/features/skins/domain/entities/skin_entity.dart';
import 'package:test_cloude/features/skins/presentation/bloc/favorites/favorites_bloc.dart';

class SkinDetailPage extends StatelessWidget {
  final SkinEntity skin;

  const SkinDetailPage({super.key, required this.skin});

  @override
  Widget build(BuildContext context) {
    final rarityColor = _parseColor(skin.rarity?.color);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          skin.name,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final isFav = state is FavoritesLoaded &&
                  state.favoriteIds.contains(skin.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  context
                      .read<FavoritesBloc>()
                      .add(ToggleFavoriteEvent(skin));
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Center(
              child: Hero(
                tag: 'skin_${skin.id}',
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: rarityColor, width: 2),
                  ),
                  child: skin.image != null
                      ? CachedNetworkImage(
                          imageUrl: skin.image!,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 60),
                        )
                      : const Icon(Icons.image_not_supported, size: 60),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Rarity badge
            if (skin.rarity != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: rarityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: rarityColor),
                ),
                child: Text(
                  skin.rarity!.name,
                  style: TextStyle(
                    color: rarityColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Info rows
            _buildInfoSection(context),
            const SizedBox(height: 16),

            // Description
            if (skin.description.isNotEmpty) ...[
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                skin.description,
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Wears
            if (skin.wears.isNotEmpty) ...[
              const Text(
                'Available Wears',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skin.wears
                    .map((wear) => Chip(
                          label: Text(
                            wear.name,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Theme.of(context).cardColor,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Collections
            if (skin.collections.isNotEmpty) ...[
              const Text(
                'Collections',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ...skin.collections.map((c) => _buildListTile(c.name, c.image)),
              const SizedBox(height: 16),
            ],

            // Crates
            if (skin.crates.isNotEmpty) ...[
              const Text(
                'Found in Cases',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ...skin.crates.map((c) => _buildListTile(c.name, c.image)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (skin.weapon != null)
            _buildInfoRow('Weapon', skin.weapon!.name),
          if (skin.category != null)
            _buildInfoRow('Category', skin.category!.name),
          if (skin.minFloat != null && skin.maxFloat != null)
            _buildInfoRow(
              'Float Range',
              '${skin.minFloat!.toStringAsFixed(2)} - ${skin.maxFloat!.toStringAsFixed(2)}',
            ),
          if (skin.stattrak) _buildInfoRow('StatTrak', 'Available'),
          if (skin.souvenir) _buildInfoRow('Souvenir', 'Available'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String name, String? imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (imageUrl != null)
            SizedBox(
              width: 40,
              height: 40,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          if (imageUrl != null) const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.grey;
    final buffer = StringBuffer();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 6) buffer.write('FF');
    buffer.write(hex);
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
