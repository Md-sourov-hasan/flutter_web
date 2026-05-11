import 'dart:async';
import 'dart:math' as math;

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

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  bool _handleScrollNotification(UserScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }

    if (notification.metrics.pixels <= 8) {
      _setNavVisible(true);
      return false;
    }

    if (notification.direction == ScrollDirection.forward) {
      _setNavVisible(true);
    } else if (notification.direction == ScrollDirection.reverse) {
      _setNavVisible(false);
    }

    return false;
  }

  void _setNavVisible(bool visible) {
    if (_navVisible == visible || !mounted) {
      return;
    }
    setState(() => _navVisible = visible);
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
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
              NotificationListener<UserScrollNotification>(
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
            ],
          ),
        ),
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
