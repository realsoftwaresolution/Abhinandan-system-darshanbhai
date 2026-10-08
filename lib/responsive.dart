import 'package:flutter/material.dart';

/// Central responsive layout engine and breakpoint manager.
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  // Breakpoints:
  // Mobile: < 700 (phones & compact viewports)
  // Tablet: 700 - 1100 (iPads, tablets, medium split-screens)
  // Desktop: >= 1100 (laptops, widescreen desktop monitors)
  static const double mobileBreakpoint = 700.0;
  static const double tabletBreakpoint = 1100.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static bool isMobileOrTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletBreakpoint;

  /// Returns a responsive value based on current device screen width.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  /// Helper to get optimal column count for grids.
  static int gridColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 4,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= tabletBreakpoint) {
      return desktop;
    } else if (size.width >= mobileBreakpoint && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

