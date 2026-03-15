import 'package:dartz/dartz.dart';
import 'package:test_cloude/core/error/failures.dart';
import 'package:test_cloude/features/skins/domain/entities/skin_entity.dart';

abstract class SkinsRepository {
  Future<Either<Failure, List<SkinEntity>>> getAllSkins();
  Future<Either<Failure, List<SkinEntity>>> getFavorites();
  Future<Either<Failure, void>> addToFavorites(SkinEntity skin);
  Future<Either<Failure, void>> removeFromFavorites(String skinId);
  Future<Either<Failure, bool>> isFavorite(String skinId);
}
