import 'package:flutter/material.dart';

import '../widgets/section_widgets.dart';
import '../widgets/site_shell.dart';
import 'contact_page.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  static const routeName = '/work';

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      currentRoute: routeName,
      primaryGlow: const Color(0xFFFF679A),
      secondaryGlow: const Color(0xFFB53B68),
      hero: const HeroPanel(
        eyebrow: 'SELECTED WORK',
        title: 'Pages that make premium offers easier to believe.',
        description:
            'These concept directions show how stronger structure, sharper messaging, and calmer visual hierarchy can reposition a business in one scroll.',
        primaryLabel: 'Request a Build Scope',
        primaryRoute: ContactPage.routeName,
        secondaryLabel: 'Talk About Your Site',
        secondaryRoute: ContactPage.routeName,
        metrics: [
          MetricData('3x', 'Clearer first impression'),
          MetricData('Calm', 'More premium page pacing'),
          MetricData('Proof', 'Better trust placement'),
          MetricData('Flow', 'Cleaner conversion path'),
        ],
        rightEyebrow: 'Impact',
        rightDescription: 'Clear examples of how an improved design language changes the perception of value.',
        rightColors: [Color(0x5CFF679A), Color(0xFF2B313E)],
      ),
      sections: const [
        SectionPanel(
          title: 'Example repositioning directions',
          description:
              'Each example focuses on how layout, hierarchy, and narrative can make the same offer feel dramatically more credible.',
          child: LargeFeatureList(
            items: [
              FeatureData(
                imageAsset: 'assets/images/card_bg_2.png',
                title: 'Northstar Advisory',
                description:
                    'Consulting homepage rebuilt around authority, cleaner offer framing, and faster-moving CTA blocks.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_3.png',
                title: 'Frame House Studio',
                description:
                    'Creative studio site shifted from visual clutter to a calmer editorial feel with stronger hierarchy.',
              ),
              FeatureData(
                imageAsset: 'assets/images/card_bg_4.png',
                title: 'Arc Motion Systems',
                description:
                    'B2B product site redesigned with sharper page architecture and proof-first section ordering.',
              ),
            ],
          ),
        ),
        SectionPanel(
          title: 'What actually changed',
          description:
              'These concept directions are more than prettier screens. The structure, proof placement, and pacing shift how expensive the same offer feels.',
          tinted: true,
          child: ProofMatrix(
            items: [
              ProofMatrixData(
                title: 'Northstar Advisory',
                before: 'Generic consulting opener with vague messaging and no immediate authority signal.',
                after: 'Sharper promise, faster proof placement, and clearer consultation pathway from the first fold.',
                uplift: 'Authority reads much faster',
              ),
              ProofMatrixData(
                title: 'Frame House Studio',
                before: 'Portfolio clutter and inconsistent spacing made the creative work feel less curated.',
                after:
                    'Editorial pacing, stronger visual margins, and calmer art direction made the work feel premium.',
                uplift: 'Creative value feels more intentional',
              ),
              ProofMatrixData(
                title: 'Arc Motion Systems',
                before: 'Product details appeared before trust, making the offer feel technical but not compelling.',
                after: 'Proof-first architecture and cleaner feature grouping made the business feel more established.',
                uplift: 'B2B trust lands earlier',
              ),
              ProofMatrixData(
                title: 'Overall system effect',
                before: 'Pages looked separate, which weakened the perceived depth of the company.',
                after:
                    'Connected narrative flow across hero, services, proof, and contact made the brand feel complete.',
                uplift: 'Whole site feels like one brand',
              ),
            ],
          ),
        ),
        CtaBand(
          title: 'Want this level of polish for your own website?',
          description:
              'We can turn a rough or generic web presence into a multipage experience that feels far more established.',
          buttonLabel: 'Start the Conversation',
          buttonRoute: ContactPage.routeName,
        ),
      ],
    );
  }
}
