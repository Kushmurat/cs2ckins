import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:test_cloude/features/skins/data/datasources/skins_local_datasource.dart';
import 'package:test_cloude/features/skins/data/datasources/skins_remote_datasource.dart';
import 'package:test_cloude/features/skins/data/repositories/skins_repository_impl.dart';
import 'package:test_cloude/features/skins/domain/repositories/skins_repository.dart';
import 'package:test_cloude/features/skins/domain/usecases/get_skins_list.dart';
import 'package:test_cloude/features/skins/domain/usecases/toggle_favorite.dart';
import 'package:test_cloude/features/skins/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:test_cloude/features/skins/presentation/bloc/skins_list/skins_list_bloc.dart';

final sl = GetIt.instance;

void initDependencies() {
  // External
  sl.registerLazySingleton<Dio>(() => Dio());

  // Data Sources
  sl.registerLazySingleton<SkinsRemoteDataSource>(
    () => SkinsRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<SkinsLocalDataSource>(
    () => SkinsLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<SkinsRepository>(
    () => SkinsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetSkinsList(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddToFavorites(sl()));
  sl.registerLazySingleton(() => RemoveFromFavorites(sl()));

  // BLoC
  sl.registerFactory(() => SkinsListBloc(getSkinsList: sl()));
  sl.registerFactory(
    () => FavoritesBloc(
      getFavorites: sl(),
      addToFavorites: sl(),
      removeFromFavorites: sl(),
    ),
  );
}
