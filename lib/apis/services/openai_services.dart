import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? openaiKey = dotenv.env['OPENAI_KEY'];

String? apiKey = openaiKey;
const apiUrl = 'https://api.openai.com/v1/chat/completions';

Future<List<String>> generateSubGoals(String coreGoal) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content":
              "You are a helpful assistant who provides concise and goal-oriented suggestions."
        },
        {
          "role": "user",
          "content":
              "만다라트를 작성하려고 해. 최종목표가 '$coreGoal'(이)라고 할 때, 최종목표를 달성하기 위해 해야하는 세부목표 6가지를 10글자 이내로 추천해줘. 세부목표는 간결한 구 형태이면 좋겠어. 예를 들어, 최종목표가 '뿌듯한 25-1 학교생활 보내기'라면 '스펙 쌓기', '자기관리하기','돈 많이 모으기', '다양한 사람 만나보기', '내가 뭘 좋아하는지 찾기' 등이 있을 것 같아. 구체적이고 개인적인 내용이어도 좋으니 20대 여성 그중에서도 대학생이 많이 공감할만한 내용으로 추천해줘. 답변으로는 너가 추천하는 6가지 항목만 작성해줘."
        }
      ],
      "max_tokens": 150,
      "temperature": 0.7,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
        'Failed to connect: ${response.statusCode}, ${response.body}');
  }

  Map<String, dynamic> responseData =
      jsonDecode(utf8.decode(response.bodyBytes));

  // 디버그 콘솔에 API 응답 데이터 출력
  print("OpenAI Response: $responseData");

  if (responseData['choices'] == null || responseData['choices'].isEmpty) {
    throw Exception('Invalid API response: ${response.body}');
  }

  String content = responseData['choices'][0]['message']['content'];

  // 응답을 줄 단위로 나누고 숫자 제거
  return content
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'^\d+\.?\s*'), '').trim())
      .where((line) => line.isNotEmpty)
      .take(6)
      .toList();
}

Future<List<String>> generateThirdGoals(
    String coreGoal, String secondGoal) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content":
              "You are a helpful assistant who provides concise and goal-oriented suggestions."
        },
        {
          "role": "user",
          "content":
              "만다라트를 작성하려고 해. 최종목표는 '$coreGoal'이고, 세부목표가 '$secondGoal'(이)라고 할 때, 세부목표를 달성하기 위해 해야하는 실행계획 6가지를 추천해줘. 각 실행계획은 명사나 간결한 구 형태로 작성해주고 13글자 이내였으면 좋겠어. 예를 들어, 세부목표가 '스펙 쌓기'라면 '동아리/학회 활동하기', '공모전 준비하기' 등이 있을 것 같아. 구체적이고 개인적인 내용이어도 좋으니 20대 여성 그중에서도 대학생이 많이 공감할만한 내용으로 추천해줘. 답변으로는 추가 문장이나 기호 등 어떠한 것도 덧붙이지 말고, 너가 추천하는 6가지 항목만 탭으로 구분해서 작성해줘."
        }
      ],
      "max_tokens": 150,
      "temperature": 0.7,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
        'Failed to connect: ${response.statusCode}, ${response.body}');
  }

  Map<String, dynamic> responseData =
      jsonDecode(utf8.decode(response.bodyBytes));

  if (responseData['choices'] == null || responseData['choices'].isEmpty) {
    throw Exception('Invalid API response: ${response.body}');
  }

  String content = responseData['choices'][0]['message']['content'];

  // 응답을 줄 단위로 나누고 숫자 제거
  return content
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'^\d+\.?\s*'), '').trim())
      .where((line) => line.isNotEmpty)
      .take(6)
      .toList();
}
