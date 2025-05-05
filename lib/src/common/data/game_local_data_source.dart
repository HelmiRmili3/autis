abstract class GameLocalDataSource {
  Future<String> createUserGameProfile(String user);
}

class GameLocalDataSourceImpl implements GameLocalDataSource {
  // Simulating a local database with a Map
  // final Map<String, Map<String, dynamic>> _localDatabase = {};

  @override
  Future<String> createUserGameProfile(String user) async {
    return "User Game Profile Created";
  }
}
