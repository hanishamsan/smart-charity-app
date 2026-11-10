import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('userId', isEqualTo: user.uid)
            .orderBy('donationDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading history"));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          final donations = snapshot.data!.docs;

          double totalDonated = 0;

          for (var doc in donations) {
            final data = doc.data() as Map<String, dynamic>;
            totalDonated += (data['amount'] ?? 0).toDouble();
          }

          if (donations.isEmpty) {
            return const Center(
              child: Text(
                "No Donation History",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: const Color(0xFF0F9D58),

                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,

                  title: const Text(
                    "History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F9D58), Color(0xFF087F3E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),

                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Text(
                              "Donation History",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white24,
                              child: Icon(
                                Icons.history,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,

                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        donations.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      const Text(
                                        "Donations",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.white30,
                                  ),

                                  Column(
                                    children: [
                                      Text(
                                        "RM ${totalDonated.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      const Text(
                                        "Total Given",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(20),

                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final donation =
                        donations[index].data() as Map<String, dynamic>;

                    Timestamp? timestamp =
                        donation['donationDate'] as Timestamp?;

                    if (timestamp == null) {
                      return const SizedBox();
                    }

                    DateTime date = timestamp.toDate().toLocal();

                    String campaignTitle =
                        donation['campaignTitle'] ?? "Unknown Campaign";

                    String paymentMethod = donation['paymentMethod'] ?? "N/A";

                    double amount = (donation['amount'] ?? 0).toDouble();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.12),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(20),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),

                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(.1),
                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.green,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    campaignTitle,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            Text(
                              "RM ${amount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(.1),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                paymentMethod,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: 8),

                                Text(DateFormat('dd MMM yyyy').format(date)),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: 8),

                                Text(DateFormat('hh:mm a').format(date)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: donations.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
