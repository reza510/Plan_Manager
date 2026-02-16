import 'package:flutter/material.dart';
import '../models/exercise.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;
  final bool isCompleted; // برای نمایش وضعیت انجام (بعداً استفاده می‌شود)

  const ExerciseTile({
    super.key,
    required this.exercise,
    this.onTap,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isCompleted ? Colors.green.withOpacity(0.1) : null,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getMuscleColor(exercise.primaryMuscle),
          child: Text(
            exercise.sets.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        title: Text(
          exercise.exerciseName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.fitness_center,
                  label: '${exercise.sets} ست',
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  icon: Icons.repeat,
                  label: '${exercise.reps} تکرار',
                ),
                if (exercise.weight != null) ...[
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.monitor_weight,
                    label: '${exercise.weight} کیلوگرم',
                  ),
                ],
              ],
            ),
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.timer,
                  label: 'استراحت: ${exercise.restTime} ثانیه',
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  icon: Icons.fitness_center,
                  label: exercise.primaryMuscle,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          isCompleted ? Icons.check_circle : Icons.play_circle_fill,
          color: isCompleted ? Colors.green : Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color color = Colors.grey,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }

  Color _getMuscleColor(String muscle) {
    switch (muscle.toLowerCase()) {
      case 'سینه':
        return Colors.red;
      case 'پشت':
        return Colors.purple;
      case 'پا':
        return Colors.green;
      case 'شانه':
        return Colors.orange;
      case 'بازو':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
