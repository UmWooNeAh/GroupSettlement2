import 'package:http/http.dart' as http;

class FirebaseAuthRemoteDataSource {
  final String url = 'https://asia-northeast3-fir-df691.cloudfunctions.net/createCustomToken';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse = await http
        .post(Uri.parse(url), body: user);
    return customTokenResponse.body;
  }

}