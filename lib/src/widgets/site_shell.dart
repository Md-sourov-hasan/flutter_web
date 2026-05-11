import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../navigation/site_navigation.dart';
import '../theme/app_theme.dart';

class SiteShell extends StatelessWidget {
  const SiteShell({
    super.key,
    required this.currentRoute,
    required this.hero,
    required this.sections,
    this.primaryGlow = const Color(0xFFFFB067),
    this.secondaryGlow = const Color(0xFFB5683B),
  });

  final String currentRoute;
  final Widget hero;
  final List<Widget> sections;
  final Color primaryGlow;
  final Color secondaryGlow;

  static const navItems = [
    _NavItem('Home', '/'),
    _NavItem('Services', '/services'),
    _NavItem('Work', '/work'),
    _NavItem('Contact', '/contact'),
  ];

  @override
  Widget build(BuildContext context) {
    return buildFrame();
  }

  Widget buildFrame({Widget? content}) {
    return _SiteShellFrame(
      currentRoute: currentRoute,
      primaryGlow: primaryGlow,
      secondaryGlow: secondaryGlow,
      content: content ?? buildScrollableContent(),
    );
  }

  Widget buildScrollableContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollReveal(
                delay: const Duration(milliseconds: 40),
                child: hero,
              ),
              for (var i = 0; i < sections.length; i++) ...[
                const SizedBox(height: 26),
                ScrollReveal(
                  delay: Duration(milliseconds: 120 + (i * 90)),
                  child: sections[i],
                ),
              ],
              const SizedBox(height: 26),
              const ScrollReveal(
                delay: Duration(milliseconds: 260),
                child: _FooterBand(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SiteShellFrame extends StatefulWidget {
  const _SiteShellFrame({
    required this.currentRoute,
    required this.primaryGlow,
    required this.secondaryGlow,
    required this.content,
  });

  final String currentRoute;
  final Color primaryGlow;
  final Color secondaryGlow;
  final Widget content;

  @override
  State<_SiteShellFrame> createState() => _SiteShellFrameState();
}

class _SiteShellFrameState extends State<_SiteShellFrame> with SingleTickerProviderStateMixin {
  late final AnimationController _ambientController;
  bool _navVisible = true;
  bool _commandPanelOpen = false;
  bool _pointerVisible = false;
  Offset _pointerPosition = Offset.zero;
  double _scrollProgress = 0;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }

    final maxScrollExtent = notification.metrics.maxScrollExtent;
    final nextProgress = maxScrollExtent <= 0 ? 0.0 : (notification.metrics.pixels / maxScrollExtent).clamp(0.0, 1.0);
    if ((nextProgress - _scrollProgress).abs() > 0.001 && mounted) {
      setState(() => _scrollProgress = nextProgress);
    }

    if (notification is UserScrollNotification) {
      if (notification.metrics.pixels <= 8) {
        _setNavVisible(true);
        return false;
      }

      if (notification.direction == ScrollDirection.forward) {
        _setNavVisible(true);
      } else if (notification.direction == ScrollDirection.reverse) {
        _setNavVisible(false);
      }
    }

    return false;
  }

  void _setNavVisible(bool visible) {
    if (_navVisible == visible || !mounted) {
      return;
    }
    setState(() => _navVisible = visible);
  }

  void _toggleCommandPanel() {
    if (!mounted) {
      return;
    }
    setState(() => _commandPanelOpen = !_commandPanelOpen);
  }

  void _handlePointerHover(PointerHoverEvent event) {
    if (!mounted) {
      return;
    }

    setState(() {
      _pointerVisible = true;
      _pointerPosition = event.localPosition;
    });
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (!_pointerVisible || !mounted) {
      return;
    }

    setState(() => _pointerVisible = false);
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shellSignal = _resolveShellSignal(widget.currentRoute);
    final currentLabel = SiteShell.navItems
        .firstWhere(
          (item) => item.route == widget.currentRoute,
          orElse: () => SiteShell.navItems.first,
        )
        .label;
    final wideLayout = MediaQuery.sizeOf(context).width > 1180;

    return Scaffold(
      body: MouseRegion(
        onHover: _handlePointerHover,
        onExit: _handlePointerExit,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.background, AppTheme.backgroundSoft],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.88, -0.92),
                          radius: 0.34,
                          colors: [
                            widget.primaryGlow.withValues(alpha: 0.26),
                            widget.primaryGlow.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(-0.95, -0.1),
                          radius: 0.28,
                          colors: [
                            widget.secondaryGlow.withValues(alpha: 0.21),
                            widget.secondaryGlow.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: _AmbientMotionLayer(
                      animation: _ambientController,
                    ),
                  ),
                ),
                Positioned(
                  top: -140,
                  right: -60,
                  child: AnimatedBuilder(
                    animation: _ambientController,
                    builder: (context, child) {
                      final y = math.sin(_ambientController.value * math.pi * 2) * 20;
                      return Transform.translate(
                        offset: Offset(0, y),
                        child: child,
                      );
                    },
                    child: _GlowOrb(
                      size: 320,
                      colors: [
                        widget.primaryGlow.withValues(alpha: 0.28),
                        widget.primaryGlow.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: -100,
                  top: 220,
                  child: AnimatedBuilder(
                    animation: _ambientController,
                    builder: (context, child) {
                      final y = math.cos(_ambientController.value * math.pi * 2) * 16;
                      return Transform.translate(
                        offset: Offset(0, y),
                        child: child,
                      );
                    },
                    child: _GlowOrb(
                      size: 240,
                      colors: [
                        widget.secondaryGlow.withValues(alpha: 0.15),
                        widget.secondaryGlow.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
                NotificationListener<ScrollNotification>(
                  onNotification: _handleScrollNotification,
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        reverseDuration: const Duration(milliseconds: 200),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          final offsetAnimation = Tween<Offset>(
                            begin: const Offset(0, -0.18),
                            end: Offset.zero,
                          ).animate(animation);

                          return FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              axisAlignment: -1,
                              child: SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: _navVisible
                            ? Padding(
                                key: const ValueKey('nav-visible'),
                                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 1180),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: _TopNavigation(currentRoute: widget.currentRoute),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(
                                key: ValueKey('nav-hidden'),
                              ),
                      ),
                      Expanded(child: widget.content),
                    ],
                  ),
                ),
                if (wideLayout)
                  Positioned(
                    left: 18,
                    top: 132,
                    bottom: 34,
                    child: _ScrollProgressRail(
                      progress: _scrollProgress,
                      routeLabel: currentLabel,
                    ),
                  ),
                Positioned(
                  left: 18,
                  bottom: 18,
                  child: _CommandPanelToggle(
                    open: _commandPanelOpen,
                    onTap: _toggleCommandPanel,
                  ),
                ),
                Positioned(
                  left: 18,
                  bottom: 86,
                  child: _ShellCommandPanel(
                    open: _commandPanelOpen,
                    signal: shellSignal,
                    currentRoute: widget.currentRoute,
                  ),
                ),
                Positioned(
                  right: 18,
                  bottom: 18,
                  child: _RouteSignalDock(
                    currentRoute: widget.currentRoute,
                    currentLabel: currentLabel,
                    progress: _scrollProgress,
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: _PointerAura(
                      visible: _pointerVisible && wideLayout,
                      position: _pointerPosition,
                      color: widget.primaryGlow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_ShellSignal _resolveShellSignal(String route) {
  return switch (route) {
    '/services' => const _ShellSignal(
      title: 'System Build Active',
      caption: 'Current route is tuned around structure, scope logic, and implementation planning.',
      points: [
        'Positioning sequence is being mapped.',
        'Page architecture is the main UI signal here.',
        'Use the route chips to jump between proof and contact.',
      ],
    ),
    '/work' => const _ShellSignal(
      title: 'Proof Layer Active',
      caption: 'This route is focused on perception shifts and before/after trust movement.',
      points: [
        'Compare structure shifts in the work lab.',
        'Notice how proof appears earlier in the flow.',
        'Use the dock to jump back to services or contact.',
      ],
    ),
    '/contact' => const _ShellSignal(
      title: 'Conversation Layer Active',
      caption: 'This route is tuned for faster project fit decisions and clearer inquiry entry.',
      points: [
        'Try the scope simulator to frame the first call.',
        'Response deck shows the expected engagement signals.',
        'Use direct paths for faster follow-up.',
      ],
    ),
    _ => const _ShellSignal(
      title: 'Narrative Core Active',
      caption: 'Home is optimized around first impression, visual rhythm, and category-shift positioning.',
      points: [
        'Signal console shows the internal build logic.',
        'Scroll progress rail mirrors page pacing.',
        'Use route dock for a guided walkthrough.',
      ],
    ),
  };
}

class _ShellSignal {
  const _ShellSignal({
    required this.title,
    required this.caption,
    required this.points,
  });

  final String title;
  final String caption;
  final List<String> points;
}

class _CommandPanelToggle extends StatefulWidget {
  const _CommandPanelToggle({
    required this.open,
    required this.onTap,
  });

  final bool open;
  final VoidCallback onTap;

  @override
  State<_CommandPanelToggle> createState() => _CommandPanelToggleState();
}

class _CommandPanelToggleState extends State<_CommandPanelToggle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xD9162235),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.lineLight),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: _hovered ? 0.22 : 0.1),
                blurRadius: _hovered ? 28 : 16,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.open ? Icons.close_rounded : Icons.tune_rounded,
                size: 18,
                color: AppTheme.accentSoft,
              ),
              const SizedBox(width: 10),
              Text(
                widget.open ? 'Close Panel' : 'Signal Panel',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShellCommandPanel extends StatelessWidget {
  const _ShellCommandPanel({
    required this.open,
    required this.signal,
    required this.currentRoute,
  });

  final bool open;
  final _ShellSignal signal;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !open,
      child: AnimatedSlide(
        offset: open ? Offset.zero : const Offset(-0.08, 0.08),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: open ? 1 : 0,
          duration: const Duration(milliseconds: 180),
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xE1162235),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppTheme.lineLight),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2607111F),
                  blurRadius: 30,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.space_dashboard_rounded,
                      color: AppTheme.accentStrong,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Route Intelligence',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  signal.title,
                  style: const TextStyle(
                    color: AppTheme.accentSoft,
                    fontSize: 24,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  signal.caption,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                for (final point in signal.points) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 7),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accentStrong,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (point != signal.points.last) const SizedBox(height: 10),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final item in SiteShell.navItems)
                      _DockRouteChip(
                        label: item.label,
                        selected: currentRoute == item.route,
                        onTap: () => navigateToRoute(context, item.route),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrollProgressRail extends StatelessWidget {
  const _ScrollProgressRail({
    required this.progress,
    required this.routeLabel,
  });

  final double progress;
  final String routeLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            routeLabel.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.textDarkMuted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: Container(
            width: 18,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppTheme.lineDark),
            ),
            child: Align(
              alignment: Alignment(0, (progress * 2) - 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 8,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.accentStrong, AppTheme.accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.34),
                      blurRadius: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${(progress * 100).round()}%',
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _RouteSignalDock extends StatelessWidget {
  const _RouteSignalDock({
    required this.currentRoute,
    required this.currentLabel,
    required this.progress,
  });

  final String currentRoute;
  final String currentLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xD9162235),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.lineLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2607111F),
            blurRadius: 26,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppTheme.accentStrong,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  currentLabel,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Scroll sync ${(progress * 100).round()}%',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in SiteShell.navItems)
                  _DockRouteChip(
                    label: item.label,
                    selected: currentRoute == item.route,
                    onTap: () => navigateToRoute(context, item.route),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DockRouteChip extends StatefulWidget {
  const _DockRouteChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_DockRouteChip> createState() => _DockRouteChipState();
}

class _DockRouteChipState extends State<_DockRouteChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppTheme.accent.withValues(alpha: 0.16)
                : Colors.white.withValues(alpha: _hovered ? 0.07 : 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.selected ? AppTheme.accent.withValues(alpha: 0.34) : AppTheme.lineLight,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.selected ? AppTheme.accentSoft : AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _PointerAura extends StatelessWidget {
  const _PointerAura({
    required this.visible,
    required this.position,
    required this.color,
  });

  final bool visible;
  final Offset position;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 140),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOutCubic,
            left: position.dx - 110,
            top: position.dy - 110,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.14),
                    color.withValues(alpha: 0.04),
                    color.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 60),
            curve: Curves.easeOut,
            left: position.dx - 7,
            top: position.dy - 7,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentStrong.withValues(alpha: 0.9),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.34),
                    blurRadius: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientMotionLayer extends StatelessWidget {
  const _AmbientMotionLayer({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value;
        final beamX = (progress * 1.6) - 0.35;
        final beamY = math.sin(progress * math.pi * 2) * 34;
        final orbOffset = math.cos(progress * math.pi * 2) * 22;

        return Stack(
          children: [
            Positioned(
              top: 90 + orbOffset,
              right: 80,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accentStrong.withValues(alpha: 0.12),
                      AppTheme.accentStrong.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(beamX * MediaQuery.sizeOf(context).width, beamY),
              child: Align(
                alignment: Alignment.topLeft,
                child: Transform.rotate(
                  angle: -0.42,
                  child: Container(
                    width: 140,
                    height: MediaQuery.sizeOf(context).height * 1.25,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0.05),
                          AppTheme.accentSoft.withValues(alpha: 0.18),
                          Colors.white.withValues(alpha: 0.04),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.accentSoft.withValues(alpha: 0.03),
                      Colors.transparent,
                      AppTheme.accent.withValues(alpha: 0.025),
                    ],
                    stops: const [0, 0.45, 1],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = const Offset(0, 0.12),
    this.triggerFraction = 0.92,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset slideOffset;
  final double triggerFraction;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  final GlobalKey _childKey = GlobalKey();
  ScrollPosition? _scrollPosition;
  Timer? _revealTimer;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextPosition = Scrollable.maybeOf(context)?.position;
    if (_scrollPosition == nextPosition) {
      return;
    }

    _scrollPosition?.removeListener(_checkVisibility);
    _scrollPosition = nextPosition;
    _scrollPosition?.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_checkVisibility);
    _revealTimer?.cancel();
    super.dispose();
  }

  void _checkVisibility() {
    if (_revealed || !mounted) {
      return;
    }

    final renderObject = _childKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return;
    }

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final top = renderObject.localToGlobal(Offset.zero).dy;
    if (top > viewportHeight * widget.triggerFraction) {
      return;
    }

    _scrollPosition?.removeListener(_checkVisibility);
    _revealTimer?.cancel();
    _revealTimer = Timer(widget.delay, () {
      if (!mounted || _revealed) {
        return;
      }
      setState(() => _revealed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _childKey,
      child: AnimatedOpacity(
        opacity: _revealed ? 1 : 0,
        duration: widget.duration,
        curve: widget.curve,
        child: AnimatedSlide(
          offset: _revealed ? Offset.zero : widget.slideOffset,
          duration: widget.duration,
          curve: widget.curve,
          child: widget.child,
        ),
      ),
    );
  }
}

class _TopNavigation extends StatelessWidget {
  const _TopNavigation({required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 920;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xB8162235),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.lineLight),
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _BrandLockup(),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final item in SiteShell.navItems)
                          _NavChip(
                            item: item,
                            selected: currentRoute == item.route,
                          ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    const Expanded(child: _BrandLockup()),
                    Wrap(
                      spacing: 10,
                      children: [
                        for (final item in SiteShell.navItems)
                          _NavChip(
                            item: item,
                            selected: currentRoute == item.route,
                          ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [AppTheme.accent, AppTheme.accentStrong],
            ),
          ),
          child: const Text(
            'J',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jasper Atelier',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Professional web systems',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip({required this.item, required this.selected});

  final _NavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (ModalRoute.of(context)?.settings.name == item.route) {
          return;
        }
        navigateToRoute(context, item.route);
      },
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent.withValues(alpha: 0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppTheme.accent.withValues(alpha: 0.28) : AppTheme.lineLight,
          ),
        ),
        child: Text(
          item.label,
          style: TextStyle(
            color: selected ? AppTheme.accentSoft : AppTheme.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _FooterBand extends StatelessWidget {
  const _FooterBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xB3162235),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.lineLight),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 860;
          final content = [
            const _FooterBlock(
              title: 'Jasper Atelier',
              copy:
                  'High-end multipage websites with stronger positioning, sharper visual systems, and cleaner launch structure.',
            ),
            const _FooterLinks(),
            const _FooterBlock(
              title: 'Direct',
              copy: 'hello@jasperatelier.dev\nWhatsApp consultation available',
            ),
          ];

          return compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < content.length; i++) ...[
                      content[i],
                      if (i != content.length - 1) const SizedBox(height: 18),
                    ],
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: content[0]),
                    const SizedBox(width: 22),
                    Expanded(child: content[1]),
                    const SizedBox(width: 22),
                    Expanded(child: content[2]),
                  ],
                );
        },
      ),
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  @override
  Widget build(BuildContext context) {
    return const _FooterBlock(
      title: 'Pages',
      copy: 'Home\nServices\nWork\nContact',
    );
  }
}

class _FooterBlock extends StatelessWidget {
  const _FooterBlock({required this.title, required this.copy});

  final String title;
  final String copy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          copy,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 14,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.route);

  final String label;
  final String route;
}
