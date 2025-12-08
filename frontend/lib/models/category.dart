import 'package:flutter/material.dart';
import '../core/constants.dart'; // For AppLang

/// Simple data model describing a category tile.
class Category {
  final String id;
  final LocalizedText title;
  final LocalizedText subtitle;
  final Color color;

  const Category({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

/// Full localized content for a category detail view.
class LocalizedDetail {
  final LocalizedText intro;
  final LocalizedList requiredDocuments;
  final LocalizedList importantInfo;
  final LocalizedList sources;
  final LocalizedList relatedTopics;

  const LocalizedDetail({
    required this.intro,
    required this.requiredDocuments,
    required this.importantInfo,
    required this.sources,
    required this.relatedTopics,
  });
}

/// Text in both German and English.
class LocalizedText {
  final String de;
  final String en;
  const LocalizedText({required this.de, required this.en});

  /// Returns the text in the requested language.
  String of(AppLang lang) => lang == AppLang.de ? de : en;
}

/// Lists in both German and English.
class LocalizedList {
  final List<String> de;
  final List<String> en;
  const LocalizedList({required this.de, required this.en});

  /// Returns the list in the requested language.
  List<String> of(AppLang lang) => lang == AppLang.de ? de : en;
}

/// A chat message in the conversation.
class ChatMessage {
  final String role; // 'user' or 'assistant' or 'system'
  final String content;

  const ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }
}
