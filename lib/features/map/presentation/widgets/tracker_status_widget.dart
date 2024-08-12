import 'package:flutter/material.dart';

class TrackerStatusWidget extends StatelessWidget {
  final bool status;
  const TrackerStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status ? Colors.green : Colors.red,
        boxShadow: [
          BoxShadow(
            color: status ? Colors.green : Colors.red,
            spreadRadius: 1,
            blurRadius: 2,
          )
        ],
      ),
    );
  }
}
