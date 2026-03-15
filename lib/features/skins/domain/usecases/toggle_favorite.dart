import 'package:dartz/dartz.dart';
import 'package:test_cloude/core/error/failures.dart';
import 'package:test_cloude/core/usecases/usecase.dart';
import 'package:test_cloude/features/skins/domain/entities/skin_entity.dart';
import 'package:test_cloude/features/skins/domain/repositories/skins_repository.dart';

class AddToFavorites extends UseCase<void, SkinEntity> {
  final SkinsRepository repository;

  AddToFavorites(this.repository);

  @override
  Future<Either<Failure, void>> call(SkinEntity params) {
    return repository.addToFavorites(params);
  }
}

class RemoveFromFavorites extends UseCase<void, String> {
  final SkinsRepository repository;

  RemoveFromFavorites(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.removeFromFavorites(params);
  }
}

class GetFavorites extends UseCase<List<SkinEntity>, NoParams> {
  final SkinsRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, List<SkinEntity>>> call(NoParams params) {
    return repository.getFavorites();
  }
}
