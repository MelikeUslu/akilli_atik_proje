import 'package:flutter_test/flutter_test.dart';

import 'package:akilli_atik_proje/domain/entities/fill_level.dart';

void main() {
  group('FillLevel.fromPercentage', () {
    test('0 ile 40 arası low döner', () {
      expect(FillLevel.fromPercentage(0), FillLevel.low);

      expect(FillLevel.fromPercentage(40), FillLevel.low);
    });

    test('40 üstü ile 70 arası medium döner', () {
      expect(FillLevel.fromPercentage(41), FillLevel.medium);

      expect(FillLevel.fromPercentage(70), FillLevel.medium);
    });

    test('70 üstü ile 90 altı high döner', () {
      expect(FillLevel.fromPercentage(71), FillLevel.high);

      expect(FillLevel.fromPercentage(89), FillLevel.high);
    });

    test('90 ile 100 arası critical döner', () {
      expect(FillLevel.fromPercentage(90), FillLevel.critical);

      expect(FillLevel.fromPercentage(100), FillLevel.critical);
    });

    test('0 altındaki değer RangeError fırlatır', () {
      expect(() => FillLevel.fromPercentage(-1), throwsRangeError);
    });

    test('100 üstündeki değer RangeError fırlatır', () {
      expect(() => FillLevel.fromPercentage(101), throwsRangeError);
    });
  });
}
