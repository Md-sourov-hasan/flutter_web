import 'package:flutter/material.dart';

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
