import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../../core/constants.dart';
import '../../../services/api_service.dart';
import '../../../models/category.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDarkMode;
  final Color? bubbleColor;

  const ChatBubble({
    super.key, 
    required this.message, 
    this.isDarkMode = false,
    this.bubbleColor,
  });

  @override
  Widget build(BuildContext context) {
    // Current design uses light mode primarily as per AppColors in constants
    // If we want true dark mode support we need to check how AppColors handles it.
    // For now, let's stick to the current DetailView palette.
    
    final isUser = message.role == 'user';
    final panelColor = AppColors.panel;
    final textColor = AppColors.textPrimary;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Icon

          // Bubble Content
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? (bubbleColor ?? AppColors.primary) : panelColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: isUser ? [
                   BoxShadow(
                      color: (bubbleColor ?? AppColors.primary).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                   )
                ] : AppShadows.soft,
              ),
              child: isUser
                  ? SelectableText(
                      message.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    )
                  : MarkdownBody(
                      data: message.content,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 16, height: 1.6, color: AppColors.textPrimary),
                        h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
                        h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
                        code: const TextStyle(backgroundColor: Color(0xFFEEEEEE), fontSize: 14),
                        codeblockDecoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        listBullet: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                        a: const TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                      ),
                    ),
            ),
          ),
          
          // User Spacer (balance)
          if (isUser) const SizedBox(width: 32),
          if (!isUser) const SizedBox(width: 32),
        ],
      ),
    );
  }
}
