import 'package:flutter/material.dart';

/// [ChatPage] - Halaman fitur chat / konsultasi.
///
/// Halaman ini menyediakan fitur percakapan (chat) antara pengguna
/// dengan tenaga medis atau chatbot AI untuk berkonsultasi
/// mengenai kondisi kesehatan terkait Tuberkulosis.
///
/// TODO: Implementasi fitur Chat oleh tim.
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Chat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
