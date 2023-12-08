import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final List<Map<String, dynamic>> sortedResults;
  final String winnerName;
  final VoidCallback resetPointsFunction;

  const CustomAlertDialog({
    Key? key,
    required this.sortedResults,
    required this.winnerName,
    required this.resetPointsFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wyniki'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int index = 0; index < sortedResults.length; index++)
            Text(
              '${sortedResults[index]['name']}: ${sortedResults[index]['score']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10),
          Text('Zwycięzca: $winnerName'),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
