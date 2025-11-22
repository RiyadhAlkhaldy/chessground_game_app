import 'package:flutter/material.dart';

// -----------------------------------------------------------
// 🧩 Widgets for displaying the Stockfish analysis
// -----------------------------------------------------------

/// A Linear Progress Bar showing the advantage.
class ScoreProgressBar extends StatelessWidget {
  final double whiteAdvantage;

  const ScoreProgressBar({super.key, required this.whiteAdvantage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // White's advantage bar
          Container(
            width: MediaQuery.of(context).size.width * whiteAdvantage / 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Black's advantage bar
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width:
                  MediaQuery.of(context).size.width *
                  (100 - whiteAdvantage) /
                  100,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A Circular Indicator for the current advantage.
class ScoreCircularIndicator extends StatelessWidget {
  final double whiteAdvantage;

  const ScoreCircularIndicator({super.key, required this.whiteAdvantage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              value: whiteAdvantage / 100,
              backgroundColor: Colors.black,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 8.0,
            ),
          ),
          ScoreText(whiteAdvantage: whiteAdvantage),
        ],
      ),
    );
  }
}

/// A Text Widget to display the exact score percentage.
class ScoreText extends StatelessWidget {
  final double whiteAdvantage;

  const ScoreText({super.key, required this.whiteAdvantage});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    if (whiteAdvantage > 50) {
      text = '${whiteAdvantage.toStringAsFixed(1)}% White';
      color = Colors.white;
    } else {
      text = '${(100 - whiteAdvantage).toStringAsFixed(1)}% Black';
      color = Colors.black;
    }

    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    );
  }
}

// -----------------------------------------------------------
// 🎮 Main Application
// -----------------------------------------------------------
