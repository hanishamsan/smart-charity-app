import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;

        final fullName = userData['fullName'] ?? 'Unknown User';

        final email = userData['email'] ?? user.email ?? '';

        final totalDonated = (userData['totalDonated'] ?? 0).toDouble();

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('donations')
              .where('userId', isEqualTo: user.uid)
              .get(),
          builder: (context, donationSnapshot) {
            int campaignSupported = 0;

            if (donationSnapshot.hasData) {
              final docs = donationSnapshot.data!.docs;

              campaignSupported = docs
                  .map((e) => e['campaignId'].toString())
                  .toSet()
                  .length;
            }

            return Scaffold(
              backgroundColor: const Color(0xFFF5F7FA),

              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // HEADER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 60, bottom: 40),

                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0F9D58), Color(0xFF087F3E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),

                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),

                      child: Column(
                        children: [
                          const Text(
                            "My Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 25),

                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.15),
                                  blurRadius: 15,
                                ),
                              ],
                            ),

                            child: const CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,

                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.green,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            fullName,
                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        children: [
                          // STATS
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  "RM ${totalDonated.toStringAsFixed(0)}",
                                  "Total Donated",
                                  Icons.volunteer_activism,
                                  Colors.green,
                                ),
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: _buildStatCard(
                                  campaignSupported.toString(),
                                  "Campaigns",
                                  Icons.favorite,
                                  Colors.red,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // IMPACT CARD
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.15),
                                  blurRadius: 12,
                                ),
                              ],
                            ),

                            child: Column(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 40,
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Your Impact",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "You have supported $campaignSupported campaign(s) and helped make a difference in people's lives.",
                                  textAlign: TextAlign.center,

                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // LOGOUT BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 55,

                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.logout),

                              label: const Text(
                                "Logout",
                                style: TextStyle(fontSize: 16),
                              ),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,

                                foregroundColor: Colors.white,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),

                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();

                                Navigator.pushAndRemoveUntil(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),

                                  (route) => false,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(
    String value,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(.15), blurRadius: 12),
        ],
      ),

      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: color.withOpacity(.1),

              borderRadius: BorderRadius.circular(15),
            ),

            child: Icon(icon, color: color, size: 30),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            textAlign: TextAlign.center,

            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
