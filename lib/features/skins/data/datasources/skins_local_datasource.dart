import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:test_cloude/core/error/exceptions.dart';
import 'package:test_cloude/features/skins/data/models/skin_model.dart';

abstract class SkinsLocalDataSource {
  Future<List<SkinModel>> getCachedSkins();
  Future<void> cacheSkins(List<SkinModel> skins);
  Future<List<SkinModel>> getFavorites();
  Future<void> addToFavorites(SkinModel skin);
  Future<void> removeFromFavorites(String skinId);
  Future<bool> isFavorite(String skinId);
}

class SkinsLocalDataSourceImpl implements SkinsLocalDataSource {
  static const String _skinsCacheBox = 'skins_cache';
  static const String _favoritesBox = 'favorites';
  static const String _skinsKey = 'cached_skins';

  @override
  Future<List<SkinModel>> getCachedSkins() async {
    try {
      final box = await Hive.openBox(_skinsCacheBox);
      final jsonString = box.get(_skinsKey) as String?;
      if (jsonString == null) return [];
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((j) => SkinModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw const CacheException('Failed to read cached skins');
    }
  }

  @override
  Future<void> cacheSkins(List<SkinModel> skins) async {
    try {
      final box = await Hive.openBox(_skinsCacheBox);
      final jsonString =
          json.encode(skins.map((s) => s.toJson()).toList());
      await box.put(_skinsKey, jsonString);
    } catch (e) {
      throw const CacheException('Failed to cache skins');
    }
  }

  @override
  Future<List<SkinModel>> getFavorites() async {
    try {
      final box = await Hive.openBox(_favoritesBox);
      final List<SkinModel> favorites = [];
      for (final key in box.keys) {
        final jsonString = box.get(key) as String?;
        if (jsonString != null) {
          favorites.add(
            SkinModel.fromJson(
              json.decode(jsonString) as Map<String, dynamic>,
            ),
          );
        }
      }
      return favorites;
    } catch (e) {
      throw const CacheException('Failed to read favorites');
    }
  }

  @override
  Future<void> addToFavorites(SkinModel skin) async {
    try {
      final box = await Hive.openBox(_favoritesBox);
      await box.put(skin.id, json.encode(skin.toJson()));
    } catch (e) {
      throw const CacheException('Failed to add to favorites');
    }
  }

  @override
  Future<void> removeFromFavorites(String skinId) async {
    try {
      final box = await Hive.openBox(_favoritesBox);
      await box.delete(skinId);
    } catch (e) {
      throw const CacheException('Failed to remove from favorites');
    }
  }

  @override
  Future<bool> isFavorite(String skinId) async {
    try {
      final box = await Hive.openBox(_favoritesBox);
      return box.containsKey(skinId);
    } catch (e) {
      throw const CacheException('Failed to check favorite status');
    }
  }
}
