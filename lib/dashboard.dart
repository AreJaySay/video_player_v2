import 'dart:convert';

import 'package:fitnesstracker/add_route.dart';
import 'package:fitnesstracker/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, String>> routines = [];

  @override
  void initState() {
    super.initState();
    _loadRoutines();

    // Check for upcoming routines every minute
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkForUpcomingRoutines();
    });
  }

  Future<void> _loadRoutines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? routinesString = prefs.getString('routines');
    if (routinesString != null) {
      List<dynamic> jsonData = json.decode(routinesString);
      setState(() {
        routines = List<Map<String, String>>.from(jsonData.map((item) => Map<String, String>.from(item)));
      });
    }
  }

  Future<void> _saveRoutines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String routinesString = json.encode(routines);
    prefs.setString('routines', routinesString);
  }

  void addRoutine(String name, String date, String time) {
    setState(() {
      routines.add({'name': name, 'date': date, 'time': time});
    });
    _saveRoutines();
  }

  void updateRoutine(int index, String name, String date, String time) {
    setState(() {
      routines[index] = {'name': name, 'date': date, 'time': time};
    });
    _saveRoutines();
  }

  void deleteRoutine(int index) {
    setState(() {
      routines.removeAt(index);
    });
    _saveRoutines();
  }

  // Check for upcoming routines within the next 5 minutes
  void _checkForUpcomingRoutines() {
    DateTime now = DateTime.now();

    for (var routine in routines) {
      DateTime routineTime = DateFormat('yyyy-MM-dd HH:mm').parse('${routine['date']} ${routine['time']}');

      // Check if the routine is within the next 5 minutes
      if (routineTime.isAfter(now) && routineTime.isBefore(now.add(Duration(minutes: 5)))) {
        _showUpcomingRoutineAlert(routine);
      }
    }
  }

  // Show an alert for the upcoming routine
  void _showUpcomingRoutineAlert(Map<String, String> routine) {
    if (!mounted) return; // Check if the widget is still in the tree
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upcoming Routine'),
          content: Text(
            'Your routine "${routine['name']}" is scheduled at ${routine['time']} today!',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Planner', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: routines.isEmpty
            ? const Center(
          child: Text(
            "No routines added yet!",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: routines.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                title: Text(
                  routines[index]['name']!,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${routines[index]['date']} at ${routines[index]['time']}',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRoutinePage(routine: routines[index]),
                          ),
                        );
                        if (result != null) {
                          updateRoutine(index, result['name'], result['date'], result['time']);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => deleteRoutine(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRoutinePage()),
          );
          if (result != null) {
            addRoutine(result['name'], result['date'], result['time']);
          }
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}