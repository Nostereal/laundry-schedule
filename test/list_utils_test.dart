import 'package:flutter_test/flutter_test.dart';
import 'package:washing_schedule/utils/lists.dart';

void main() {
  group("windowed list function", () {
    test("non-empty list returns correct 'windowed' list", () {
      final source = [1, 2, 3, 4, 5, 6, 7];
      final windowedResult = windowed(source, 2);
      expect(windowedResult.length, 4);
      expect(windowedResult, [[1, 2], [3, 4], [5, 6], [7]]);
    });

    test("empty list returns empty list", () {
      final source = [];
      final windowedResult = windowed(source, 2);
      expect(windowedResult, []);
    });

    test("windowSize < 1 throws an exception", () {
      final source = [];
      expect(() => windowed(source, 0), throwsA((e) => e is ArgumentError));
    });
  });
}
