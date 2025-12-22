import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../../../core/constants/dummy_data.dart';

final chatProvider = NotifierProvider<ChatNotifier, List<MessageModel>>(() {
  return ChatNotifier();
});

class ChatNotifier extends Notifier<List<MessageModel>> {
  @override
  List<MessageModel> build() {
    return DummyData.getChatMessages();
  }

  void sendMessage(String content) {
    final newMessage = MessageModel(
      id: DateTime.now().toString(),
      senderId: 'user_1',
      senderName: 'You',
      senderAvatar: 'https://via.placeholder.com/40?text=You',
      content: content,
      timestamp: DateTime.now(),
      isUser: true,
    );
    state = [...state, newMessage];

    // Simulate mentor response
    Future.delayed(const Duration(seconds: 1), () {
      final mentorReply = MessageModel(
        id: DateTime.now().toString(),
        senderId: 'mentor_1',
        senderName: 'Your Mentor',
        senderAvatar: 'https://via.placeholder.com/40?text=Mentor',
        content: 'Great question! 💡 Keep learning!',
        timestamp: DateTime.now(),
        isUser: false,
      );
      state = [...state, mentorReply];
    });
  }
}
