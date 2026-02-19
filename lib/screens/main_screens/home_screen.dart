import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/program_provider.dart';
import '../../widgets/program_card.dart';
import '../../models/program.dart';
import '../program/program_detail_screen.dart';
import '../../providers/settings_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final programProvider = Provider.of<ProgramProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('برنامه‌های تمرینی'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: رفتن به صفحه تنظیمات
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('صفحه تنظیمات به زودی')),
              );
            },
          ),
        ],
      ),
      body: programProvider.programs.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              itemCount: programProvider.programs.length,
              itemBuilder: (context, index) {
                final program = programProvider.programs[index];
                ProgramCard(
                  program: program,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProgramDetailScreen(program: program),
                      ),
                    );
                  },
                  onEdit: () {
                    // TODO: ویرایش
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ویرایش ${program.programName}')),
                    );
                  },
                  onDelete: () {
                    _showDeleteDialog(context, program);
                  },
                  onExport: () {
                    // TODO: خروجی
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خروجی ${program.programName}')),
                    );
                  },
                  onSetCurrent: () {
                    // اضافه شد
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setCurrentProgram(program.programName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${program.programName} به عنوان برنامه جاری انتخاب شد')),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProgramDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'هنوز برنامه‌ای ندارید',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'برای شروع یک برنامه جدید اضافه کنید',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddProgramDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('افزودن برنامه'),
          ),
        ],
      ),
    );
  }

  void _showAddProgramDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final provider = Provider.of<ProgramProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('برنامه جدید'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'نام برنامه',
              hintText: 'مثال: برنامه حجمی',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('لغو'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  // ایجاد برنامه نمونه با تاریخ‌های پیش‌فرض
                  final newProgram = Program(
                    programName: nameController.text,
                    startDate: DateTime.now(),
                    endDate: DateTime.now().add(const Duration(days: 30)),
                    workouts: [],
                  );
                  provider.addProgram(newProgram);
                  Navigator.pop(context);
                }
              },
              child: const Text('ذخیره'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Program program) {
    final provider = Provider.of<ProgramProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حذف برنامه'),
          content: Text('آیا از حذف "${program.programName}" اطمینان دارید؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('لغو'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                provider.deleteProgram(program.programName);
                Navigator.pop(context);
              },
              child: const Text('حذف'),
            ),
          ],
        ),
      ),
    );
  }
}
