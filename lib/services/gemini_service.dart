import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {

  // =========================================
  // API KEY
  // =========================================

  static const String apiKey =
      "AIzaSyCvGHkfZgmlnJJAZ8Pzo5bNapzgB6_fdQw";

  // =========================================
  // GENERATE AI RECOMMENDATION
  // =========================================

  static Future<String>
      generateWellnessRecommendation({

    required String phase,
    required int currentDay,
    required String skinType,
    required String activityLevel,
    required int age,
    required List symptoms,
    required String mood,
  }) async {

    try {

      // =========================================
      // WELLNESS KNOWLEDGE
      // =========================================

      const hormonalKnowledge = """

Hormonal Wellness Guidelines:

Menstrual Phase:
- prioritize hydration
- focus on calming skincare
- support iron intake
- prioritize gentle recovery

Follicular Phase:
- energy levels increase
- skin barrier becomes stronger
- support protein intake
- suitable for active routines

Ovulation Phase:
- focus on antioxidants
- balanced nutrition
- lightweight skincare

Luteal Phase:
- hormonal acne may increase
- reduce inflammation
- support magnesium intake
- prioritize emotional balance

IMPORTANT:
- Do not provide medical diagnosis.
- Only provide wellness recommendations.
- Keep response concise and supportive.

""";

      // =========================================
      // PROMPT
      // =========================================

      final prompt = """

You are Lumière Flow AI,
a luxury hormonal wellness assistant for women.

$hormonalKnowledge

USER DATA:

- Current Phase: $phase
- Current Cycle Day: $currentDay
- Skin Type: $skinType
- Activity Level: $activityLevel
- Age: $age
- Symptoms Today: ${symptoms.join(", ")}
- Emotional Mood: $mood

Generate:

1. Daily Skin Ritual
2. Daily Nourishment Advice
3. Emotional Wellness Support

Keep the tone:
- elegant
- feminine
- warm
- supportive

Avoid medical terminology.

""";

      // =========================================
      // URL
      // =========================================

final url = Uri.parse(
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
);

      // =========================================
      // REQUEST
      // =========================================

      final response = await http.post(

        url,

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "contents": [

            {
              "parts": [

                {
                  "text": prompt,
                }

              ]
            }

          ]

        }),
      );

      // =========================================
      // DEBUG
      // =========================================

      print("=================================");
      print("GEMINI STATUS CODE:");
      print(response.statusCode);

      print("=================================");
      print("GEMINI RESPONSE BODY:");
      print(response.body);

      // =========================================
      // DECODE RESPONSE
      // =========================================

      final data =
          jsonDecode(response.body);

      // =========================================
      // SUCCESS
      // =========================================

      if (response.statusCode == 200 &&
          data['candidates'] != null) {

        return data['candidates'][0]
                ['content']['parts'][0]
            ['text'];

      }

      // =========================================
      // ERROR HANDLING
      // =========================================

      if (data['error'] != null) {

        return """
ERROR GEMINI 😭

${data['error']['message']}
""";
      }

      return "Gemini response kosong 😭";

    } catch (e) {

      print("=================================");
      print("GEMINI CATCH ERROR:");
      print(e);

      return """
ERROR CONNECTION 😭

$e
""";
    }
  }
}