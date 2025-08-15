abstract interface class ISecureStorage {
  Future<bool> write({required String key, required String value});

  Future<String?> read({required String key});

  Future<Map<String, String>?> readAll();

  Future<bool> delete({required String key});

  Future<bool> deleteAll();
}
