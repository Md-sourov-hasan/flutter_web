import 'package:flutter/material.dart';

import '../widgets/section_widgets.dart';
import '../widgets/site_shell.dart';
import 'contact_page.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const routeName = '/services';

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      currentRoute: routeName,
      primaryGlow: const Color(0xFF6788FF),
      secondaryGlow: const Color(0xFF3B68B5),
      hero: const CenteredHero(
        eyebrow: 'SERVICES',
        title: 'Multi-page website systems for ambitious brands.',
        description:
            'We do more than decorate screens. We define the message, shape the page structure, and build a web experience that is easier to trust and easier to buy from.',
        primaryLabel: 'Start a Project',
        primaryRoute: ContactPage.routeName,
      ),
      sections: const [
        SectionPanel(
          title: 'What the build usually includes',
          description: 'A complete professional web presence, not just a single homepage with random sections.',
          child: AlternatingFeatureList(
            items: [
              FeatureData(
                imageAsset: 'assets/images/card_bg_5.png',
                title: 'Positioning and page strategy',
                description:
                    'Offer framing, audience clarity, page order, CTA flow, and how the site guides attention.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_1.png',
                title: 'Premium visual direction',
                description: 'Typography, spacing, card system, gradients, and a stronger overall design language.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_2.png',
                title: 'Production-ready Flutter build',
                description:
                    'Normal `main.dart`, reusable widgets, routed pages, and a structure that feels like a real Flutter project.',
              ),
            ],
          ),
        ),
        SectionPanel(
          title: 'Typical deliverables',
          description:
              'Built to support launches, service businesses, consulting offers, studios, and founder-led brands.',
          tinted: true,
          child: AlternatingFeatureList(
            items: [
              FeatureData(
                imageAsset: 'assets/images/card_bg_3.png',
                title: 'Homepage',
                description: 'Premium hero, positioning blocks, authority section, and strong calls to action.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_4.png',
                title: 'Services page',
                description: 'Clear offer packaging, scope logic, and better explanation of what is included.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_5.png',
                title: 'Work or proof page',
                description: 'Selected projects, outcomes, and visual trust signals that support the main offer.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_1.png',
                title: 'Contact page',
                description: 'Simple inquiry flow designed to reduce friction and move conversations forward.',
              ),
            ],
          ),
        ),
        SectionPanel(
          title: 'Launch sequence',
          description:
              'Each stage solves a different problem, so the project gains momentum without collapsing into random revisions and visual guesswork.',
          child: LaunchTimeline(
            stages: [
              LaunchStageData(
                phase: '01',
                title: 'Signal Capture',
                description:
                    'We define positioning, audience expectations, offer logic, and what the first screen must immediately communicate.',
                window: 'Strategy Window',
              ),
              LaunchStageData(
                phase: '02',
                title: 'System Build',
                description:
                    'We shape the layout language, content rhythm, section hierarchy, and component system across the core pages.',
                window: 'Design + Structure',
              ),
              LaunchStageData(
                phase: '03',
                title: 'Launch Polish',
                description:
                    'We refine motion, responsiveness, CTA pacing, and final implementation details until the site feels deliberate.',
                window: 'QA + Delivery',
              ),
            ],
          ),
        ),
        CtaBand(
          title: 'Want the full scope mapped page by page?',
          description:
              'We can turn this into a business-specific system with your real brand, real services, and real lead flow.',
          buttonLabel: 'Go to Contact',
          buttonRoute: ContactPage.routeName,
        ),
      ],
    );
  }
}
