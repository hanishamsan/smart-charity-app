import 'package:flutter/material.dart';
import '../../services/campaign_service.dart';
import 'package:audioplayers/audioplayers.dart';

class DonationScreen extends StatefulWidget {
  final String campaignId;
  final String campaignTitle;

  const DonationScreen({
    super.key,
    required this.campaignId,
    required this.campaignTitle,
  });

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final AudioPlayer player = AudioPlayer();
  final amountController = TextEditingController();

  String paymentMethod = "FPX";

  Future<void> donate() async {
    double amount = double.tryParse(amountController.text) ?? 0;

    if (amount <= 0) return;

    await CampaignService().donateToCampaign(
      campaignId: widget.campaignId,
      campaignTitle: widget.campaignTitle,
      amount: amount,
      paymentMethod: paymentMethod,
    );

    await player.play(AssetSource('sounds/duit.mp3'));

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Donation Successful")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.campaignTitle)),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: "Donation Amount (RM)",
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(
              value: paymentMethod,

              items: const [
                DropdownMenuItem(value: "FPX", child: Text("FPX")),
                DropdownMenuItem(value: "Card", child: Text("Credit Card")),
                DropdownMenuItem(value: "TNG", child: Text("Touch n Go")),
              ],

              onChanged: (value) {
                paymentMethod = value.toString();
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: donate,

                child: const Text("Donate"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
