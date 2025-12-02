import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/cat_datasource.dart';
import 'data/repositories/cat_repository_impl.dart';
import 'domain/usescases/get_cat_usecases.dart';
import 'presentation/viewmodels/cat_viewmodel.dart';
import 'presentation/views/home_page.dart';
import 'utils/themes/general_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final dataSource = CatRemoteDataSource();
            final repository = CatRepositoryImpl(dataSource);
            final getCatsUseCase = GetCatsUseCase(repository);
            final searchCatsUseCase = SearchCatsUseCase(repository);
            return CatViewModel(
              getCatsUseCase: getCatsUseCase,
              searchCatsUseCase: searchCatsUseCase,
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Cat App',
        debugShowCheckedModeBanner: false,
        theme: GeneralTheme.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
