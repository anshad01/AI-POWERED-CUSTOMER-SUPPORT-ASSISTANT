class ChatResponse {
  final String intent;
  final String toolCalled;
  final String uiType;
  final String message;
  final Map<String, dynamic> data;

  const ChatResponse({
    required this.intent,
    required this.toolCalled,
    required this.uiType,
    required this.message,
    required this.data,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        intent: json['intent'] as String? ?? 'general',
        toolCalled: json['tool_called'] as String? ?? 'none',
        uiType: json['ui_type'] as String? ?? 'text_page',
        message: json['message'] as String? ?? '',
        data: (json['data'] as Map<String, dynamic>?) ?? {},
      );
}


class ChatMessage {
  final String role; // "user" | "assistant"
  final String content;
  final ChatResponse? response;

  const ChatMessage({
    required this.role,
    required this.content,
    this.response,
  });
}
