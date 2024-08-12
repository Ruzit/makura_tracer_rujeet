import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:makura_tracer/features/map/presentation/widgets/tracker_status_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Stream<QuerySnapshot<Object?>> getData() {
    return FirebaseFirestore.instance.collection("Location").snapshots();
  }

  final MapController _mapController = MapController();

  LatLng? latLng;

  List<LatLng> polyPointList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map Page',
        ),
        backgroundColor: Colors.white.withOpacity(0.8),
        actions: const [
          TrackerStatusWidget(),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: StreamBuilder<QuerySnapshot>(
          stream: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            }

            DocumentSnapshot? doc = snapshot.data?.docs.first;

            if (doc != null) {
              if (latLng == null) {
                latLng = LatLng(doc['latitude'], doc['longitude']);
                polyPointList.add(latLng!);
              } else {
                latLng = LatLng(doc['latitude'], doc['longitude']);
                polyPointList.add(latLng!);
                _mapController.move(latLng!, 17);
              }
            }

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: doc != null
                    ? LatLng(doc['latitude'], doc['longitude'])
                    : const LatLng(
                        27.67880736306128,
                        85.38077836463842,
                      ), // Center the map over London
                initialZoom: 17,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  maxNativeZoom: 19,
                ),
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: null, // (external)
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polyPointList,
                      color: Colors.blue,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: doc != null
                          ? LatLng(doc['latitude'], doc['longitude'])
                          : const LatLng(51.5, -0.09),
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff0000FF),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
