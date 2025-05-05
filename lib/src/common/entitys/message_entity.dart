class MessageEntity {
  final String id;
  final String senderId;
  final String message;
  final DateTime timestamp;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });
  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    final rawTimestamp = json['timestamp'];
    final timestamp = rawTimestamp is int
        ? DateTime.fromMillisecondsSinceEpoch(rawTimestamp)
        : DateTime.fromMillisecondsSinceEpoch(
            int.tryParse(rawTimestamp.toString()) ?? 0);

    return MessageEntity(
      id: json['id'].toString(),
      senderId: json['senderId'].toString(),
      message: json['message'].toString(),
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
