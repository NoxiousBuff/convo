class LiveChatModel {
  final String status;
  final String? animation;
  final List<Map>? medias;
  final String? userMessage;
  final String? liveChatRoomId;

  LiveChatModel({
    this.medias,
    this.animation,
    this.liveChatRoomId,
    required this.status,
    required this.userMessage,
  });

  factory LiveChatModel.fromJson(Map<String, dynamic> json) {
    return LiveChatModel(
      userMessage: json['userMessage'],
      liveChatRoomId: json['liveChatRoomId'],
      status: json['status'],
      animation: json['animation'],
      medias: json['medias'],
    );
  }
}
