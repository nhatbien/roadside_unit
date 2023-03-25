import '../../../env_manager.dart';

Uri buildUrl(String unencodedPath, [Map<String, String>? queryParameters]) =>
    Uri.parse(
      EnvManager.shared.apiUrl + unencodedPath,
    );
