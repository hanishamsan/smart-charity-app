import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: FutureBuilder(
        future: Future.wait([
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),

          FirebaseFirestore.instance
              .collection('donations')
              .where('userId', isEqualTo: user.uid)
              .get(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          final userDoc = snapshot.data![0] as DocumentSnapshot;
          final donationDocs = snapshot.data![1] as QuerySnapshot;

          final userData = userDoc.data() as Map<String, dynamic>;

          String fullName = userData['fullName'] ?? 'User';

          double totalDonated = (userData['totalDonated'] ?? 0).toDouble();

          int transactionCount = donationDocs.docs.length;

          int campaignSupported = donationDocs.docs
              .map((e) => e['campaignId'].toString())
              .toSet()
              .length;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),

                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,

                        colors: [Color(0xFF0F9D58), Color(0xFF087F3E)],
                      ),
                    ),

                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            "Smart Charity",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          height: 160,

                          child: Lottie.asset(
                            'assets/animations/b09a8bcc-bb15-11ee-a4a8-43cb02701449.json',
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "👋 Welcome Back",
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          fullName.toUpperCase(),
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Thank you for making a difference ❤️",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "RM ${totalDonated.toStringAsFixed(0)}",
                          "Total Donated",
                          Icons.volunteer_activism,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: _buildStatCard(
                          transactionCount.toString(),
                          "Transactions",
                          Icons.receipt_long,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  _buildStatCard(
                    campaignSupported.toString(),
                    "Campaigns Supported",
                    Icons.favorite,
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Recent Donations",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  if (donationDocs.docs.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),

                      child: const Center(child: Text("No donations yet")),
                    ),

                  ...donationDocs.docs
                      .take(3)
                      .map(
                        (doc) => Container(
                          margin: const EdgeInsets.only(bottom: 15),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(20),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.12),

                                blurRadius: 10,

                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),

                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),

                            leading: Container(
                              padding: const EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(.1),

                                shape: BoxShape.circle,
                              ),

                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),

                            title: Text(
                              doc['campaignTitle'],

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),

                              child: Text(
                                "RM ${doc['amount']}",

                                style: const TextStyle(
                                  color: Colors.green,

                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                  const SizedBox(height: 25),

                  const Center(
                    child: Text(
                      "❤️ Keep Making A Difference",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String value, String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),

            blurRadius: 15,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.1),

              borderRadius: BorderRadius.circular(15),
            ),

            child: Icon(icon, color: Colors.green, size: 35),
          ),

          const SizedBox(height: 15),

          Text(
            value,
            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,

            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
