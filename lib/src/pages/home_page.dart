import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/section_widgets.dart';
import '../widgets/site_shell.dart';
import 'contact_page.dart';
import 'services_page.dart';
import 'work_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      currentRoute: routeName,
      hero: const HeroPanel(
        eyebrow: 'MULTI-PAGE FLUTTER EXPERIENCE',
        title: 'Websites that feel like a category shift.',
        description:
            'We design and build premium marketing sites with stronger structure, sharper messaging, and a visual system that makes the business look more valuable immediately.',
        primaryLabel: 'Book a Build Sprint',
        primaryRoute: ContactPage.routeName,
        secondaryLabel: 'See Selected Work',
        secondaryRoute: WorkPage.routeName,
        metrics: [
          MetricData('04', 'Core pages launched'),
          MetricData('72h', 'Concept-to-direction turnaround'),
          MetricData('100%', 'Responsive structure'),
          MetricData('Flutter', 'Normal app entrypoint'),
        ],
      ),
      sections: const [
        SectionPanel(
          title: 'Built like a serious brand, not a template.',
          description:
              'Every block is shaped to increase trust, sharpen clarity, and make the whole offer feel more expensive on first view.',
          child: FeatureGrid(
            darkText: true,
            items: [
              FeatureData(
                imageAsset: 'assets/images/card_bg_4.png',
                kicker: '01',
                title: 'Narrative-first hero',
                description:
                    'A confident homepage opening that frames the offer fast and gives visitors a reason to keep reading.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_5.png',
                kicker: '02',
                title: 'Professional page system',
                description: 'Service, work, and contact pages that feel connected instead of stitched together.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_1.png',
                kicker: '03',
                title: 'Launch-ready build',
                description: 'Clean Flutter folder structure with reusable widgets and predictable routing.',
              ),
            ],
          ),
        ),
        SectionPanel(
          title: 'From rough idea to premium digital presence.',
          description:
              'The build flow removes generic-looking choices and replaces them with stronger positioning, calmer hierarchy, and cleaner page pacing.',
          tinted: true,
          child: FeatureGrid(
            darkText: true,
            columns: 3,
            items: [
              FeatureData(
                imageAsset: 'assets/images/card_bg_1.png',
                title: 'Direction',
                description:
                    'We lock the message, tone, and positioning before layout decisions start competing for attention.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_2.png',
                title: 'Structure',
                description: 'We build a multi-page user flow that makes each screen carry a clear responsibility.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_3.png',
                title: 'Launch',
                description:
                    'We refine spacing, contrast, calls to action, and responsiveness until the site feels composed.',
              ),
            ],
          ),
        ),
        SectionPanel(
          title: 'A more editorial, more interactive front layer.',
          description:
              'This pass adds denser visual UI so the homepage feels more like a premium product surface and less like a plain section stack.',
          child: _ImmersiveShowcasePanel(),
        ),
        SectionPanel(
          title: 'Inside the build signal.',
          description:
              'A more custom project usually feels different because the internal decisions are sharper, faster, and far more intentional than a template workflow.',
          child: SignalConsole(
            headline: 'The site is designed like a control system, not a page pile.',
            description:
                'We keep the messaging system, visual hierarchy, conversion flow, and implementation constraints visible together so the final website feels composed instead of accidental.',
            tags: [
              'Narrative Lock',
              'Trust Density',
              'Motion Control',
              'Launch Logic',
            ],
            lines: [
              SignalLineData(
                label: 'Message priority',
                value: 'LOCKED',
                note: 'Hero, proof, and CTA order are shaped before decorative choices start diluting clarity.',
              ),
              SignalLineData(
                label: 'Visual rhythm',
                value: 'TUNED',
                note: 'Cards, copy blocks, and negative space are paced to feel premium rather than crowded.',
              ),
              SignalLineData(
                label: 'Implementation layer',
                value: 'READY',
                note: 'Reusable widgets and page routing stay aligned with the design direction from day one.',
              ),
            ],
          ),
        ),
        SectionPanel(
          title: 'What the new UI is doing at a glance.',
          description:
              'These smaller blocks make the interface feel newer by mixing dashboard cues, editorial pacing, and stronger visual contrast.',
          tinted: true,
          child: _MomentumBoard(),
        ),
        CtaBand(
          title: 'Need a site that instantly looks more credible?',
          description:
              'Start with a proper Flutter multipage foundation that already feels premium, modern, and ready to scale.',
          buttonLabel: 'Review Services',
          buttonRoute: ServicesPage.routeName,
        ),
      ],
    );
  }
}

