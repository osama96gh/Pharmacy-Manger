class Drug {
  String serial;
  String name;
  String? description;
  int expiredAt;

  Drug({
    required this.serial,
    required this.name,
    required this.expiredAt,
    this.description,
  });
}
