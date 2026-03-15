import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_cloude/core/usecases/usecase.dart';
import 'package:test_cloude/features/skins/domain/entities/skin_entity.dart';
import 'package:test_cloude/features/skins/domain/usecases/get_skins_list.dart';

part 'skins_list_event.dart';
part 'skins_list_state.dart';

class SkinsListBloc extends Bloc<SkinsListEvent, SkinsListState> {
  final GetSkinsList getSkinsList;

  static const int _pageSize = 30;
  List<SkinEntity> _allSkins = [];
  List<SkinEntity> _filteredSkins = [];
  String _searchQuery = '';
  String? _rarityFilter;
  String? _weaponFilter;
  String? _categoryFilter;
  bool? _stattrakFilter;
  bool? _souvenirFilter;
  int _currentPage = 1;

  SkinsListBloc({required this.getSkinsList}) : super(SkinsListInitial()) {
    on<LoadSkins>(_onLoadSkins);
    on<GoToPage>(_onGoToPage);
    on<SearchSkins>(_onSearchSkins);
    on<FilterByRarity>(_onFilterByRarity);
    on<FilterByWeapon>(_onFilterByWeapon);
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByStatTrak>(_onFilterByStatTrak);
    on<FilterBySouvenir>(_onFilterBySouvenir);
    on<ClearAllFilters>(_onClearAllFilters);
  }

  Future<void> _onLoadSkins(
    LoadSkins event,
    Emitter<SkinsListState> emit,
  ) async {
    emit(SkinsListLoading());

    final result = await getSkinsList(const NoParams());

    result.fold(
      (failure) => emit(SkinsListError(failure.message)),
      (skins) {
        _allSkins = skins;
        _currentPage = 1;
        _applyFilters();
        _emitLoaded(emit);
      },
    );
  }

  void _onGoToPage(GoToPage event, Emitter<SkinsListState> emit) {
    final totalPages = (_filteredSkins.length / _pageSize).ceil();
    _currentPage = event.page.clamp(1, max(1, totalPages));
    _emitLoaded(emit);
  }

  void _onSearchSkins(SearchSkins event, Emitter<SkinsListState> emit) {
    _searchQuery = event.query.toLowerCase();
    _currentPage = 1;
    _applyFilters();
    _emitLoaded(emit);
  }

  void _onFilterByRarity(FilterByRarity event, Emitter<SkinsListState> emit) {
    _rarityFilter = event.rarity;
    _currentPage = 1;
    _applyFilters();
    _emitLoaded(emit);
  }

  void _onFilterByWeapon(FilterByWeapon event, Emitter<SkinsListState> emit) {
    _weaponFilter = event.weapon;
    _currentPage = 1;
    _applyFilters();
    _emitLoaded(emit);
  }

  void _onFilterByCategory(
      FilterByCategory event, Emitter<SkinsListState> emit) {
    _categoryFilter = event.category;
    _currentPage = 1;
    _applyFilters();
    _emitLoaded(emit);
  }

  void _onFilterByStatTrak(
      FilterByStatTrak event, Emitter<SkinsListState> emit) {
    _stattrakFilter = event.stattrak;
    _currentPage = 1;
    _applyFilters();
    _emitLoaded(emit);
  }

  void _onFilterBySouvenir(
      FilterBySouvenir event, Emitter<SkinsListState> emit) {
    _souvenirFilter = event.souvenir;
    _currentPage = 1;
    _applyFilters();
    _emitLoaded(emit);
  }

  void _onClearAllFilters(
      ClearAllFilters event, Emitter<SkinsListState> emit) {
    _searchQuery = '';
    _rarityFilter = null;
    _weaponFilter = null;
    _categoryFilter = null;
    _stattrakFilter = null;
    _souvenirFilter = null;
    _currentPage = 1;
    _applyFilters();
    _emitLoaded(emit);
  }

  void _applyFilters() {
    _filteredSkins = _allSkins.where((skin) {
      if (_searchQuery.isNotEmpty &&
          !skin.name.toLowerCase().contains(_searchQuery)) {
        return false;
      }
      if (_rarityFilter != null && skin.rarity?.name != _rarityFilter) {
        return false;
      }
      if (_weaponFilter != null && skin.weapon?.name != _weaponFilter) {
        return false;
      }
      if (_categoryFilter != null && skin.category?.name != _categoryFilter) {
        return false;
      }
      if (_stattrakFilter != null && skin.stattrak != _stattrakFilter) {
        return false;
      }
      if (_souvenirFilter != null && skin.souvenir != _souvenirFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  void _emitLoaded(Emitter<SkinsListState> emit) {
    final totalPages = max(1, (_filteredSkins.length / _pageSize).ceil());
    _currentPage = _currentPage.clamp(1, totalPages);

    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = min(startIndex + _pageSize, _filteredSkins.length);
    final pageSkins = _filteredSkins.sublist(startIndex, endIndex);

    emit(SkinsListLoaded(
      skins: pageSkins,
      totalCount: _filteredSkins.length,
      currentPage: _currentPage,
      totalPages: totalPages,
      rarities: _extractValues((s) => s.rarity?.name),
      weapons: _extractValues((s) => s.weapon?.name),
      categories: _extractValues((s) => s.category?.name),
      currentRarity: _rarityFilter,
      currentWeapon: _weaponFilter,
      currentCategory: _categoryFilter,
      stattrakFilter: _stattrakFilter,
      souvenirFilter: _souvenirFilter,
    ));
  }

  List<String> _extractValues(String? Function(SkinEntity) extractor) {
    final values = <String>{};
    for (final skin in _allSkins) {
      final value = extractor(skin);
      if (value != null && value.isNotEmpty) {
        values.add(value);
      }
    }
    return values.toList()..sort();
  }
}
