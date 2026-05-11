import 'package:flutter/material.dart';

import '../navigation/site_navigation.dart';
import '../theme/app_theme.dart';

class HeroPanel extends StatelessWidget {
  const HeroPanel({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.primaryRoute,
    required this.secondaryLabel,
    required this.secondaryRoute,
    required this.metrics,
    this.rightEyebrow = 'Launch Stack',
    this.rightDescription =
        'Strategy, page architecture, and a visual system that makes the business feel more valuable at first glance.',
    this.rightColors = const [Color(0x5CFFB067), Color(0xFF2B313E)],
  });

  final String eyebrow;
  final String title;
  final String description;
  final String primaryLabel;
  final String primaryRoute;
  final String secondaryLabel;
  final String secondaryRoute;
  final List<MetricData> metrics;
  final String rightEyebrow;
  final String rightDescription;
  final List<Color> rightColors;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 940;
        final titleStyle = constraints.maxWidth > 1100
            ? Theme.of(context).textTheme.displayLarge
            : Theme.of(context).textTheme.displayMedium;

        final left = Container(
          constraints: const BoxConstraints(minHeight: 470),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xD9162235),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppTheme.lineLight),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2207111F),
                blurRadius: 32,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PillLabel(label: eyebrow),
              const SizedBox(height: 24),
              Text(
                title,
                style: titleStyle,
              ),
              const SizedBox(height: 22),
              Text(description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ActionButton(
                    label: primaryLabel,
                    onTap: () => navigateToRoute(context, primaryRoute),
                  ),
                  GhostButton(
                    label: secondaryLabel,
                    onTap: () => navigateToRoute(context, secondaryRoute),
                  ),
                ],
              ),
            ],
          ),
        );

        final right = Container(
          constraints: const BoxConstraints(minHeight: 470),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: rightColors,
            ),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: const Color(0x33FFF1DD)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2607111F),
                blurRadius: 36,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PillLabel(label: rightEyebrow),
              const SizedBox(height: 20),
              Text(
                rightDescription,
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: compact ? 1 : 2,
                childAspectRatio: compact ? 4.2 : 1.18,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  for (final metric in metrics) MetricCard(data: metric),
                ],
              ),
            ],
          ),
        );

        return compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  left,
                  const SizedBox(height: 18),
                  right,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: left),
                  const SizedBox(width: 18),
                  Expanded(flex: 5, child: right),
                ],
              );
      },
    );
  }
}

class SectionPanel extends StatelessWidget {
  const SectionPanel({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    this.tinted = false,
  });