class _ImmersiveShowcasePanel extends StatelessWidget {
  const _ImmersiveShowcasePanel();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 980;

        final narrative = Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.68),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.lineDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PillLabel(label: 'Experience Layer'),
              SizedBox(height: 18),
              Text(
                'More motion cues, more hierarchy, and more contrast between message blocks.',
                style: TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Instead of relying only on headline plus cards, the page now carries extra UI moments that imply direction, system thinking, and polish.',
                style: TextStyle(
                  color: AppTheme.textDarkMuted,
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
              SizedBox(height: 22),
              _MiniInsightRow(),
            ],
          ),
        );

        final preview = Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF22314A), Color(0xFF162235)],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.lineLight),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2207111F),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            children: const [
              _ShowcaseVisual(),
              SizedBox(height: 18),
              _ShowcaseStats(),
            ],
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              narrative,
              const SizedBox(height: 16),
              preview,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: narrative),
            const SizedBox(width: 16),
            Expanded(flex: 6, child: preview),
          ],
        );
      },
    );
  }
}

class _MiniInsightRow extends StatelessWidget {
  const _MiniInsightRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        _InsightChip(label: 'Overlay accents'),
        _InsightChip(label: 'Live status UI'),
        _InsightChip(label: 'Editorial content cards'),
      ],
    );
  }
}

class _InsightChip extends StatelessWidget {
  const _InsightChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.panel.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textDark,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ShowcaseVisual extends StatelessWidget {
  const _ShowcaseVisual();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/card_bg_3.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xCC101821),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.lineLight),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UI Pass 02',
                    style: TextStyle(
                      color: AppTheme.accentStrong,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Sharper first fold',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              width: 220,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xDB162235),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.lineLight),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visual outcome',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'More “designed” than “assembled”',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
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

class _ShowcaseStats extends StatelessWidget {
  const _ShowcaseStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatTile(
            label: 'Depth',
            value: 'Higher',
            accent: AppTheme.accentStrong,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            label: 'Clarity',
            value: 'Cleaner',
            accent: AppTheme.accentMint,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            label: 'Feel',
            value: 'Newer',
            accent: AppTheme.accentRose,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.lineLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.4),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MomentumBoard extends StatelessWidget {
  const _MomentumBoard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 920;
        final cards = const [
          _MomentumCard(
            title: 'Navigation layer',
            value: 'Upgraded',
            description: 'A live status pill and stronger shell framing make the app feel more active immediately.',
          ),
          _MomentumCard(
            title: 'Hero density',
            value: 'Expanded',
            description: 'New signal chips and summary blocks add polish without making the layout heavy.',
          ),
          _MomentumCard(
            title: 'Homepage sections',
            value: 'Added',
            description: 'New editorial preview blocks create more UI variety and a fresher flow down the page.',
          ),
        ];

        if (compact) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i != cards.length - 1) const SizedBox(height: 14),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) const SizedBox(width: 14),
            ],
          ],
        );
      },
    );
  }
}

class _MomentumCard extends StatelessWidget {
  const _MomentumCard({
    required this.title,
    required this.value,
    required this.description,
  });

  final String title;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.lineDark),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1407111F),
            blurRadius: 18,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textDarkMuted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: AppTheme.textDarkMuted,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
