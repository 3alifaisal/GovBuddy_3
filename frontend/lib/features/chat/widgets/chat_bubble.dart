/*
  FILE: chat_bubble.dart
  DESCRIPTION:
  A reusable UI widget responsible for rendering a single chat message bubble.
  Handles visual distinction based on the message sender:
  
  - User Messages: Aligned to the right, using the primary accent color.
  - System/Bot Messages: Aligned to the left, using a neutral gray background.
*/
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe; // Mesaj benden mi yoksa bottan mı?

  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width *
              0.75, // Ekranın %75'ini kaplasın
        ),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(0xFFCE000C)
              : Colors.grey[300], // Ben: Kırmızı, Bot: Gri
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMe
                ? const Radius.circular(15)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
