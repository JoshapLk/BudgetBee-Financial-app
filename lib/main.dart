import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/add_goal_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const BudgetBeeApp());
}

class BudgetBeeApp extends StatelessWidget {
  const BudgetBeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'BudgetBee',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode:
                themeProvider.themeMode == AppThemeMode.system
                    ? ThemeMode.system
                    : themeProvider.themeMode == AppThemeMode.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
            home: const MainNavigationScreen(),
            routes: {
              '/main': (context) => const MainNavigationScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/transactions': (context) => const AddTransactionScreen(),
              '/add-transaction': (context) => const AddTransactionScreen(),
              '/add-goal': (context) => const AddGoalScreen(),
              '/settings': (context) => const SettingsScreen(),
              // Add other routes here
            },
            onGenerateRoute: (settings) {
              // Handle deep linking or custom routes here
              return null;
            },
          );
        },
      ),
    );
  }
}
