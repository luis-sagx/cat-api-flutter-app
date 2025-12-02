import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/data/datasources/cat_datasource.dart';
import 'src/data/repositories/cat_repository_impl.dart';
import 'src/domain/usescases/get_cat_usecases.dart';
import 'src/presentation/viewmodels/cat_viewmodel.dart';
import 'src/presentation/routes/app_routes.dart';
import 'src/utils/themes/general_theme.dart';

void main() {
  final datasource = CatRemoteDataSource();
  final repository = CatRepositoryImpl(datasource);
  final getCatsUseCase = GetCatsUseCase(repository);
  final searchCatsUseCase = SearchCatsUseCase(repository);

  runApp(
    MyApp(getCatsUseCase: getCatsUseCase, searchCatsUseCase: searchCatsUseCase),
  );
}

class MyApp extends StatelessWidget {
  final GetCatsUseCase getCatsUseCase;
  final SearchCatsUseCase searchCatsUseCase;

  const MyApp({
    super.key,
    required this.getCatsUseCase,
    required this.searchCatsUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CatViewModel(getCatsUseCase, searchCatsUseCase),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: "/",
        theme: GeneralTheme.lightTheme,
      ),
    );
  }
}
