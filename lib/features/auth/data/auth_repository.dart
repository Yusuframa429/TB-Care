import 'package:core_services/core_services.dart';

class AuthRepository {
  static final AuthRepository instance = AuthRepository._();
  AuthRepository._();

  final StorageService _storage = StorageService.instance;
  
  static const String _authBox = 'auth_box';
  static const String _usersBox = 'users_box';
  static const String _currentUserKey = 'current_user';

  /// Mendaftarkan user baru ke dalam lokal (Hive).
  /// Mengembalikan pesan error jika gagal, atau null jika berhasil.
  Future<String?> register({
    required String name,
    required String username,
    required String password,
  }) async {
    // Cek apakah username sudah ada
    final existingUser = await _storage.get<Map<dynamic, dynamic>>(_usersBox, username);
    if (existingUser != null) {
      return 'Username sudah terdaftar';
    }

    // Simpan user baru
    final userData = {
      'name': name,
      'username': username,
      'password': password, // PERINGATAN: Di aplikasi nyata, password harus di-hash (misal bcrypt)
    };

    await _storage.put(_usersBox, username, userData);
    return null; // Sukses
  }

  /// Melakukan login. Mengembalikan pesan error jika gagal, atau null jika berhasil.
  Future<String?> login({
    required String username,
    required String password,
  }) async {
    final userData = await _storage.get<Map<dynamic, dynamic>>(_usersBox, username);
    
    if (userData == null) {
      return 'Username tidak ditemukan';
    }

    if (userData['password'] != password) {
      return 'Password salah';
    }

    // Simpan sesi login
    await _storage.put(_authBox, _currentUserKey, username);
    return null; // Sukses
  }

  /// Mendapatkan username yang sedang login (jika ada).
  Future<String?> getCurrentUser() async {
    return await _storage.get<String>(_authBox, _currentUserKey);
  }

  /// Mengambil data user detail yang sedang login.
  Future<Map<dynamic, dynamic>?> getCurrentUserData() async {
    final username = await getCurrentUser();
    if (username == null) return null;
    return await _storage.get<Map<dynamic, dynamic>>(_usersBox, username);
  }

  /// Logout (menghapus sesi)
  Future<void> logout() async {
    await _storage.delete(_authBox, _currentUserKey);
  }
}
