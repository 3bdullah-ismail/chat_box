class PresenceModel {
  final bool online;
  final int lastSeen;

  const PresenceModel({required this.online, required this.lastSeen});

  factory PresenceModel.fromJson(Map<dynamic, dynamic> json) {
    return PresenceModel(
      online: json['online'] ?? false,
      lastSeen: json['lastSeen'] ?? 0,
    );
  }
}
