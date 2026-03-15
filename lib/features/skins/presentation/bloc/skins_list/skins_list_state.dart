part of 'skins_list_bloc.dart';

abstract class SkinsListState extends Equatable {
  const SkinsListState();

  @override
  List<Object?> get props => [];
}

class SkinsListInitial extends SkinsListState {}

class SkinsListLoading extends SkinsListState {}

class SkinsListLoaded extends SkinsListState {
  final List<SkinEntity> skins;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final List<String> rarities;
  final List<String> weapons;
  final List<String> categories;
  final String? currentRarity;
  final String? currentWeapon;
  final String? currentCategory;
  final bool? stattrakFilter;
  final bool? souvenirFilter;

  const SkinsListLoaded({
    required this.skins,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.rarities,
    required this.weapons,
    required this.categories,
    this.currentRarity,
    this.currentWeapon,
    this.currentCategory,
    this.stattrakFilter,
    this.souvenirFilter,
  });

  bool get hasActiveFilters =>
      currentRarity != null ||
      currentWeapon != null ||
      currentCategory != null ||
      stattrakFilter != null ||
      souvenirFilter != null;

  bool get hasPrevious => currentPage > 1;
  bool get hasNext => currentPage < totalPages;

  @override
  List<Object?> get props => [
        skins,
        totalCount,
        currentPage,
        totalPages,
        rarities,
        weapons,
        categories,
        currentRarity,
        currentWeapon,
        currentCategory,
        stattrakFilter,
        souvenirFilter,
      ];
}

class SkinsListError extends SkinsListState {
  final String message;
  const SkinsListError(this.message);

  @override
  List<Object?> get props => [message];
}
