class AccessModel {
  final int aId;
  final int pId;
  final String accessType;
  final DateTime timestamp;

  const AccessModel(
      {required this.aId,
      required this.pId,
      required this.accessType,
      required this.timestamp});
}
