import 'package:flutter/material.dart';
import 'package:mintrix/widgets/buttons.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int selectedAnswer = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Soal Minat & Bakat"),
        backgroundColor: const Color(0xFF2B8DD8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "1. Apa yang dimaksud dengan minat?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            _answerOption(
              0,
              "Hal yang membuatmu penasaran dan ingin kamu pelajari",
            ),
            _answerOption(1, "Hal yang membuatmu terpaksa untuk lakukan"),
            _answerOption(2, "Hal yang kamu abaikan"),
            _answerOption(3, "Hal yang tidak kamu sukai"),

            const Spacer(),

            CustomFilledButton(
              title: "Kirim Jawaban",
              variant: selectedAnswer == 0
                  ? ButtonColorVariant.blue
                  : ButtonColorVariant.secondary,
              onPressed: selectedAnswer == 0
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Jawaban benar! +80 XP")),
                      );
                    }
                  : null,
              withShadow: selectedAnswer == 0,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerOption(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedAnswer = index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedAnswer == index
                ? const Color(0xFF2B8DD8)
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
