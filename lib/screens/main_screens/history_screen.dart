import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/workout_log.dart';
import '../../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<WorkoutLog> _logsForSelectedDay = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadLogsForDay(_focusedDay);
  }

  Future<void> _loadLogsForDay(DateTime day) async {
    final logs = await HistoryService.getLogsForDate(day);
    setState(() {
      _logsForSelectedDay = logs;
    });
  }

  // برای نمایش روزهای دارای تمرین با نقطه رنگی
  Map<DateTime, List<WorkoutLog>>? _getEventsForDay(DateTime day) {
    // اینجا می‌توانیم از داده‌های ذخیره شده استفاده کنیم،
    // اما برای سادگی، فعلاً از یک لیست نمونه استفاده می‌کنیم.
    // در عمل باید از HistoryService.loadLogs() و فیلتر کردن استفاده شود.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تاریخچه تمرینات'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _loadLogsForDay(selectedDay);
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              // اینجا باید از داده‌های واقعی استفاده شود
              // فعلاً خالی برمی‌گردانیم
              return [];
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _logsForSelectedDay.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'برای این روز تمرینی ثبت نشده',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _logsForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final log = _logsForSelectedDay[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${log.setsCompleted}'),
                          ),
                          title: Text(log.exerciseName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('برنامه: ${log.programName}'),
                              Row(
                                children: [
                                  Text('${log.repsPerSet} تکرار'),
                                  if (log.weightUsed != null)
                                    Text(' - ${log.weightUsed} کیلوگرم'),
                                ],
                              ),
                              if (log.duration > 0)
                                Text('مدت: ${log.duration} ثانیه'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
