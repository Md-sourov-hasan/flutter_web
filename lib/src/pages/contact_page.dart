import 'package:flutter/material.dart';

import '../widgets/section_widgets.dart';
import '../widgets/site_shell.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  static const routeName = '/contact';

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      currentRoute: routeName,
      primaryGlow: const Color(0xFF67FFB0),
      secondaryGlow: const Color(0xFF3BB568),
      hero: const SplitContactHero(
        eyebrow: 'CONTACT',
        title: 'Let’s build a sharper web presence.',
        description:
            'If you want a professional multi-page Flutter website with a normal app structure, this is where we define the scope, timeline, and priority pages.',
      ),
      sections: const [
        SectionPanel(
          title: 'Project fit',
          description:
              'Best for service businesses, studios, consultants, founder-led brands, and teams replacing a generic brochure site.',
          child: FeatureGrid(
            darkText: true,
            items: [
              FeatureData(
                imageAsset: 'assets/images/card_bg_2.png',
                title: 'Premium service businesses',
                description: 'For teams whose current site undersells the quality of the actual offer.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_3.png',
                title: 'Positioning-led redesigns',
                description: 'For founders who need the message and layout to work harder together.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_4.png',
                title: 'Multi-page launches',
                description: 'For projects that need more than a single hero section and a footer.',
              ),
            ],
          ),
        ),
        SectionPanel(
          title: 'Direct paths',
          description: 'Use the contact route that gets you into the clearest conversation fastest.',
          tinted: true,
          child: FeatureGrid(
            darkText: true,
            columns: 2,
            items: [
              FeatureData(
                imageAsset: 'assets/images/card_bg_5.png',
                title: 'Email',
                description: 'hello@jasperatelier.dev for scope, timeline, and project details.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_1.png',
                title: 'WhatsApp',
                description: '+880 10 0000 0000 for faster planning-style conversation and quick direction.',
              ),
            ],
          ),
        ),
        SectionPanel(
          title: 'Response deck',
          description:
              'If the project feels like a fit, these are the signals that usually matter most before a proper kickoff conversation starts.',
          child: ContactSignalDeck(
            items: [
              ContactSignalData(
                title: 'RESPONSE MODE',
                value: 'Fast Scope Read',
                caption: 'You can usually expect an initial direction response before the conversation loses momentum.',
              ),
              ContactSignalData(
                title: 'PROJECT WINDOW',
                value: 'Focused Build Slots',
                caption:
                    'Best results happen when the messaging, page goals, and review loop are kept compact and intentional.',
              ),
              ContactSignalData(
                title: 'BEST ENTRY',
                value: 'Clear Brief > Better Site',
                caption:
                    'The sharper your current offer, audience, and problem statement, the better the first concept gets.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
