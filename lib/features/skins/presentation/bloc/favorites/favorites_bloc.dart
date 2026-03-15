import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_cloude/core/usecases/usecase.dart';
import 'package:test_cloude/features/skins/domain/entities/skin_entity.dart';
import 'package:test_cloude/features/skins/domain/usecases/toggle_favorite.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final AddToFavorites addToFavorites;
  final RemoveFromFavorites removeFromFavorites;

  FavoritesBloc({
    required this.getFavorites,
    required this.addToFavorites,
    required this.removeFromFavorites,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    final result = await getFavorites(const NoParams());
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (skins) => emit(FavoritesLoaded(
        favorites: skins,
        favoriteIds: skins.map((s) => s.id).toSet(),
      )),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentFavoriteIds = state is FavoritesLoaded
        ? (state as FavoritesLoaded).favoriteIds
        : <String>{};

    if (currentFavoriteIds.contains(event.skin.id)) {
      await removeFromFavorites(event.skin.id);
    } else {
      await addToFavorites(event.skin);
    }

    // Reload favorites
    add(LoadFavorites());
  }
}
