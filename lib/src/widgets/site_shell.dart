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

class SiteBackdropFrame extends StatelessWidget {
  const SiteBackdropFrame({
    super.key,
    required this.child,
    this.routeName = '/entry',
    this.routeLabel = 'Entry',
    this.primaryGlow = const Color(0xFFFFB067),
    this.secondaryGlow = const Color(0xFFB5683B),
  });

  final Widget child;
  final String routeName;
  final String routeLabel;
  final Color primaryGlow;
  final Color secondaryGlow;

  @override
  Widget build(BuildContext context) {
    return _SiteShellFrame(
      currentRoute: routeName,
      primaryGlow: primaryGlow,
      secondaryGlow: secondaryGlow,
      routeLabelOverride: routeLabel,
      showNavigation: false,
      showProgressDecorations: false,
      content: child,
    );
  }
}

class _SiteShellFrame extends StatefulWidget {
  const _SiteShellFrame({
    required this.currentRoute,
    required this.primaryGlow,
    required this.secondaryGlow,
    required this.content,
    this.routeLabelOverride,
    this.showNavigation = true,
    this.showProgressDecorations = true,
  });

  final String currentRoute;
  final Color primaryGlow;
  final Color secondaryGlow;
  final Widget content;
  final String? routeLabelOverride;
  final bool showNavigation;
  final bool showProgressDecorations;

  @override
  State<_SiteShellFrame> createState() => _SiteShellFrameState();
}

class _SiteShellFrameState extends State<_SiteShellFrame> with SingleTickerProviderStateMixin {
  late final AnimationController _ambientController;
  late final ValueNotifier<_PointerState> _pointerNotifier;
  late final ValueNotifier<double> _scrollProgressNotifier;
  bool _navVisible = true;

  @override
  void initState() {
    super.initState();
    _pointerNotifier = ValueNotifier(const _PointerState.hidden());
    _scrollProgressNotifier = ValueNotifier(0);
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
    if ((nextProgress - _scrollProgressNotifier.value).abs() > 0.006) {
      _scrollProgressNotifier.value = nextProgress;
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

  void _handlePointerHover(PointerHoverEvent event) {
    if (!mounted) {
      return;
    }

    if (MediaQuery.sizeOf(context).width <= 1180) {
      if (_pointerNotifier.value.visible) {
        _pointerNotifier.value = const _PointerState.hidden();
      }
      return;
    }

    final current = _pointerNotifier.value;
    final delta = event.localPosition - current.position;
    if (current.visible && delta.distanceSquared < 64) {
      return;
    }

    _pointerNotifier.value = _PointerState(
      position: event.localPosition,
      visible: true,
    );
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (!_pointerNotifier.value.visible || !mounted) {
      return;
    }

    _pointerNotifier.value = const _PointerState.hidden();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _pointerNotifier.dispose();
    _scrollProgressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLabel =
        widget.routeLabelOverride ??
        SiteShell.navItems
            .firstWhere(
              (item) => item.route == widget.currentRoute,
              orElse: () => const _NavItem('Page', '/'),
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
                    child: RepaintBoundary(
                      child: _AmbientMotionLayer(
                        animation: _ambientController,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: ValueListenableBuilder<_PointerState>(
                      valueListenable: _pointerNotifier,
                      builder: (context, pointerState, child) {
                        return RepaintBoundary(
                          child: _ParticleFieldOverlay(
                            pointerPosition: pointerState.position,
                            isPointerVisible: pointerState.visible,
                          ),
                        );
                      },
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
                      if (widget.showNavigation)
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
                                alignment: const Alignment(0, -1),
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
                      Expanded(child: RepaintBoundary(child: widget.content)),
                    ],
                  ),
                ),
                if (wideLayout && widget.showProgressDecorations)
                  Positioned(
                    left: 18,
                    top: 132,
                    bottom: 34,
                    child: ValueListenableBuilder<double>(
                      valueListenable: _scrollProgressNotifier,
                      builder: (context, progress, child) {
                        return _ScrollProgressRail(
                          progress: progress,
                          routeLabel: currentLabel,
                        );
                      },
                    ),
                  ),
                if (widget.showProgressDecorations)
                  Positioned(
                    right: 18,
                    bottom: 18,
                    child: ValueListenableBuilder<double>(
                      valueListenable: _scrollProgressNotifier,
                      builder: (context, progress, child) {
                        return _RouteSignalDock(
                          currentRoute: widget.currentRoute,
                          currentLabel: currentLabel,
                          progress: progress,
                        );
                      },
                    ),
                  ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: ValueListenableBuilder<_PointerState>(
                      valueListenable: _pointerNotifier,
                      builder: (context, pointerState, child) {
                        return RepaintBoundary(
                          child: _PointerAura(
                            visible: pointerState.visible && wideLayout,
                            position: pointerState.position,
                            color: widget.primaryGlow,
                          ),
                        );
                      },
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
      duration: const Duration(milliseconds: 160),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuint,
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
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutQuint,
            left: position.dx - 20,
            top: position.dy - 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accent.withValues(alpha: 0.08),
                border: Border.all(
                  color: AppTheme.accent.withValues(alpha: 0.72),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.2),
                    blurRadius: 18,
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuint,
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
            boxShadow: const [
              BoxShadow(
                color: Color(0x1D07111F),
                blurRadius: 24,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(child: _BrandLockup()),
                        SizedBox(width: 14),
                        _TopStatusPill(),
                      ],
                    ),
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
                    const SizedBox(width: 18),
                    const _TopStatusPill(),
                    const SizedBox(width: 18),
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
        const Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jasper Atelier',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'Professional web systems',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopStatusPill extends StatelessWidget {
  const _TopStatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentSoft.withValues(alpha: 0.18),
            AppTheme.accentStrong.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x33FFE1BD)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseDot(),
          SizedBox(width: 10),
          Text(
            'Live multipage preview',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatelessWidget {
  const _PulseDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.accentStrong,
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentStrong.withValues(alpha: 0.42),
            blurRadius: 12,
          ),
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _FooterTickerChip(label: 'Strategy-first build'),
              _FooterTickerChip(label: 'Responsive layout system'),
              _FooterTickerChip(label: 'Motion-aware routing'),
            ],
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
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
        ],
      ),
    );
  }
}

class _FooterTickerChip extends StatelessWidget {
  const _FooterTickerChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.lineLight),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
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

class _PointerState {
  const _PointerState({
    required this.position,
    required this.visible,
  });

