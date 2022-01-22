List<List<T>> windowed<T>(List<T> source, int windowSize) {
  if (windowSize < 1) throw ArgumentError("windowSize must be > 0");
  if (source.isEmpty) return [];

  var result = List.filled((source.length / windowSize).ceil(), <T>[]);

  for (int srcIdx = 0, dstIdx = 0;
      srcIdx < source.length;
      srcIdx += windowSize, dstIdx++) {
    final int potentialEnd = srcIdx + windowSize;
    final int end = potentialEnd > source.length ? source.length : potentialEnd;
    result[dstIdx] = source.sublist(srcIdx, end);
  }

  return result;
}
