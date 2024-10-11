import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Stack(
          children: [
            Positioned(
                child: Column(
                    children: [
                      Image.asset("assets/leaderboard/leaderboard.png",
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 25,
                        child: Image.asset("assets/leaderboard/line.png",
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                )
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height / 1.9,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: 
                BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)
                )
            ),
          ),
        ),
        const Positioned(
          top: 70,
            right: 150,
            child: Text("Leaderboard",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )
        )

      ],
    ),
  );
  }

}