import 'dart:async';

import 'package:flutter/material.dart';

import 'navigation/site_navigation.dart';
import 'pages/contact_page.dart';
import 'pages/entry_page.dart';
import 'pages/home_page.dart';
import 'pages/services_page.dart';
import 'pages/work_page.dart';
import 'theme/app_theme.dart';
import 'widgets/site_shell.dart';

class JasperAtelierApp extends StatefulWidget {
  const JasperAtelierApp({super.key});

  @override
  State<JasperAtelierApp> createState() => _JasperAtelierAppState();
}

class _JasperAtelierAppState extends State<JasperAtelierApp> {
  Timer? _bootTimer;
  bool _showBootOverlay = true;

  @override
  void initState() {
    super.initState();
    _bootTimer = Timer(const Duration(milliseconds: 950), () {
      if (!mounted) {
        return;
      }
      setState(() => _showBootOverlay = false);
    });
  }

  @override
  void dispose() {
    _bootTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jasper Atelier',
      theme: AppTheme.theme,
      initialRoute: EntryPage.routeName,
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: (settings) => _buildRoute(
        settings: const RouteSettings(name: EntryPage.routeName),
      ),
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            IgnorePointer(
              ignoring: !_showBootOverlay,
              child: AnimatedOpacity(
                opacity: _showBootOverlay ? 1 : 0,
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutCubic,
                child: const _BootOverlay(),
              ),
            ),
          ],
        );
      },
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
        EntryPage.routeName => const EntryPage(),
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

class _BootOverlay extends StatelessWidget {
  const _BootOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF101821), Color(0xFF162235), Color(0xFF0E141D)],
        ),
      ),
      child: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xD9162235),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.lineLight),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2607111F),
                blurRadius: 26,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'JASPER ATELIER',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Booting premium web system...',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 22),
              LinearProgressIndicator(
                minHeight: 6,
                color: AppTheme.accentStrong,
                backgroundColor: Color(0x331F2B41),
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              SizedBox(height: 16),
              Text(
                'Routing modules, visual stack, and motion layer are coming online.',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
