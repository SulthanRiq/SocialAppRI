import 'package:flutter/material.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  // State untuk menyimpan pilihan reminder
  String? selectedReminder;

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF5E8092); // biru abu-abu
    const Color bgColor = Color(0xFFB8C5CC);     // abu-abu terang
    const Color itemColor = Color(0xFFA8B5BC);   // abu-abu item

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR dengan back dan title Reminder
            Container(
              height: 60,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Back
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title Reminder
                  const Text(
                    'Reminder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Spacer untuk balance layout
                  const SizedBox(width: 70),
                ],
              ),
            ),

            // CONTENT - List Reminder Options
            Expanded(
              child: Column(
                children: [
                  _buildReminderItem(
                    label: 'Never',
                    value: 'never',
                    itemColor: itemColor,
                  ),
                  _buildDivider(),

                  _buildReminderItem(
                    label: 'Every Day',
                    value: 'every_day',
                    itemColor: itemColor,
                  ),
                  _buildDivider(),

                  _buildReminderItem(
                    label: 'Every Week',
                    value: 'every_week',
                    itemColor: itemColor,
                  ),
                  _buildDivider(),

                  _buildReminderItem(
                    label: 'Every 2 Weeks',
                    value: 'every_2_weeks',
                    itemColor: itemColor,
                  ),
                  _buildDivider(),

                  _buildReminderItem(
                    label: 'Every Month',
                    value: 'every_month',
                    itemColor: itemColor,
                  ),
                  _buildDivider(),

                  _buildReminderItem(
                    label: 'Every Year',
                    value: 'every_year',
                    itemColor: itemColor,
                  ),
                  _buildDivider(),

                  // Spacer
                  const Spacer(),

                  // GARIS PEMBATAS BAWAH
                  Center(
                    child: Container(
                      width: 200,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk reminder item dengan checkbox
  Widget _buildReminderItem({
    required String label,
    required String value,
    required Color itemColor,
  }) {
    final bool isSelected = selectedReminder == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReminder = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        color: itemColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black54,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.black87,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk divider
  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.black26,
    );
  }
}