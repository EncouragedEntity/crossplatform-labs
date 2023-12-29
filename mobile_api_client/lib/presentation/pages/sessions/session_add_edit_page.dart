// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../data/providers/session_provider.dart';
import '../../../data/providers/student_provider.dart';
import '../../../data/providers/subject_provider.dart';
import '../../../logic/models/session/session.dart';
import '../../../logic/models/student/student.dart';
import '../../../logic/models/subject/subject.dart';

class SessionAddEditPage extends StatefulWidget {
  const SessionAddEditPage({Key? key, this.sessionToEdit}) : super(key: key);

  final Session? sessionToEdit;

  @override
  // ignore: library_private_types_in_public_api
  _SessionAddEditPageState createState() => _SessionAddEditPageState();
}

class _SessionAddEditPageState extends State<SessionAddEditPage> {
  late StudentProvider _studentProvider;
  late SubjectProvider _subjectProvider;
  late SessionProvider _sessionProvider;

  late List<Student> _students;
  late List<Subject> _subjects;

  late Student? _selectedStudent;
  late Subject? _selectedSubject;

  @override
  void initState() {
    super.initState();

    _studentProvider = const StudentProvider();
    _subjectProvider = const SubjectProvider();
    _sessionProvider = const SessionProvider();

    _students = [];
    _subjects = [];
    _selectedStudent = null;
    _selectedSubject = null;

    _loadData();
  }

  Future<void> _loadData() async {
    final students = await _studentProvider.getAll();
    final subjects = await _subjectProvider.getAll();

    setState(() {
      _students = students ?? [];
      _subjects = subjects ?? [];

      if (widget.sessionToEdit != null) {
        _selectedStudent = _students.firstWhere(
          (student) => student.id == widget.sessionToEdit!.studentId,
        );

        _selectedSubject = _subjects.firstWhere(
          (subject) => subject.id == widget.sessionToEdit!.subjectId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sessionToEdit == null
            ? 'Add Session'
            : 'Edit Session № ${widget.sessionToEdit!.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Student>(
              value: _selectedStudent,
              items: _students
                  .map((student) => DropdownMenuItem<Student>(
                        value: student,
                        child: Text('${student.firstName} ${student.lastName}'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStudent = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Student',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Subject>(
              value: _selectedSubject,
              items: _subjects
                  .map((subject) => DropdownMenuItem<Subject>(
                        value: subject,
                        child: Text(subject.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Subject',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_selectedStudent == null || _selectedSubject == null) {
                  return;
                }

                if (widget.sessionToEdit == null) {
                  final newSession = Session(
                    studentId: _selectedStudent!.id!,
                    subjectId: _selectedSubject!.id!,
                  );

                  await _sessionProvider.create(newSession);
                  Navigator.of(context).pop(newSession);
                } else {
                  final updatedSession = widget.sessionToEdit!.copyWith(
                    studentId: _selectedStudent!.id!,
                    subjectId: _selectedSubject!.id!,
                  );

                  await _sessionProvider.update(
                    updatedSession.id!,
                    updatedSession,
                  );
                  Navigator.of(context).pop(updatedSession);
                }
              },
              child:
                  Text(widget.sessionToEdit == null ? 'Add' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
