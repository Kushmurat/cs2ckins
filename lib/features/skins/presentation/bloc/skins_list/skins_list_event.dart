part of 'skins_list_bloc.dart';

abstract class SkinsListEvent extends Equatable {
  const SkinsListEvent();

  @override
  List<Object?> get props => [];
}

class LoadSkins extends SkinsListEvent {}

class GoToPage extends SkinsListEvent {
  final int page;
  const GoToPage(this.page);

  @override
  List<Object?> get props => [page];
}

class SearchSkins extends SkinsListEvent {
  final String query;
  const SearchSkins(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByRarity extends SkinsListEvent {
  final String? rarity;
  const FilterByRarity(this.rarity);

  @override
  List<Object?> get props => [rarity];
}

class FilterByWeapon extends SkinsListEvent {
  final String? weapon;
  const FilterByWeapon(this.weapon);

  @override
  List<Object?> get props => [weapon];
}

class FilterByCategory extends SkinsListEvent {
  final String? category;
  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class FilterByStatTrak extends SkinsListEvent {
  final bool? stattrak;
  const FilterByStatTrak(this.stattrak);

  @override
  List<Object?> get props => [stattrak];
}

class FilterBySouvenir extends SkinsListEvent {
  final bool? souvenir;
  const FilterBySouvenir(this.souvenir);

  @override
  List<Object?> get props => [souvenir];
}

class ClearAllFilters extends SkinsListEvent {}
