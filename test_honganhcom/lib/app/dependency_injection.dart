import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/constants/api_constants.dart';
import '../features/products/data/datasources/product_remote_data_source.dart';
import '../features/products/data/repositories/product_repository_impl.dart';
import '../features/products/domain/repositories/product_repository.dart';
import '../features/products/domain/use_cases/get_products_page_use_case.dart';
import '../features/products/presentation/bloc/product_list_bloc.dart';

/// Global service locator (register once before [runApp]).
final GetIt getIt = GetIt.instance;

/// Registers all app dependencies. Call from [main] after [WidgetsFlutterBinding.ensureInitialized].
void configureDependencies() {
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {
          'Accept': 'application/json',
        },
      ),
    ),
  );

  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<GetProductsPageUseCase>(
    () => GetProductsPageUseCase(getIt()),
  );

  getIt.registerLazySingleton<ProductListBloc>(
    () => ProductListBloc(getProductsPage: getIt()),
  );
}
