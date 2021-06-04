class Drug {
  String serialNumber;
  String name;
  String? description;
  int timeOut;

  Drug({
    required this.serialNumber,
    required this.name,
    required this.timeOut,
    this.description,
  });
}