  const _PointerState.hidden() : position = Offset.zero, visible = false;

  final Offset position;
  final bool visible;
}

class _Particle {
  _Particle({
    required this.radius,
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
  }) {
    x = 0;
    y = 0;
    paint = Paint()
      ..color = color.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
  }

  double radius;
  double angle;
  double speed;
  Color color;
  double size;
  late final Paint paint;

  double x = 0;
  double y = 0;
  double vx = 0;
  double vy = 0;
}

class _ParticleFieldOverlay extends StatefulWidget {
  const _ParticleFieldOverlay({
    required this.pointerPosition,
    required this.isPointerVisible,
  });

  final Offset pointerPosition;
  final bool isPointerVisible;

  @override
  State<_ParticleFieldOverlay> createState() => _ParticleFieldOverlayState();
}

class _ParticleFieldOverlayState extends State<_ParticleFieldOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  final List<Color> _particleColors = [
    const Color(0xFF4285F4),
    const Color(0xFFEA4335),
    const Color(0xFFFBBC05),
    const Color(0xFF34A853),
    const Color(0xFF9333EA),
    const Color(0xFFFF9D5C),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _initParticles(Size size) {
    if (_particles.isNotEmpty) {
      return;
    }

    final maxRadius = math.max(size.width, size.height) * 0.7;
    final particleCount = ((size.width * size.height) / 12000).round().clamp(140, 220);
    for (int i = 0; i < particleCount; i++) {
      final r = math.pow(_random.nextDouble(), 1.5) * maxRadius;
      _particles.add(
        _Particle(
            radius: r + 20,
            angle: _random.nextDouble() * math.pi * 2,
            speed: (0.0005 + _random.nextDouble() * 0.002) * (_random.nextBool() ? 1 : -1),
            color: _particleColors[_random.nextInt(_particleColors.length)],
            size: _random.nextDouble() * 2.5 + 1.5,
          )
          ..x = (size.width / 2) + math.cos(0) * r
          ..y = (size.height / 2) + math.sin(0) * r,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            _updateParticles(size);
            return CustomPaint(
              size: size,
              painter: _ParticlePainter(
                particles: _particles,
              ),
            );
          },
        );
      },
    );
  }

  void _updateParticles(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pointer = widget.pointerPosition;

    for (final p in _particles) {
      p.angle += p.speed;

      final targetX = center.dx + math.cos(p.angle) * p.radius;
      final targetY = center.dy + math.sin(p.angle) * p.radius;

      double repelX = 0;
      double repelY = 0;
      if (widget.isPointerVisible) {
        final dx = p.x - pointer.dx;
        final dy = p.y - pointer.dy;
        final distance = math.sqrt(dx * dx + dy * dy);

        if (distance > 0 && distance < 250) {
          final force = math.pow((250 - distance) / 250, 2).toDouble();
          repelX = (dx / distance) * force * 18;
          repelY = (dy / distance) * force * 18;
        }
      }

      final springX = (targetX - p.x) * 0.06;
      final springY = (targetY - p.y) * 0.06;

      p.vx = (p.vx + springX + repelX) * 0.82;
      p.vy = (p.vy + springY + repelY) * 0.82;

      p.x += p.vx;
      p.y += p.vy;
    }
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.particles});

  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      canvas.save();
      canvas.translate(p.x, p.y);
      var angle = 0.0;
      if (p.vx.abs() > 0.1 || p.vy.abs() > 0.1) {
        angle = math.atan2(p.vy, p.vx);
      } else {
        angle = p.angle + math.pi / 2;
      }
      canvas.rotate(angle);

      final rect = Rect.fromCenter(center: Offset.zero, width: p.size * 2.5, height: p.size * 0.8);
      canvas.drawRect(rect, p.paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
