import 'package:flutter/material.dart';

import '../navigation/site_navigation.dart';
import '../theme/app_theme.dart';
import '../widgets/site_shell.dart';
import 'home_page.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  static const routeName = '/intro';

  @override
  Widget build(BuildContext context) {
    return SiteBackdropFrame(
      routeName: routeName,
      routeLabel: 'Entry',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xA3162235),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppTheme.lineLight),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2607111F),
                  blurRadius: 32,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FilledButton(
                onPressed: () => navigateToRoute(context, HomePage.routeName),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.accentStrong,
                  foregroundColor: AppTheme.textDark,
                  padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 22),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text('Start'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
