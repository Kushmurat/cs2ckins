import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_cloude/core/di/injection.dart';
import 'package:test_cloude/core/theme/app_theme.dart';
import 'package:test_cloude/features/skins/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:test_cloude/features/skins/presentation/bloc/skins_list/skins_list_bloc.dart';
import 'package:test_cloude/features/skins/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  initDependencies();
  runApp(const CS2SkinsApp());
}

class CS2SkinsApp extends StatelessWidget {
  const CS2SkinsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<SkinsListBloc>()..add(LoadSkins()),
        ),
        BlocProvider(
          create: (_) => sl<FavoritesBloc>()..add(LoadFavorites()),
        ),
      ],
      child: MaterialApp(
        title: 'CS2 Skins',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
