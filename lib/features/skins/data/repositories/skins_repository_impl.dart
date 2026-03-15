import 'package:dartz/dartz.dart';
import 'package:test_cloude/core/error/exceptions.dart';
import 'package:test_cloude/core/error/failures.dart';
import 'package:test_cloude/features/skins/data/datasources/skins_local_datasource.dart';
import 'package:test_cloude/features/skins/data/datasources/skins_remote_datasource.dart';
import 'package:test_cloude/features/skins/data/models/skin_model.dart';
import 'package:test_cloude/features/skins/domain/entities/skin_entity.dart';
import 'package:test_cloude/features/skins/domain/repositories/skins_repository.dart';

class SkinsRepositoryImpl implements SkinsRepository {
  final SkinsRemoteDataSource remoteDataSource;
  final SkinsLocalDataSource localDataSource;

  SkinsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<SkinEntity>>> getAllSkins() async {
    try {
      // Try cache first
      final cachedSkins = await localDataSource.getCachedSkins();
      if (cachedSkins.isNotEmpty) {
        return Right(cachedSkins);
      }
    } catch (_) {}

    // Fetch from remote
    try {
      final remoteSkins = await remoteDataSource.getSkins();
      // Cache for future use
      try {
        await localDataSource.cacheSkins(remoteSkins);
      } catch (_) {}
      return Right(remoteSkins);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SkinEntity>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(SkinEntity skin) async {
    try {
      await localDataSource.addToFavorites(SkinModel.fromEntity(skin));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String skinId) async {
    try {
      await localDataSource.removeFromFavorites(skinId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String skinId) async {
    try {
      final result = await localDataSource.isFavorite(skinId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
