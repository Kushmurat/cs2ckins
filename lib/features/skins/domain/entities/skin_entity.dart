import 'package:equatable/equatable.dart';

class SkinEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? image;
  final WeaponInfo? weapon;
  final CategoryInfo? category;
  final PatternInfo? pattern;
  final RarityInfo? rarity;
  final double? minFloat;
  final double? maxFloat;
  final bool stattrak;
  final bool souvenir;
  final List<WearInfo> wears;
  final List<CollectionInfo> collections;
  final List<CrateInfo> crates;

  const SkinEntity({
    required this.id,
    required this.name,
    this.description = '',
    this.image,
    this.weapon,
    this.category,
    this.pattern,
    this.rarity,
    this.minFloat,
    this.maxFloat,
    this.stattrak = false,
    this.souvenir = false,
    this.wears = const [],
    this.collections = const [],
    this.crates = const [],
  });

  @override
  List<Object?> get props => [id];
}

class WeaponInfo extends Equatable {
  final String id;
  final String name;

  const WeaponInfo({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class CategoryInfo extends Equatable {
  final String id;
  final String name;

  const CategoryInfo({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class PatternInfo extends Equatable {
  final String id;
  final String name;

  const PatternInfo({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class RarityInfo extends Equatable {
  final String id;
  final String name;
  final String color;

  const RarityInfo({
    required this.id,
    required this.name,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, color];
}

class WearInfo extends Equatable {
  final String id;
  final String name;

  const WearInfo({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class CollectionInfo extends Equatable {
  final String id;
  final String name;
  final String? image;

  const CollectionInfo({required this.id, required this.name, this.image});

  @override
  List<Object?> get props => [id, name];
}

class CrateInfo extends Equatable {
  final String id;
  final String name;
  final String? image;

  const CrateInfo({required this.id, required this.name, this.image});

  @override
  List<Object?> get props => [id, name];
}