  final String title;
  final String description;
  final Widget child;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final gradient = tinted
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.surfaceAlt, Color(0xFFE7D8C4)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.surface, AppTheme.surfaceAlt],
          );
    final fg = AppTheme.textDark;
    final muted = AppTheme.textDarkMuted;
    final border = AppTheme.lineDark;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1607111F),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: fg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: fg,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                color: muted,
                fontSize: 16,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 22),
            child,
          ],
        ),
      ),
    );
  }
}

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({
    super.key,
    required this.items,
    this.darkText = false,
    this.columns = 3,
  });

  final List<FeatureData> items;
  final bool darkText;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 760
            ? 1
            : constraints.maxWidth < 1040
            ? 2
            : columns;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: crossAxisCount == 1 ? 1.35 : 1.05,
          ),
          itemBuilder: (context, index) {
            return FeatureCard(
              data: items[index],
              darkText: darkText,
            );
          },
        );
      },
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.data, required this.darkText});

  final FeatureData data;
  final bool darkText;

  @override
  Widget build(BuildContext context) {
    final titleColor = darkText ? AppTheme.textDark : AppTheme.textPrimary;
    final bodyColor = darkText ? AppTheme.textDarkMuted : AppTheme.textMuted;
    final bg = darkText ? Colors.white.withValues(alpha: 0.58) : const Color(0xB3162235);
    final border = darkText ? const Color(0x1407111F) : AppTheme.lineLight;

    return _HoverLift(
      glowColor: darkText ? AppTheme.accentStrong : AppTheme.accentSoft,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: border),
          image: data.imageAsset != null
              ? DecorationImage(
                  image: AssetImage(data.imageAsset!),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                )
              : null,
          boxShadow: darkText
              ? const [
                  BoxShadow(
                    color: Color(0x1207111F),
                    blurRadius: 22,
                    offset: Offset(0, 12),
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0x1A07111F),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.kicker != null) ...[
              Text(
                data.kicker!,
                style: const TextStyle(
                  color: AppTheme.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              data.title,
              style: TextStyle(
                color: data.imageAsset != null ? Colors.white : titleColor,
                fontSize: 24,
                height: 1.12,
                fontWeight: FontWeight.w800,
                shadows: data.imageAsset != null
                    ? const [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 16,
                        ),
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              data.description,
              style: TextStyle(
                color: data.imageAsset != null ? Colors.white : bodyColor,
                fontSize: 15,
                height: 1.6,
                fontWeight: data.imageAsset != null ? FontWeight.w500 : FontWeight.normal,
                shadows: data.imageAsset != null
                    ? const [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 16,
                        ),
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _FuturisticButtonShell(
      onTap: onTap,
      filled: true,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppTheme.textDark,
        ),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  const GhostButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _FuturisticButtonShell(
      onTap: onTap,
      filled: false,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppTheme.accentSoft,
        ),
      ),
    );
  }
}

class PillLabel extends StatelessWidget {
  const PillLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.accentSoft,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.data});

  final MetricData data;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      glowColor: AppTheme.accentStrong,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x26FFF4E8), Color(0x14FFFFFF)],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0x26FFE1BD)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1807111F),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.label,
                style: const TextStyle(
                  color: Color(0xFFD8E0EC),
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FuturisticButtonShell extends StatefulWidget {
  const _FuturisticButtonShell({
    required this.onTap,
    required this.child,
    required this.filled,
  });

  final VoidCallback onTap;
  final Widget child;
  final bool filled;

  @override
  State<_FuturisticButtonShell> createState() => _FuturisticButtonShellState();
}

class _FuturisticButtonShellState extends State<_FuturisticButtonShell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: (widget.filled ? AppTheme.accent : AppTheme.accentSoft).withValues(alpha: _hovered ? 0.24 : 0.1),
                blurRadius: _hovered ? 28 : 16,
                spreadRadius: _hovered ? 1 : 0,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: widget.filled
                          ? const LinearGradient(
                              colors: [AppTheme.accent, AppTheme.accentStrong],
                            )
                          : LinearGradient(
                              colors: [
                                const Color(0x3DFFFFFF),
                                AppTheme.accent.withValues(alpha: 0.08),
                              ],
                            ),
                      border: Border.all(
                        color: widget.filled
                            ? Colors.white.withValues(alpha: 0.16)
                            : AppTheme.accent.withValues(alpha: 0.22),
                      ),
                    ),
                    child: InkWell(
                      onTap: widget.onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        child: Center(child: widget.child),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 520),
                    curve: Curves.easeOutCubic,
                    alignment: _hovered ? const Alignment(1.4, 0) : const Alignment(-1.4, 0),
                    child: Container(
                      width: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0),
                            Colors.white.withValues(alpha: widget.filled ? 0.26 : 0.12),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
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

class _HoverLift extends StatefulWidget {
  const _HoverLift({
    required this.child,
    required this.glowColor,
  });

  final Widget child;
  final Color glowColor;

