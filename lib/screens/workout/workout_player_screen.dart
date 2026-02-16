import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../models/exercise.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final int initialIndex;

  const WorkoutPlayerScreen({
    Key? key,
    required this.exercises,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _WorkoutPlayerScreenState createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  late int currentExerciseIndex;
  late int currentSetIndex;
  late Exercise currentExercise;
  late int totalSets;

  Timer? _timer;
  int _timerValue = 0;
  bool _isRunning = false;
  bool _isWorkPhase = true;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    currentExerciseIndex = widget.initialIndex;
    currentSetIndex = 1;
    _updateCurrentExercise();
  }

  void _updateCurrentExercise() {
    currentExercise = widget.exercises[currentExerciseIndex];
    totalSets = currentExercise.sets;
    _resetTimerForCurrentPhase();
  }

  void _resetTimerForCurrentPhase() {
    if (_isWorkPhase) {
      if (currentExercise.setType == SetType.time) {
        _timerValue = currentExercise.targetTime ?? 0;
      } else {
        _timerValue = 0;
      }
    } else {
      _timerValue = currentExercise.restTime;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerValue > 0) {
          _timerValue--;
          if (_timerValue == 0) _playSound();
        } else {
          _timerValue--;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
  }

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/beep.mp3'));
    } catch (e) {
      // ignore
    }
  }

  void _nextSetOrExercise() {
    if (currentSetIndex < totalSets) {
      setState(() {
        currentSetIndex++;
        _isWorkPhase = true;
        _resetTimerForCurrentPhase();
        _pauseTimer();
        _isRunning = false;
      });
    } else {
      if (currentExerciseIndex + 1 < widget.exercises.length) {
        setState(() {
          currentExerciseIndex++;
          currentSetIndex = 1;
          _updateCurrentExercise();
          _isWorkPhase = true;
          _resetTimerForCurrentPhase();
          _pauseTimer();
          _isRunning = false;
        });
      } else {
        _showCompletionDialog();
      }
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('تمرین کامل شد!'),
        content: const Text('تبریک! شما تمام تمرینات را به پایان رساندید.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('باشه'),
          ),
        ],
      ),
    );
  }

  void _finishSet() {
    setState(() {
      _isWorkPhase = false;
      _resetTimerForCurrentPhase();
      _pauseTimer();
      _isRunning = false;
    });
  }

  void _skipRest() {
    _nextSetOrExercise();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    if (seconds >= 0) {
      int mins = seconds ~/ 60;
      int secs = seconds % 60;
      return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      int absSecs = -seconds;
      int mins = absSecs ~/ 60;
      int secs = absSecs % 60;
      return '-${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(currentExercise.exerciseName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ست $currentSetIndex از $totalSets',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (currentExercise.setType == SetType.repetition)
              Text(
                '${currentExercise.reps} تکرار - ${currentExercise.weight?.toStringAsFixed(0) ?? '-'} کیلوگرم',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatTime(_timerValue),
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: _timerValue > 0 ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              _isWorkPhase ? 'حالت تمرین' : 'حالت استراحت',
              style: TextStyle(
                fontSize: 18,
                color: _isWorkPhase ? Colors.blue : Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_isWorkPhase && currentExercise.setType == SetType.time)
                  ElevatedButton(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    child: Text(_isRunning ? 'توقف' : 'شروع'),
                  ),
                if (_isWorkPhase &&
                    currentExercise.setType == SetType.repetition)
                  ElevatedButton(
                    onPressed: _finishSet,
                    child: const Text('تمام شد (برو به استراحت)'),
                  ),
                if (!_isWorkPhase)
                  ElevatedButton(
                    onPressed: _skipRest,
                    child: const Text('رد کردن استراحت'),
                  ),
                if (_isWorkPhase && currentExercise.setType == SetType.time)
                  ElevatedButton(
                    onPressed: _finishSet,
                    child: const Text('تموم شد (برو به استراحت)'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextSetOrExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'تمرین بعدی / ست بعدی',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
