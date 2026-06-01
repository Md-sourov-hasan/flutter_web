import 'package:flutter/material.dart';

import '../widgets/reels_showcase.dart';
import '../widgets/section_widgets.dart';
import '../widgets/site_shell.dart';
import 'contact_page.dart';

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  static const routeName = '/reels';

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      currentRoute: routeName,
      primaryGlow: const Color(0xFFFF679A),
      secondaryGlow: const Color(0xFFB53B68),
      hero: const HeroPanel(
        eyebrow: 'REELS',
        title: 'A dedicated reel page for short, vertical video cuts.',
        description:
            'This page keeps the reels together in one place so the feed behaves like its own destination instead of a block inside another layout.',
        primaryLabel: 'Talk About a Project',
        primaryRoute: ContactPage.routeName,
        secondaryLabel: 'View the Home Page',
        secondaryRoute: '/',
        metrics: [
          MetricData('03', 'Reel clips'),
          MetricData('Scroll', 'Swipe down for next'),
          MetricData('Muted', 'Autoplay feed'),
          MetricData('Page', 'Standalone route'),
        ],
        rightEyebrow: 'Reel System',
        rightDescription:
            'Vertical playback, muted autoplay, and a mobile-style feed structure make this page feel like a purpose-built reel destination.',
        rightColors: [Color(0x5CFF679A), Color(0xFF2B313E)],
      ),
      sections: const [
        SectionPanel(
          title: 'Vertical reel feed',
          description:
              'Use the full-height feed to move through the three clips one by one, just like a dedicated short-form video page.',
          child: ReelsShowcase(),
        ),
      ],
    );
  }
}
