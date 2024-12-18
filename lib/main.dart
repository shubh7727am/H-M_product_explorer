import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme_profiles.dart';
import 'core/theme/theme_provider.dart';
import 'views/home_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, WidgetRef ref, child) {
        final themeMode = ref.watch(themeProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: AppThemes.lightTheme(), // Use light theme
          darkTheme: AppThemes.darkTheme(), // Use dark theme
          home: const HomePage(selectedIndex: 1),// main page
        );
      },
    );
  }
}
