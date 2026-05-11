import 'package:flutter/material.dart';

import 'navigation/site_navigation.dart';
import 'pages/contact_page.dart';
import 'pages/home_page.dart';
import 'pages/services_page.dart';
import 'pages/work_page.dart';
import 'theme/app_theme.dart';
import 'widgets/site_shell.dart';

class JasperAtelierApp extends StatelessWidget {
  const JasperAtelierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jasper Atelier',
      theme: AppTheme.theme,
      initialRoute: HomePage.routeName,
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: (settings) => _buildRoute(
        settings: const RouteSettings(name: HomePage.routeName),
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    return _buildRoute(settings: settings);
  }

  PageRouteBuilder<void> _buildRoute({required RouteSettings settings}) {
    final routeName = settings.name ?? HomePage.routeName;
    final fromRoute = switch (settings.arguments) {
      SiteRouteArguments args => args.fromRoute,
      _ => null,
    };
    final beginOffset = resolveRouteTransitionOffset(fromRoute, routeName);

    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 520),
      reverseTransitionDuration: const Duration(milliseconds: 420),
      pageBuilder: (context, animation, secondaryAnimation) => switch (routeName) {
        ServicesPage.routeName => const ServicesPage(),
        WorkPage.routeName => const WorkPage(),
        ContactPage.routeName => const ContactPage(),
        _ => const HomePage(),
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        if (child is! SiteShell) {
          return child;
        }

        final animatedContent = FadeTransition(
          opacity: Tween<double>(
            begin: 0.7,
            end: 1,
          ).animate(curvedAnimation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.985,
                end: 1,
              ).animate(curvedAnimation),
              child: child.buildScrollableContent(),
            ),
          ),
        );

        return child.buildFrame(content: animatedContent);
      },
    );
  }
}
