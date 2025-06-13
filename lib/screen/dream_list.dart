import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:vireo/constants/primary_colors.dart';
import 'package:vireo/db/db_helper.dart';
import 'package:vireo/models/dream_model.dart';
import 'package:vireo/screen/add_dream.dart';
import 'package:vireo/screen/dreamdetail_page.dart';

class DreamList extends StatefulWidget {
  const DreamList({super.key, required this.dreams});

  final List<Dream> dreams;

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  int selectedDateIndex = 0;
  final List<DateTime> weekDates = List.generate(
    7,
    (i) => DateTime.now().add(Duration(days: i)),
  );
  List<Dream> dreamList = [];
  List<Dream> filteredDreamList = [];



  @override
  void initState() {
    super.initState();
    setState(() {
      dreamList = widget.dreams;
      filteredDreamList = widget.dreams;
    });
  }

  Future<void> _loadDreams() async {
    final dreams = await DatabaseHelper().getDreams();
    setState(() {
      dreamList = dreams;
      filteredDreamList = dreams;
    });
  }

  Future<void> _goToAddDreamPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDreamPage()),
    );

    if (result == true) {
      _loadDreams();
    }
  }

  void _filterDreamsByDate(DateTime? date) {
    setState(() {
      if (date == null) {
        filteredDreamList = dreamList;
      } else {
        final dateString = DateFormat('d MMMM yyyy').format(date);
        filteredDreamList =
            dreamList.where((dream) => dream.date == dateString).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dream List"),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _goToAddDreamPage),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 16),
            Expanded(child: _buildDreamTasks()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekDates.length + 1,
        itemBuilder: (context, index) {
          final isSelected = index == selectedDateIndex;

          if (index == 0) {
            return GestureDetector(
              onTap: () {
                setState(() => selectedDateIndex = 0);
                _filterDreamsByDate(null);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Seluruh Mimpi",
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final date = weekDates[index - 1];
          return GestureDetector(
            onTap: () {
              setState(() => selectedDateIndex = index);
              _filterDreamsByDate(date);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.grey[300],
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
                    DateFormat.E().format(date),
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
    if (filteredDreamList.isEmpty) {
      return const Center(child: Text('Belum ada mimpi!'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredDreamList.length,
      itemBuilder: (context, index) {
        final dream = filteredDreamList[index];
        return Slidable(
          key: ValueKey(dream.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AddDreamPage(
                            existingDream:
                                dream, 
                          ),
                    ),
                  ).then((result) {
                    if (result == true) _loadDreams();
                  });
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              SlidableAction(
                onPressed: (context) async {
                  final confirm = await showDialog(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: const Text(
                            'Yakin ingin menghapus mimpi ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true) {
                    await DatabaseHelper().deleteDream(dream.id!);
                    _loadDreams();
                  }
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Hapus',
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DreamDetailPage(dream: dream),
                ),
              );
              _loadDreams();
            },
            child: _dreamListCard(
              dream.date,
              dream.title,
              dream.desc,
              dream.progress,
            ),
          ),
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
          Align(
            alignment: Alignment.topRight,
            child: Text(
              date,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
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
            backgroundColor: Colors.grey[300],
            color: primaryColor,
          ),
        ],
      ),
    );
  }
}
