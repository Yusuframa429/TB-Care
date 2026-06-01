import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ChatTypingIndicator] - Widget indikator "AI sedang mengetik...".
///
/// Menampilkan avatar robot AI di kiri dan animasi 3 titik berkedip
/// di dalam bubble pesan, menandakan bahwa AI sedang memproses
/// respons dari server.
class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({super.key});

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar robot AI.
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),

          /// Bubble dengan animasi titik.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    // Setiap dot mulai bergerak pada phase yang berbeda.
                    final delay = index * 0.2;
                    final progress = (_controller.value - delay).clamp(
                      0.0,
                      1.0,
                    );

                    // Bounce effect: naik di paruh pertama, turun di paruh kedua.
                    final bounce = progress < 0.5
                        ? progress * 2
                        : 2.0 - (progress * 2);

                    return Padding(
                      padding: EdgeInsets.only(right: index < 2 ? 5 : 0),
                      child: Transform.translate(
                        offset: Offset(0, -4 * bounce),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(
                              alpha: 0.4 + (0.6 * bounce),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
