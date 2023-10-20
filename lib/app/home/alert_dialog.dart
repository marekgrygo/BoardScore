import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final List<Map<String, dynamic>> sortedResults;
  final String winnerName;

  const CustomAlertDialog(
      {super.key, required this.sortedResults, required this.winnerName});

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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
