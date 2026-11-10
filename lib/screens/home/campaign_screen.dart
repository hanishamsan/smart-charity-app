import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/campaign_service.dart';
import 'donation_screen.dart';

class CampaignScreen extends StatelessWidget {
  final String? selectedCampaign;

  const CampaignScreen({super.key, this.selectedCampaign});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Campaigns")),

      body: StreamBuilder<QuerySnapshot>(
        stream: CampaignService().getCampaigns(),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final campaigns = snapshot.data!.docs;

          if (campaigns.isEmpty) {
            return const Center(child: Text("No Campaign Available"));
          }

          List<QueryDocumentSnapshot> filteredCampaigns = campaigns;

          if (selectedCampaign != null) {
            filteredCampaigns = campaigns.where((doc) {
              return doc['title'] == selectedCampaign;
            }).toList();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filteredCampaigns.length,

            itemBuilder: (context, index) {
              var campaign = filteredCampaigns[index];

              String campaignId = campaign.id;
              String title = campaign['title'];
              String description = campaign['description'];

              double target = (campaign['targetAmount'] as num).toDouble();

              double current = (campaign['currentAmount'] as num).toDouble();

              double progress = current / target;

              if (progress > 1) {
                progress = 1;
              }

              // IMAGE MAPPING
              String imagePath = 'assets/images/floodrelief.png';

              if (title == "Community Food Aid Distribution Program") {
                imagePath = 'assets/images/foodaid.png';
              } else if (title ==
                  "Education Fund for Underprivileged Students") {
                imagePath = 'assets/images/educationalfund.png';
              } else if (title ==
                  "Monthly Support Program for Orphanage Homes") {
                imagePath = 'assets/images/orphanage.png';
              } else if (title ==
                  "Flood Relief Assistance for Affected Families in Johor") {
                imagePath = 'assets/images/floodrelief.png';
              }

              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 16),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),

                        child: Image.asset(
                          imagePath,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 15),

                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${(progress * 100).toStringAsFixed(0)}% Funded",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "RM ${current.toStringAsFixed(0)} / RM ${target.toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DonationScreen(
                                  campaignId: campaignId,
                                  campaignTitle: title,
                                ),
                              ),
                            );
                          },

                          icon: const Icon(Icons.favorite),

                          label: const Text("Donate Now"),

                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
