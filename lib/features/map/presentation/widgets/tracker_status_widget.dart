import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackerStatusWidget extends StatefulWidget {
  const TrackerStatusWidget({super.key});

  @override
  State<TrackerStatusWidget> createState() => _TrackerStatusWidgetState();
}

class _TrackerStatusWidgetState extends State<TrackerStatusWidget> {
  Stream<QuerySnapshot<Object?>> getTrackerStatus() {
    return FirebaseFirestore.instance.collection("TrackerStatus").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getTrackerStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Row(
            children: [
              Text('Error'),
              SizedBox(width: 8),
              Icon(Icons.error_outline)
            ],
          );
        }

        bool status = snapshot.data!.docs.first['status'] ?? false;

        return Container(
          margin: const EdgeInsets.only(right: 16.0),
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Color(0xFFE0E0E0),
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          child: Row(
            children: <Widget>[
              Container(
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
              ),
              const SizedBox(width: 8),
              Text(
                status ? 'Online' : 'Offline',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: status ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              )
            ],
          ),
        );
      },
    );
  }
}
