import 'package:flutter/material.dart';

/// [ChatHeader] - Header halaman chat berisi profil AI dan toggle mode.
///
/// Menampilkan avatar AI, nama, status "Aktif 24/7",
/// serta dua tombol toggle: Mode AI (aktif) dan Chat Dokter (non-aktif).
class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 0.8),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.80, color: Color(0xFFF1F5F9)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProfileRow(),
          const SizedBox(height: 12),
          _buildToggleButtons(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Baris profil: avatar + nama + status online.
  Widget _buildProfileRow() {
    return Row(
      children: [
        // Avatar AI
        Container(
          width: 32,
          height: 32,
          decoration: const ShapeDecoration(
            color: Color(0xFFF1F5F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(999)),
            ),
          ),
          child: const Icon(Icons.auto_awesome, size: 18, color: Color(0xFF059669)),
        ),
        const SizedBox(width: 12),
        // Nama & status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Asisten TBC',
                style: TextStyle(
                  color: Color(0xFF1D293D),
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF00C950),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(999)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Aktif 24/7',
                    style: TextStyle(
                      color: Color(0xFF90A1B9),
                      fontSize: 11,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Dua tombol toggle: Mode AI (active) dan Chat Dokter (inactive).
  Widget _buildToggleButtons() {
    return Row(
      children: [
        // Tombol Mode AI — aktif (gradient hijau)
        Expanded(
          child: _ToggleButton(
            isActive: true,
            icon: Icons.auto_awesome,
            label: 'Mode AI',
          ),
        ),
        const SizedBox(width: 8),
        // Tombol Chat Dokter — non-aktif (abu-abu)
        Expanded(
          child: _ToggleButton(
            isActive: false,
            icon: Icons.local_hospital,
            label: 'Chat Dokter',
          ),
        ),
      ],
    );
  }
}

/// Widget internal untuk satu tombol toggle.
class _ToggleButton extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final String label;

  const _ToggleButton({
    required this.isActive,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: ShapeDecoration(
        gradient: isActive
            ? const LinearGradient(
                begin: Alignment(0.00, 0.00),
                end: Alignment(1.00, 1.00),
                colors: [Color(0xFF059669), Color(0xFF14B8A6)],
              )
            : null,
        color: isActive ? null : const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(999)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 13,
            color: isActive ? Colors.white : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF94A3B8),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}
