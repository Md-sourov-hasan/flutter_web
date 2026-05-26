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
    _bootTimer = Timer(const Duration(milliseconds: 2800), () {
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
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                child: const RocketLaunchSplash(),
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

class RocketLaunchSplash extends StatefulWidget {
  const RocketLaunchSplash({super.key});

  @override
  State<RocketLaunchSplash> createState() => _RocketLaunchSplashState();
}

class _RocketLaunchSplashState extends State<RocketLaunchSplash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _slideAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 5.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -5.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 5),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -5.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 5),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 5),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -1200.0).chain(CurveTween(curve: Curves.easeInExpo)),
        weight: 60,
      ),
    ]).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 40),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.5).chain(CurveTween(curve: Curves.easeInExpo)),
        weight: 60,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF070B14), Color(0xFF101825), Color(0xFF04060A)],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final isLaunching = _controller.value > 0.4;
            
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow behind rocket
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isLaunching ? 1.0 : 0.0,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.6),
                                  blurRadius: 60,
                                  spreadRadius: 20,
                                ),
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.4),
                                  blurRadius: 100,
                                  spreadRadius: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.rocket_launch_rounded,
                          size: 100,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLaunching ? 0.0 : 1.0,
                      child: const Column(
                        children: [
                          Text(
                            'JASPER ATELIER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 4.0,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Preparing for launch...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
