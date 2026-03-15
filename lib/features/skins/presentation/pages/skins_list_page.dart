import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_cloude/features/skins/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:test_cloude/features/skins/presentation/bloc/skins_list/skins_list_bloc.dart';
import 'package:test_cloude/features/skins/presentation/pages/skin_detail_page.dart';
import 'package:test_cloude/features/skins/presentation/widgets/filter_bottom_sheet.dart';
import 'package:test_cloude/features/skins/presentation/widgets/pagination_bar.dart';
import 'package:test_cloude/features/skins/presentation/widgets/rarity_filter_chips.dart';
import 'package:test_cloude/features/skins/presentation/widgets/skin_card.dart';

class SkinsListPage extends StatefulWidget {
  const SkinsListPage({super.key});

  @override
  State<SkinsListPage> createState() => _SkinsListPageState();
}

class _SkinsListPageState extends State<SkinsListPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    context.read<SkinsListBloc>().add(GoToPage(page));
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search + filter button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search skins...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              context
                                  .read<SkinsListBloc>()
                                  .add(const SearchSkins(''));
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (query) {
                    context.read<SkinsListBloc>().add(SearchSkins(query));
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 8),
              BlocBuilder<SkinsListBloc, SkinsListState>(
                buildWhen: (prev, curr) =>
                    curr is SkinsListLoaded &&
                    (prev is! SkinsListLoaded ||
                        prev.hasActiveFilters != curr.hasActiveFilters),
                builder: (context, state) {
                  final hasFilters =
                      state is SkinsListLoaded && state.hasActiveFilters;
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () => FilterBottomSheet.show(context),
                        icon: const Icon(Icons.tune, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      if (hasFilters)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE94560),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        // Rarity quick-filter chips
        BlocBuilder<SkinsListBloc, SkinsListState>(
          buildWhen: (prev, curr) =>
              curr is SkinsListLoaded &&
              (prev is! SkinsListLoaded ||
                  prev.rarities != curr.rarities ||
                  prev.currentRarity != curr.currentRarity),
          builder: (context, state) {
            if (state is SkinsListLoaded && state.rarities.isNotEmpty) {
              return RarityFilterChips(
                rarities: state.rarities,
                selected: state.currentRarity,
                onSelected: (rarity) {
                  context.read<SkinsListBloc>().add(FilterByRarity(rarity));
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Count + page info + clear filters
        BlocBuilder<SkinsListBloc, SkinsListState>(
          builder: (context, state) {
            if (state is SkinsListLoaded) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.totalCount} skins  •  Page ${state.currentPage}/${state.totalPages}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    if (state.hasActiveFilters)
                      GestureDetector(
                        onTap: () {
                          context
                              .read<SkinsListBloc>()
                              .add(ClearAllFilters());
                          _searchController.clear();
                          setState(() {});
                        },
                        child: const Text(
                          'Clear filters',
                          style: TextStyle(
                              color: Color(0xFFE94560), fontSize: 13),
                        ),
                      ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Grid + pagination inside scroll
        Expanded(
          child: BlocBuilder<SkinsListBloc, SkinsListState>(
            builder: (context, state) {
              if (state is SkinsListLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SkinsListError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<SkinsListBloc>().add(LoadSkins());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is SkinsListLoaded) {
                if (state.skins.isEmpty) {
                  return const Center(
                    child: Text(
                      'No skins found',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, favState) {
                    final favoriteIds = favState is FavoritesLoaded
                        ? favState.favoriteIds
                        : <String>{};

                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final skin = state.skins[index];
                                return SkinCard(
                                  skin: skin,
                                  isFavorite:
                                      favoriteIds.contains(skin.id),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SkinDetailPage(skin: skin),
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
                              childCount: state.skins.length,
                            ),
                          ),
                        ),
                        if (state.totalPages > 1)
                          SliverToBoxAdapter(
                            child: PaginationBar(
                              currentPage: state.currentPage,
                              totalPages: state.totalPages,
                              onPageSelected: _goToPage,
                            ),
                          ),
                      ],
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
