import 'package:flutter/material.dart';

class KpiEntity {
  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;
  final double? trendPercent; // positive = up, negative = down, null = no trend

  const KpiEntity({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
    this.subtitle,
    this.trendPercent,
  });
}
