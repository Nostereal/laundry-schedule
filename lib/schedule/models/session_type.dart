enum SessionType {
  open,
  launch,
}

extension Name on SessionType {
  String get name => toString().split('.').last;
}

SessionType sessionByType(String type) {
  return SessionType.values.firstWhere((element) => element.name == type);
}
