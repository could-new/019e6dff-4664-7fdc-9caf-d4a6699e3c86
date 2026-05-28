import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تسجيل الغيابات',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', ''),
      supportedLocales: const [
        Locale('ar', ''), // Arabic
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Roboto', // Default font, can be updated later
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

class Student {
  final String id;
  final String name;
  bool isAbsent;

  Student({required this.id, required this.name, this.isAbsent = false});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Student> _students = [
    Student(id: '1', name: 'أحمد محمود'),
    Student(id: '2', name: 'فاطمة علي'),
    Student(id: '3', name: 'عمر سعيد'),
    Student(id: '4', name: 'ليلى خليل'),
  ];

  final TextEditingController _nameController = TextEditingController();

  void _addStudent() {
    if (_nameController.text.trim().isEmpty) return;
    
    setState(() {
      _students.add(
        Student(
          id: DateTime.now().toString(),
          name: _nameController.text.trim(),
        ),
      );
    });
    
    _nameController.clear();
    Navigator.of(context).pop();
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة تلميذ جديد'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'اسم التلميذ',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: _addStudent,
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  void _toggleAbsence(int index) {
    setState(() {
      _students[index].isAbsent = !_students[index].isAbsent;
    });
  }

  @override
  Widget build(BuildContext context) {
    int absentCount = _students.where((s) => s.isAbsent).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الغيابات'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('الإجمالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${_students.length}', style: const TextStyle(fontSize: 24, color: Colors.blue)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('الحضور', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${_students.length - absentCount}', style: const TextStyle(fontSize: 24, color: Colors.green)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('الغياب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('$absentCount', style: const TextStyle(fontSize: 24, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'قائمة التلاميذ:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: _students.isEmpty
                ? const Center(child: Text('لا يوجد تلاميذ. قم بإضافة تلميذ جديد.'))
                : ListView.builder(
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: student.isAbsent ? Colors.red.shade100 : Colors.green.shade100,
                            child: Icon(
                              student.isAbsent ? Icons.person_off : Icons.person,
                              color: student.isAbsent ? Colors.red : Colors.green,
                            ),
                          ),
                          title: Text(student.name, style: const TextStyle(fontSize: 18)),
                          trailing: Switch(
                            value: student.isAbsent,
                            onChanged: (value) => _toggleAbsence(index),
                            activeColor: Colors.red,
                            inactiveThumbColor: Colors.green,
                            inactiveTrackColor: Colors.green.shade200,
                          ),
                          subtitle: Text(
                            student.isAbsent ? 'غائب' : 'حاضر',
                            style: TextStyle(
                              color: student.isAbsent ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStudentDialog,
        icon: const Icon(Icons.add),
        label: const Text('إضافة تلميذ'),
      ),
    );
  }
}
