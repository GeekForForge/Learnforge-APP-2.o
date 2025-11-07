import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;

  const ChatInputField({Key? key, required this.onSend}) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late TextEditingController _controller;
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() => _isEmpty = _controller.text.isEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassMorphicCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.emoji_emotions_outlined),
              color: AppColors.accent,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.textMuted),
                ),
                style: const TextStyle(color: AppColors.textLight),
                maxLines: null,
              ),
            ),
            AnimatedOpacity(
              opacity: !_isEmpty ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                onPressed: !_isEmpty
                    ? () {
                        widget.onSend(_controller.text);
                        _controller.clear();
                      }
                    : null,
                icon: const Icon(Icons.send),
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
