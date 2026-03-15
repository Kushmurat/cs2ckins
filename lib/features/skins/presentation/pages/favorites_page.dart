import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_cloude/features/skins/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:test_cloude/features/skins/presentation/pages/skin_detail_page.dart';
import 'package:test_cloude/features/skins/presentation/widgets/skin_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FavoritesError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.white70),
            ),
          );
        }

        if (state is FavoritesLoaded) {
          if (state.favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any skin to add it here',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final skin = state.favorites[index];
              return SkinCard(
                skin: skin,
                isFavorite: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SkinDetailPage(skin: skin),
                    ),
                  );
                },
                onFavoriteTap: () {
                  context
                      .read<FavoritesBloc>()
                      .add(ToggleFavoriteEvent(skin));
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
