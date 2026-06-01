import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_response.dart';
import '../services/api_service.dart';
import '../widgets/widget_factory.dart';

// ── Riverpod providers ──────────────────────────────────────────────────────

final apiServiceProvider = Provider<ApiService>((_) => ApiService());

final chatProvider =
    StateNotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);

class ChatState {
  final List<ChatMessage> messages;
  final bool loading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.loading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? loading,
    String? error,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        loading: loading ?? this.loading,
        error: error,
      );
}

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref _ref;
  final String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  ChatNotifier(this._ref) : super(const ChatState());

  Future<void> send(String message) async {
    if (message.trim().isEmpty) return;

    final userMsg = ChatMessage(role: 'user', content: message);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      loading: true,
      error: null,
    );

    final history = state.messages
        .where((m) => m.role == 'user' || m.role == 'assistant')
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();

    try {
      final api = _ref.read(apiServiceProvider);
      final response = await api.sendMessage(
        message: message,
        sessionId: _sessionId,
        history: history,
      );

      final assistantMsg = ChatMessage(
        role: 'assistant',
        content: response.message,
        response: response,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMsg],
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: 'Connection error. Is the backend running?',
      );
    }
  }
}

// ── Screen ──────────────────────────────────────────────────────────────────

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    ref.read(chatProvider.notifier).send(text);
    Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);

    ref.listen(chatProvider, (_, next) {
      if (!next.loading) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Assistant'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (state.error != null)
            MaterialBanner(
              content: Text(state.error!),
              backgroundColor: Colors.red.shade100,
              actions: [
                TextButton(
                  onPressed: () =>
                      ref.read(chatProvider.notifier).state =
                          state.copyWith(error: null),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          Expanded(
            child: state.messages.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: state.messages.length,
                    itemBuilder: (_, i) =>
                        _MessageBubble(message: state.messages[i]),
                  ),
          ),
          if (state.loading)
            const LinearProgressIndicator(color: Colors.teal),
          _InputBar(controller: _controller, onSend: _send),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.support_agent, size: 64, color: Colors.teal),
          SizedBox(height: 12),
          Text('How can I help you today?',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          SizedBox(height: 6),
          Text('Try: "Show hotels in Dubai" or "Track my order"',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: isUser
            ? _UserBubble(content: message.content)
            : _AssistantBubble(message: message),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String content;

  const _UserBubble({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(content,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  final ChatMessage message;

  const _AssistantBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final response = message.response;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.content,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
          if (response != null && response.uiType != 'text_page') ...[
            const SizedBox(height: 10),
            buildResponseWidget(response),
          ],
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 4, offset: const Offset(0, -1))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: 'Ask me anything...',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            onPressed: onSend,
            backgroundColor: Colors.teal,
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
