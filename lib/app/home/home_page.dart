import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stoliki_wyniki/app/home/alert_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScoreTracker();
  }
}

class ScoreTracker extends StatefulWidget {
  const ScoreTracker({Key? key}) : super(key: key);

  @override
  _ScoreTrackerState createState() => _ScoreTrackerState();
}

class _ScoreTrackerState extends State<ScoreTracker> {
  int numberOfPlayers = 2;
  int numberOfCategories = 5;
  List<String> playerNames = List.generate(2, (index) => "Gracz ${index + 1}");
  List<List<String>> scores =
      List.generate(2, (index) => List<String>.filled(5, ''));
  List<int> playerTotalScores = List<int>.generate(2, (index) => 0);
  List<List<TextEditingController?>> controllers = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    setState(() {
      scores = List.generate(
        numberOfPlayers,
        (index) => List<String>.filled(numberOfCategories, ''),
      );
      playerTotalScores = List<int>.generate(numberOfPlayers, (index) => 0);

      controllers = List.generate(
        numberOfPlayers,
        (i) => List.generate(
          numberOfCategories,
          (j) => TextEditingController(),
        ),
      );
    });
  }

  void resetPoints() {
    setState(() {
      scores = List.generate(
        numberOfPlayers,
        (index) => List<String>.filled(numberOfCategories, ''),
      );
      playerTotalScores = List<int>.generate(numberOfPlayers, (index) => 0);
    });

    for (int i = 0; i < controllers.length; i++) {
      for (int j = 0; j < controllers[i].length; j++) {
        controllers[i][j]?.clear();
      }
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < controllers.length; i++) {
      for (int j = 0; j < controllers[i].length; j++) {
        controllers[i][j]?.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('Liczba Graczy: $numberOfPlayers'),
            Slider(
              value: numberOfPlayers.toDouble(),
              min: 2,
              max: 6,
              onChanged: (value) {
                setState(() {
                  numberOfPlayers = value.toInt();
                  playerNames = List.generate(
                    numberOfPlayers,
                    (index) => "Gracz ${index + 1}",
                  );
                  initializeData();
                });
              },
            ),
            const SizedBox(height: 20),
            Text('Liczba Kategorii: $numberOfCategories'),
            Slider(
              value: numberOfCategories.toDouble(),
              min: 1,
              max: 7,
              onChanged: (value) {
                setState(() {
                  numberOfCategories = value.toInt();
                  initializeData();
                });
              },
            ),
            const SizedBox(height: 20),
            for (int playerIndex = 0;
                playerIndex < numberOfPlayers;
                playerIndex++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gracz ${playerIndex + 1}'),
                  Row(
                    children: [
                      for (int categoryIndex = 1;
                          categoryIndex <= numberOfCategories;
                          categoryIndex++)
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: controllers[playerIndex]
                                [categoryIndex - 1],
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9-]'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                scores[playerIndex][categoryIndex - 1] = value;
                                playerTotalScores[playerIndex] =
                                    scores[playerIndex]
                                        .map((e) => int.tryParse(e) ?? 0)
                                        .fold(0, (a, b) => a + b);
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Kat $categoryIndex',
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    List<Map<String, dynamic>> sortedResults = [];
                    for (int i = 0; i < numberOfPlayers; i++) {
                      sortedResults.add({
                        'name': playerNames[i],
                        'score': playerTotalScores[i],
                      });
                    }
                    sortedResults
                        .sort((a, b) => b['score'].compareTo(a['score']));
                    String winnerName = sortedResults[0]['name'];

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlertDialog(
                          sortedResults: sortedResults,
                          winnerName: winnerName,
                          resetPointsFunction: resetPoints,
                        );
                      },
                    );
                  },
                  icon: const Icon(FontAwesomeIcons.calculator),
                  label: const Text('Oblicz wynik'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    resetPoints();
                  },
                  icon: const Icon(FontAwesomeIcons.trash),
                  label: const Text('Wyczyść dane'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
