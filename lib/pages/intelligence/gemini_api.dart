import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiApi {
  GeminiApi() {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not set');
    }
    _gemini = Gemini.init(apiKey: apiKey);
  }
  late final Gemini _gemini;

  Future<String> ask(String question) async {
    final result = await _gemini.text(question);
    return (result?.content?.parts?.first.text) ?? 'No answer';
  }
}
