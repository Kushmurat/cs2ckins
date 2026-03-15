import 'package:test_cloude/features/skins/domain/entities/skin_entity.dart';

class SkinModel extends SkinEntity {
  const SkinModel({
    required super.id,
    required super.name,
    super.description,
    super.image,
    super.weapon,
    super.category,
    super.pattern,
    super.rarity,
    super.minFloat,
    super.maxFloat,
    super.stattrak,
    super.souvenir,
    super.wears,
    super.collections,
    super.crates,
  });

  factory SkinModel.fromJson(Map<String, dynamic> json) {
    return SkinModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String?,
      weapon: json['weapon'] != null
          ? WeaponInfo(
              id: json['weapon']['id'] as String? ?? '',
              name: json['weapon']['name'] as String? ?? '',
            )
          : null,
      category: json['category'] != null
          ? CategoryInfo(
              id: json['category']['id'] as String? ?? '',
              name: json['category']['name'] as String? ?? '',
            )
          : null,
      pattern: json['pattern'] != null
          ? PatternInfo(
              id: json['pattern']['id'] as String? ?? '',
              name: json['pattern']['name'] as String? ?? '',
            )
          : null,
      rarity: json['rarity'] != null
          ? RarityInfo(
              id: json['rarity']['id'] as String? ?? '',
              name: json['rarity']['name'] as String? ?? '',
              color: json['rarity']['color'] as String? ?? '#FFFFFF',
            )
          : null,
      minFloat: (json['min_float'] as num?)?.toDouble(),
      maxFloat: (json['max_float'] as num?)?.toDouble(),
      stattrak: json['stattrak'] as bool? ?? false,
      souvenir: json['souvenir'] as bool? ?? false,
      wears: (json['wears'] as List<dynamic>?)
              ?.map((w) => WearInfo(
                    id: w['id'] as String? ?? '',
                    name: w['name'] as String? ?? '',
                  ))
              .toList() ??
          [],
      collections: (json['collections'] as List<dynamic>?)
              ?.map((c) => CollectionInfo(
                    id: c['id'] as String? ?? '',
                    name: c['name'] as String? ?? '',
                    image: c['image'] as String?,
                  ))
              .toList() ??
          [],
      crates: (json['crates'] as List<dynamic>?)
              ?.map((c) => CrateInfo(
                    id: c['id'] as String? ?? '',
                    name: c['name'] as String? ?? '',
                    image: c['image'] as String?,
                  ))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'weapon': weapon != null
          ? {'id': weapon!.id, 'name': weapon!.name}
          : null,
      'category': category != null
          ? {'id': category!.id, 'name': category!.name}
          : null,
      'pattern': pattern != null
          ? {'id': pattern!.id, 'name': pattern!.name}
          : null,
      'rarity': rarity != null
          ? {'id': rarity!.id, 'name': rarity!.name, 'color': rarity!.color}
          : null,
      'min_float': minFloat,
      'max_float': maxFloat,
      'stattrak': stattrak,
      'souvenir': souvenir,
      'wears': wears.map((w) => {'id': w.id, 'name': w.name}).toList(),
      'collections': collections
          .map((c) => {'id': c.id, 'name': c.name, 'image': c.image})
          .toList(),
      'crates': crates
          .map((c) => {'id': c.id, 'name': c.name, 'image': c.image})
          .toList(),
    };
  }

  factory SkinModel.fromEntity(SkinEntity entity) {
    return SkinModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      image: entity.image,
      weapon: entity.weapon,
      category: entity.category,
      pattern: entity.pattern,
      rarity: entity.rarity,
      minFloat: entity.minFloat,
      maxFloat: entity.maxFloat,
      stattrak: entity.stattrak,
      souvenir: entity.souvenir,
      wears: entity.wears,
      collections: entity.collections,
      crates: entity.crates,
    );
  }
}