  @override
  State<_HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<_HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.015 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedSlide(
          offset: _hovered ? const Offset(0, -0.018) : Offset.zero,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withValues(alpha: _hovered ? 0.18 : 0),
                  blurRadius: _hovered ? 30 : 0,
                  spreadRadius: _hovered ? 1 : 0,
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class CtaBand extends StatelessWidget {
  const CtaBand({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.buttonRoute,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final String buttonRoute;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 860;

        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.surface, AppTheme.surfaceAlt],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppTheme.lineDark),
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CtaCopy(title: title, description: description),
                    const SizedBox(height: 18),
                    ActionButton(
                      label: buttonLabel,
                      onTap: () => navigateToRoute(context, buttonRoute),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _CtaCopy(title: title, description: description),
                    ),
                    const SizedBox(width: 18),
                    ActionButton(
                      label: buttonLabel,
                      onTap: () => navigateToRoute(context, buttonRoute),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _CtaCopy extends StatelessWidget {
  const _CtaCopy({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(
            color: AppTheme.textDarkMuted,
            fontSize: 16,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class MetricData {
  const MetricData(this.value, this.label);

  final String value;
  final String label;
}

class FeatureData {
  const FeatureData({
    this.kicker,
    this.imageAsset,
    required this.title,
    required this.description,
  });

  final String? kicker;
  final String? imageAsset;
  final String title;
  final String description;
}

class CenteredHero extends StatelessWidget {
  const CenteredHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.primaryRoute,
  });

  final String eyebrow;
  final String title;
  final String description;
  final String primaryLabel;
  final String primaryRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
      decoration: BoxDecoration(
        color: const Color(0xD9162235),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: AppTheme.lineLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2207111F),
            blurRadius: 32,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PillLabel(label: eyebrow),
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 24),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          ActionButton(
            label: primaryLabel,
            onTap: () => navigateToRoute(context, primaryRoute),
          ),
        ],
      ),
    );
  }
}

class AlternatingFeatureList extends StatelessWidget {
  const AlternatingFeatureList({super.key, required this.items});
  final List<FeatureData> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        return Column(
          children: [
            for (var i = 0; i < items.length; i++)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF162235),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: AppTheme.lineLight),
                ),
                child: compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (items[i].imageAsset != null)
                            Container(
                              height: 150,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(items[i].imageAsset!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Text(
                            items[i].title,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            items[i].description,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        textDirection: i % 2 == 0 ? TextDirection.ltr : TextDirection.rtl,
                        children: [
                          if (items[i].imageAsset != null)
                            Expanded(
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(items[i].imageAsset!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          else
                            const Expanded(child: SizedBox()),
                          const SizedBox(width: 40),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: i % 2 == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                              children: [
                                Text(
                                  items[i].title,
                                  textAlign: i % 2 == 0 ? TextAlign.left : TextAlign.right,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  items[i].description,
                                  textAlign: i % 2 == 0 ? TextAlign.left : TextAlign.right,
                                  style: const TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 16,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
          ],
        );
      },
    );
  }
}

class SplitContactHero extends StatelessWidget {
  const SplitContactHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 940;
        final left = Container(
          constraints: const BoxConstraints(minHeight: 400),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xD9162235),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppTheme.lineLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PillLabel(label: eyebrow),
              const SizedBox(height: 24),
              Text(title, style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 22),
              Text(description, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        );

        final right = Container(
          constraints: const BoxConstraints(minHeight: 400),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF162235),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppTheme.lineLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Color(0xFF1F2B41),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Color(0xFF1F2B41),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Color(0xFF1F2B41),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: AppTheme.textDark,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Send Inquiry', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ],
          ),
        );

        return compact
            ? Column(children: [left, const SizedBox(height: 20), right])
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 5, child: left),
                    const SizedBox(width: 20),
                    Expanded(flex: 4, child: right),
                  ],
                ),
              );
      },
    );
  }
}

class LargeFeatureList extends StatelessWidget {
  const LargeFeatureList({super.key, required this.items});
  final List<FeatureData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          Container(
            height: 400,
            margin: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              image: item.imageAsset != null
                  ? DecorationImage(
                      image: AssetImage(item.imageAsset!),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    )
                  : null,
            ),
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.3, 1.0],
                ),
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
