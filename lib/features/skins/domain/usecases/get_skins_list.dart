import 'package:dartz/dartz.dart';
import 'package:test_cloude/core/error/failures.dart';
import 'package:test_cloude/core/usecases/usecase.dart';
import 'package:test_cloude/features/skins/domain/entities/skin_entity.dart';
import 'package:test_cloude/features/skins/domain/repositories/skins_repository.dart';

class GetSkinsList extends UseCase<List<SkinEntity>, NoParams> {
  final SkinsRepository repository;

  GetSkinsList(this.repository);

  @override
  Future<Either<Failure, List<SkinEntity>>> call(NoParams params) {
    return repository.getAllSkins();
  }
}
