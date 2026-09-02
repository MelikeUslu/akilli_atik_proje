enum FillLevel {
  low,
  medium,
  high,
  critical;

  static FillLevel fromPercentage(double percentage) {
    if (percentage < 0 || percentage > 100) {
      throw RangeError.range(percentage, 0, 100, 'percentage');
    }

    if (percentage <= 40) {
      return FillLevel.low;
    }

    if (percentage <= 70) {
      return FillLevel.medium;
    }

    if (percentage < 90) {
      return FillLevel.high;
    }

    return FillLevel.critical;
  }
}
