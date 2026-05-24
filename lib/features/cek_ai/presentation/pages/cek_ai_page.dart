import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../domain/entities/question.dart';
import '../../domain/usecases/calculate_screening_result.dart';
import '../../data/datasources/screening_questions.dart';
import 'hasil_pemeriksaan_page.dart';

import '../../../profil/data/models/riwayat_pemeriksaan_model.dart';
import '../../../profil/data/repositories/riwayat_pemeriksaan_repository.dart';

import '../widgets/cek_ai_header.dart';
import '../widgets/cek_ai_step_indicator.dart';
import '../widgets/cek_ai_message_bubble.dart';
import '../widgets/user_message_bubble.dart';

class ChatMessage {
  final bool isAi;
  final String text;

  ChatMessage({required this.isAi, required this.text});
}

/// [CekAiPage] - Halaman fitur pengecekan kesehatan berbasis AI.
class CekAiPage extends StatefulWidget {
  const CekAiPage({super.key});

  @override
  State<CekAiPage> createState() => _CekAiPageState();
}

class _CekAiPageState extends State<CekAiPage> {
  final ScrollController _scrollController = ScrollController();
  final CalculateScreeningResult _calculateResult = CalculateScreeningResult();

  int _currentQuestionIndex = 0;
  final List<ChatMessage> _chatHistory = [];
  final Map<String, QuestionOption> _answers = {};

  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    // Tambahkan pertanyaan pertama saat inisialisasi
    _addAiQuestion();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addAiQuestion() {
    if (_currentQuestionIndex < screeningQuestions.length) {
      final currentQ = screeningQuestions[_currentQuestionIndex];
      String text = currentQ.text;

      // Beri intro di pertanyaan pertama
      if (_currentQuestionIndex == 0) {
        text = 'Halo! Saya AI asisten kesehatan TBC. Mari kita mulai skrining awal Anda.\n\n$text';
      }

      _chatHistory.add(ChatMessage(isAi: true, text: text));
    }
  }

  void _onOptionSelected(QuestionOption option) async {
    if (_isAnalyzing) return;

    final currentQ = screeningQuestions[_currentQuestionIndex];
    _answers[currentQ.id] = option;

    setState(() {
      // Masukkan jawaban user ke chat
      _chatHistory.add(ChatMessage(isAi: false, text: option.text));
      _currentQuestionIndex++;

      // Cek apakah ada pertanyaan selanjutnya
      if (_currentQuestionIndex < screeningQuestions.length) {
        _addAiQuestion();
      } else {
        // Skrining selesai
        _isAnalyzing = true;
        _chatHistory.add(ChatMessage(
          isAi: true,
          text: 'Terima kasih telah menjawab semua pertanyaan. Sedang menganalisis hasil...',
        ));
        _finishScreening();
      }
    });

    _scrollToBottom();
  }

  void _finishScreening() async {
    // Simulasi loading analisis AI
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final result = _calculateResult(_answers);

    // Simpan hasil skrining AI ke database lokal secara permanen
    try {
      final now = DateTime.now();
      final id = 'ai_${now.millisecondsSinceEpoch}';
      final riwayat = RiwayatPemeriksaanModel.fromScreeningResult(
        id: id,
        result: result,
        date: now,
      );
      await RiwayatPemeriksaanRepository.instance.addRiwayat(riwayat);
    } catch (e) {
      debugPrint("Gagal menyimpan riwayat skrining AI: $e");
    }
    
    // Reset state jika user kembali dari halaman hasil
    setState(() {
      _currentQuestionIndex = 0;
      _chatHistory.clear();
      _answers.clear();
      _isAnalyzing = false;
      _addAiQuestion();
    });

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HasilPemeriksaanPage(result: result),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200, // extra scroll
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan status progress bar (Step 1, 2, atau 3)
    int currentStep = 1; // Gejala
    if (_currentQuestionIndex >= 4) currentStep = 2; // Detail
    if (_isAnalyzing) currentStep = 3; // Analisis

    final isFinished = _currentQuestionIndex >= screeningQuestions.length;
    final currentQ = isFinished ? null : screeningQuestions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          /// Header AI Asisten
          const CekAiHeader(),

          /// Step indicator dinamis
          CekAiStepIndicator(currentStep: currentStep),

          /// Area chat
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final chat = _chatHistory[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: chat.isAi
                      ? CekAiMessageBubble(
                          message: chat.text,
                          timestamp: 'AI', // placeholder sederhana
                        )
                      : UserMessageBubble(
                          message: chat.text,
                        ),
                );
              },
            ),
          ),

          /// Area input/opsi
          if (currentQ != null && !_isAnalyzing)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: currentQ.options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ElevatedButton(
                        onPressed: () => _onOptionSelected(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          foregroundColor: AppColors.primaryDark,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        child: Text(
                          option.text,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
          // Jika sedang menganalisis, tampilkan loading statis
          if (_isAnalyzing)
            Container(
              padding: const EdgeInsets.all(24),
              color: AppColors.white,
              child: const SafeArea(
                top: false,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
