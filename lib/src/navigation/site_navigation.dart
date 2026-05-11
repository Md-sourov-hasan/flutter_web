import 'package:flutter/material.dart';

class SiteRouteArguments {
  const SiteRouteArguments({this.fromRoute});

  final String? fromRoute;
}

const List<String> siteRouteOrder = <String>[
  '/',
  '/services',
  '/work',
  '/contact',
];

void navigateToRoute(BuildContext context, String routeName) {
  final currentRoute = ModalRoute.of(context)?.settings.name;
  if (currentRoute == routeName) {
    return;
  }

  Navigator.of(context).pushReplacementNamed(
    routeName,
    arguments: SiteRouteArguments(fromRoute: currentRoute),
  );
}

Offset resolveRouteTransitionOffset(String? fromRoute, String toRoute) {
  final fromIndex = siteRouteOrder.indexOf(fromRoute ?? '');
  final toIndex = siteRouteOrder.indexOf(toRoute);

  if (fromIndex == -1 || toIndex == -1 || fromIndex == toIndex) {
    return const Offset(0, 0.035);
  }

  return toIndex > fromIndex ? const Offset(0.055, 0) : const Offset(-0.055, 0);
}
