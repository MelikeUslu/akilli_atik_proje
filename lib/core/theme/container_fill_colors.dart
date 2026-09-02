import 'package:flutter/material.dart';

import '../../domain/entities/fill_level.dart';
import 'app_colors.dart';

abstract final class ContainerFillColors {
  static const Color low = AppColors.success;
  static const Color medium = AppColors.warning;
  static const Color high = AppColors.warningHigh;
  static const Color critical = AppColors.danger;

  static Color fromFillLevel(FillLevel fillLevel) {
    return switch (fillLevel) {
      FillLevel.low => low,
      FillLevel.medium => medium,
      FillLevel.high => high,
      FillLevel.critical => critical,
    };
  }
}
