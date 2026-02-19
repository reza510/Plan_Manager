import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/program.dart';
import '../../providers/program_provider.dart';
import '../../providers/settings_provider.dart';
import '../program/program_detail_screen.dart';
import '../workout/workout_player_screen.dart';

class CurrentProgramScreen extends StatelessWidget {
  const CurrentProgramScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, ProgramProvider>(
      builder: (context, settings, programProvider, child) {
        Program? currentProgram;
        if (settings.currentProgramName != null) {
          try {
            currentProgram = programProvider.programs.firstWhere(
              (p) => p.programName == settings.currentProgramName,
            );
          } catch (e) {
            // برنامه جاری یافت نشد
          }
        }

        if (currentProgram == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('برنامه جاری')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    'هیچ برنامه جاری انتخاب نشده',
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'از صفحه خانه یک برنامه را به عنوان جاری انتخاب کنید',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('برنامه جاری: ${currentProgram.programName}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutPlayerScreen(
                        exercises: currentProgram!.workouts,
                        initialIndex: 0,
                        programName: currentProgram!.programName,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: currentProgram.workouts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sports_gymnastics,
                          size: 80, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      Text(
                        'این برنامه تمرینی ندارد',
                        style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: currentProgram.workouts.length,
                  itemBuilder: (context, index) {
                    final exercise = currentProgram!.workouts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${exercise.sets}'),
                      ),
                      title: Text(exercise.exerciseName),
                      subtitle: Text(
                          '${exercise.reps} تکرار - ${exercise.primaryMuscle}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutPlayerScreen(
                              exercises: currentProgram!.workouts,
                              initialIndex: index,
                              programName: currentProgram!.programName,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
