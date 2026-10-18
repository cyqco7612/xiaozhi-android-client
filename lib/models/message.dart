enum MessageRole { user, assistant, system }

class Message {
  final String id;
  final String conversationId;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final bool isImage;
  final String? imageLocalPath;
  final String? fileId;
  /// 语音消息等待 ASR 识别结果时的占位状态，UI 上显示转圈
  final bool isPending;

  Message({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.isImage = false,
    this.imageLocalPath,
    this.fileId,
    this.isPending = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversationId'],
      role: MessageRole.values.byName(json['role']),
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      isImage: json['isImage'] ?? false,
      imageLocalPath: json['imageLocalPath'],
      fileId: json['fileId'],
      // 历史数据没有该字段时默认为 false；pending 状态不持久化语义，按已完成处理
      isPending: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'role': role.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isImage': isImage,
      'imageLocalPath': imageLocalPath,
      'fileId': fileId,
    };
  }
}
