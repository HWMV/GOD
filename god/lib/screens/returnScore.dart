import 'package:flutter/material.dart';

class returnScreen extends StatelessWidget {
  final double score;

  const returnScreen({Key? key, required this.score}) : super(key: key);

  String getCommentBasedOnScore(double score) {
    if (score >= 90) {
      return "Are you an idol?! \n  perfect!";
    } else if (score >= 70) {
      return "You seem to \n  have talent \n  as a dancer!";
    } else if (score >= 50) {
      return "  One more spoonful \n  of effort!";
    } else if (score >= 30) {
      return "  It's a shame~ \n  Try practicing a \n  little more!";
    } else {
      return "  I'll do better \n  next time!";
    }
  }

  @override
  Widget build(BuildContext context) {
    String comment = getCommentBasedOnScore(score);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Score!!'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/homeBackground.jpg'), // 경로 수정
                fit: BoxFit.cover, // 변경: BoxFit.fill -> BoxFit.cover
              ),
            ),
          ),
          Center(
            // 점수와 코멘트를 중앙에 배치
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score \n${score.toStringAsFixed(2)}!',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 80,
                    fontFamily: 'Honk',
                    color: Color.fromARGB(255, 81, 81, 81),
                    fontWeight: FontWeight.bold,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 260), // 점수와 코멘트 사이의 간격
                Text(
                  comment,
                  style: const TextStyle(
                      fontSize: 50,
                      fontFamily: 'Honk',
                      color: Color.fromARGB(255, 255, 225, 0),
                      fontWeight: FontWeight.bold,
                      height: 0.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
