import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/user_input_provider.dart';
import 'providers/meal_plan_provider.dart';
import 'providers/grocery_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/wizard/wizard_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/meal_plan/meal_plan_screen.dart';
import 'screens/recipe/recipe_screen.dart';
import 'screens/grocery/grocery_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BachatBiteApp());
}

class BachatBiteApp extends StatelessWidget {
  const BachatBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInputProvider()..init()),
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
        ChangeNotifierProvider(create: (_) => GroceryProvider()),
      ],
      child: MaterialApp(
        title: 'BachatBite — Smart Budget Food Planner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return _buildRoute(const HomeScreen(), settings);
            case '/wizard':
              return _buildRoute(const WizardScreen(), settings);
            case '/dashboard':
              return _buildRoute(const DashboardScreen(), settings);
            case '/meal-plan':
              return _buildRoute(const MealPlanScreen(), settings);
            case '/grocery':
              return _buildRoute(const GroceryScreen(), settings);
            default:
              // Handle /recipe/:id
              if (settings.name != null && settings.name!.startsWith('/recipe/')) {
                final id = settings.name!.replaceFirst('/recipe/', '');
                return _buildRoute(RecipeScreen(recipeId: id), settings);
              }
              return _buildRoute(const HomeScreen(), settings);
          }
        },
      ),
    );
  }

  PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
