import '../../domain/entities/question.dart';

/// Daftar lengkap pertanyaan untuk kuesioner AI Cek TBC.
const List<ScreeningQuestion> screeningQuestions = [
  // --- Gejala Utama ---
  ScreeningQuestion(
    id: 'G1',
    text: 'Apakah Anda mengalami batuk dalam 2-3 minggu terakhir?',
    options: [
      QuestionOption(text: 'Tidak', score: 0, shortText: 'Batuk > 2 minggu'),
      QuestionOption(
        text: 'Ya, < 2 minggu',
        score: 1,
        shortText: 'Batuk > 2 minggu',
      ),
      QuestionOption(
        text: 'Ya, 2-3 minggu',
        score: 2,
        shortText: 'Batuk > 2 minggu',
      ),
      QuestionOption(
        text: 'Ya, > 3 minggu',
        score: 3,
        shortText: 'Batuk > 2 minggu',
      ),
    ],
  ),
  ScreeningQuestion(
    id: 'G2',
    text:
        'Apakah Anda batuk berdahak? Jika ya, apakah dahaknya berdarah atau berwarna karat?',
    options: [
      QuestionOption(
        text: 'Tidak',
        score: 0,
        shortText: 'Batuk berdahak/berdarah',
      ),
      QuestionOption(
        text: 'Ya, dahak biasa',
        score: 1,
        shortText: 'Batuk berdahak/berdarah',
      ),
      QuestionOption(
        text: 'Ya, bercampur darah',
        score: 3,
        shortText: 'Batuk berdahak/berdarah',
      ),
    ],
  ),
  ScreeningQuestion(
    id: 'G3',
    text:
        'Apakah Anda mengalami demam yang tidak kunjung sembuh dalam 2 minggu terakhir?',
    options: [
      QuestionOption(text: 'Tidak', score: 0, shortText: 'Demam persisten'),
      QuestionOption(
        text: 'Ya, demam ringan',
        score: 1,
        shortText: 'Demam persisten',
      ),
      QuestionOption(
        text: 'Ya, demam tinggi >38°C',
        score: 2,
        shortText: 'Demam persisten',
      ),
    ],
  ),

  // --- Gejala Sekunder ---
  ScreeningQuestion(
    id: 'G4',
    text:
        'Apakah Anda sering berkeringat di malam hari (keringat malam) tanpa sebab yang jelas?',
    options: [
      QuestionOption(text: 'Tidak', score: 0, shortText: 'Berkeringat malam'),
      QuestionOption(
        text: 'Ya, sesekali',
        score: 1,
        shortText: 'Berkeringat malam',
      ),
      QuestionOption(
        text: 'Ya, hampir setiap malam',
        score: 2,
        shortText: 'Berkeringat malam',
      ),
    ],
  ),
  ScreeningQuestion(
    id: 'G5',
    text:
        'Apakah berat badan Anda menurun tanpa disengaja dalam 1-2 bulan terakhir?',
    options: [
      QuestionOption(text: 'Tidak', score: 0, shortText: 'Berat badan menurun'),
      QuestionOption(
        text: 'Ya, turun 1-3 kg',
        score: 1,
        shortText: 'Berat badan menurun',
      ),
      QuestionOption(
        text: 'Ya, turun >3 kg (baju longgar)',
        score: 2,
        shortText: 'Berat badan menurun',
      ),
    ],
  ),
  ScreeningQuestion(
    id: 'G6',
    text:
        'Apakah Anda merasa lemas, lesu, atau mudah lelah dalam beberapa minggu terakhir?',
    options: [
      QuestionOption(text: 'Tidak', score: 0, shortText: 'Lemas/mudah lelah'),
      QuestionOption(
        text: 'Ya, sesekali',
        score: 1,
        shortText: 'Lemas/mudah lelah',
      ),
      QuestionOption(
        text: 'Ya, hampir setiap hari',
        score: 2,
        shortText: 'Lemas/mudah lelah',
      ),
    ],
  ),
  ScreeningQuestion(
    id: 'G7',
    text:
        'Apakah Anda mengalami sesak nafas atau nyeri dada saat menarik nafas dalam?',
    options: [
      QuestionOption(
        text: 'Tidak',
        score: 0,
        shortText: 'Sesak nafas/nyeri dada',
      ),
      QuestionOption(
        text: 'Ya, sesak nafas saat beraktivitas',
        score: 2,
        shortText: 'Sesak nafas/nyeri dada',
      ),
      QuestionOption(
        text: 'Ya, nyeri dada tajam',
        score: 2,
        shortText: 'Sesak nafas/nyeri dada',
      ),
    ],
  ),

  // --- Faktor Risiko ---
  ScreeningQuestion(
    id: 'R1',
    text:
        'Apakah Anda pernah kontak erat (tinggal serumah/sering bersama) dengan penderita TBC dalam 1 tahun terakhir?',
    options: [
      QuestionOption(text: 'Tidak', score: 0, shortText: 'Kontak erat'),
      QuestionOption(
        text: 'Ya, kontak jarak jauh',
        score: 1,
        shortText: 'Kontak erat',
      ),
      QuestionOption(
        text: 'Ya, kontak dekat/sering',
        score: 2,
        shortText: 'Kontak erat',
      ),
    ],
  ),
  ScreeningQuestion(
    id: 'R2',
    text: 'Apakah Anda memiliki riwayat penyakit diabetes atau HIV?',
    options: [
      QuestionOption(text: 'Tidak', score: 0, shortText: 'Komorbid (DM/HIV)'),
      QuestionOption(
        text: 'Ya, diabetes',
        score: 1,
        shortText: 'Komorbid (DM/HIV)',
      ),
      QuestionOption(text: 'Ya, HIV', score: 2, shortText: 'Komorbid (DM/HIV)'),
      QuestionOption(
        text: 'Ya, keduanya',
        score: 3,
        shortText: 'Komorbid (DM/HIV)',
      ),
    ],
  ),
  ScreeningQuestion(
    id: 'R3',
    text: 'Apakah Anda pernah menderita TBC sebelumnya?',
    options: [
      QuestionOption(text: 'Tidak', score: 0, shortText: 'Riwayat TBC'),
      QuestionOption(
        text: 'Ya, sudah sembuh >2 tahun',
        score: 1,
        shortText: 'Riwayat TBC',
      ),
      QuestionOption(
        text: 'Ya, dalam 2 tahun terakhir',
        score: 2,
        shortText: 'Riwayat TBC',
      ),
    ],
  ),

  // --- Durasi & Frekuensi ---
  ScreeningQuestion(
    id: 'T1',
    text:
        'Seberapa lama gejala-gejala di atas sudah Anda rasakan secara keseluruhan?',
    options: [
      QuestionOption(text: '< 1 minggu', score: 0, shortText: 'Durasi gejala'),
      QuestionOption(text: '1-2 minggu', score: 1, shortText: 'Durasi gejala'),
      QuestionOption(text: '> 2 minggu', score: 2, shortText: 'Durasi gejala'),
    ],
  ),
];
