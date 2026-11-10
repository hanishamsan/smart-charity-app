import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/campaign_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('charity_locations')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allLocations = snapshot.data!.docs;

          final locations = allLocations.where((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final name = data['name'].toString().toLowerCase();

            return name.contains(searchText.toLowerCase());
          }).toList();

          return Stack(
            children: [
              FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(1.4927, 103.7414),
                  initialZoom: 11,
                ),

                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.smart_charity',
                  ),

                  MarkerLayer(
                    markers: locations.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      final double lat = (data['latitude'] as num).toDouble();

                      final double lng = (data['longitude'] as num).toDouble();

                      return Marker(
                        point: LatLng(lat, lng),

                        width: 80,
                        height: 80,

                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,

                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        data['name'],
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      Text(data['description']),

                                      const SizedBox(height: 10),

                                      Text(
                                        "Campaign: ${data['campaignTitle']}",
                                      ),

                                      const SizedBox(height: 15),

                                      SizedBox(
                                        width: double.infinity,

                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => CampaignScreen(
                                                  selectedCampaign:
                                                      data['campaignTitle'],
                                                ),
                                              ),
                                            );
                                          },

                                          child: const Text("View Campaign"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },

                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: searchController,

                    decoration: InputDecoration(
                      hintText: 'Search charity location...',
                      prefixIcon: const Icon(Icons.search),

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
