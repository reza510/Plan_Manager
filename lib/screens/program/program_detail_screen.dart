import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/program.dart';
import '../../providers/program_provider.dart';
import '../../widgets/exercise_tile.dart';
import '../workout/workout_player_screen.dart';

class ProgramDetailScreen extends StatelessWidget {
  final Program program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(program.programName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: ویرایش برنامه
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ویرایش برنامه به زودی')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // خلاصه برنامه
          _buildProgramSummary(),
          const Divider(),
          // لیست تمرینات
          Expanded(
            child: program.workouts.isEmpty
                ? _buildEmptyWorkouts(context)
                : ListView.builder(
                    itemCount: program.workouts.length,
                    itemBuilder: (context, index) {
                      final exercise = program.workouts[index];
                      return ExerciseTile(
                        exercise: exercise,
                        onTap: () {
                          // TODO: رفتن به صفحه اجرای تمرین
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutPlayerScreen(
                                exercises: program.workouts,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: افزودن تمرین جدید
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('افزودن تمرین به زودی')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProgramSummary() {
    final totalExercises = program.workouts.length;
    final totalSets = program.workouts.fold<int>(0, (sum, e) => sum + e.sets);
    final duration = program.endDate.difference(program.startDate).inDays + 1;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            icon: Icons.fitness_center,
            value: totalExercises.toString(),
            label: 'تمرین',
          ),
          _buildSummaryItem(
            icon: Icons.repeat,
            value: totalSets.toString(),
            label: 'ست',
          ),
          _buildSummaryItem(
            icon: Icons.calendar_today,
            value: '$duration روز',
            label: 'مدت',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyWorkouts(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_gymnastics,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'هیچ تمرینی در این برنامه وجود ندارد',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'با دکمه + تمرین جدید اضافه کنید',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
