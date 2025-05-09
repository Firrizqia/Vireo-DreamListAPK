import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/constants/primary_colors.dart';

class DreamList extends StatefulWidget {
  const DreamList({super.key});

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  int selectedDateIndex = 0;

  // Buat 7 hari ke depan berdasarkan hari ini
  final List<DateTime> weekDates = List.generate(
    7,
    (i) => DateTime.now().add(Duration(days: i)),
  );

  final List<Map<String, dynamic>> tasks = [
    {
      'date': '5 Juli 2025',
      'title': 'Punya Mobil Sport',
      'desc': 'Dream progress',
      'progress': 0.6,
    },
    {
      'date': '20 Agustus 2027',
      'title': 'Beli Rumah Cash',
      'desc': 'Target impian',
      'progress': 0.4,
    },
    {
      'date': '12 Januari 2033',
      'title': 'Pergi ke Planet Mars',
      'desc': 'One day maybe',
      'progress': 0.1,
    },
    {
      'date': '21 Maret 2047',
      'title': 'Pergi antar universe',
      'desc': 'One day maybe',
      'progress': 0.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildHeader(),
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 16),
            Expanded(child: _buildDreamTasks()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        "Dream List",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekDates.length,
        itemBuilder: (context, index) {
          final date = weekDates[index];
          final isSelected = index == selectedDateIndex;

          return GestureDetector(
            onTap: () => setState(() => selectedDateIndex = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.MMMd().format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.E().format(date), // Sen, Sel, Rab...
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDreamTasks() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _dreamListCard(
          task['date'],
          task['title'],
          task['desc'],
          task['progress'],
        );
      },
    );
  }

  Widget _dreamListCard(
    String date,
    String title,
    String desc,
    double progress,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  date,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(color: primaryColor),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: accentColor,
            color: secondaryColor,
          ),
        ],
      ),
    );
  }
}
