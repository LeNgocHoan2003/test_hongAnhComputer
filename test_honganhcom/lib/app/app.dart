import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/products/presentation/bloc/product_list_bloc.dart';
import '../features/products/presentation/pages/product_list_page.dart';
import 'dependency_injection.dart';

class ProductCatalogApp extends StatelessWidget {
  const ProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    const buttonRadius = BorderRadius.all(Radius.circular(8));

    return BlocProvider<ProductListBloc>.value(
      value: getIt<ProductListBloc>(),
      child: MaterialApp(
        title: 'Product catalog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
          elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: buttonRadius),
              ),
            ),
          ),
          filledButtonTheme: const FilledButtonThemeData(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: buttonRadius),
              ),
            ),
          ),
          outlinedButtonTheme: const OutlinedButtonThemeData(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: buttonRadius),
              ),
            ),
          ),
          textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: buttonRadius),
              ),
            ),
          ),
        ),
        home: const ProductListPage(),
      ),
    );
  }
}
