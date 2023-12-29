// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../data/providers/student_provider.dart';
import '../../../logic/models/student/student.dart';

class StudentAddEditPage extends StatefulWidget {
  const StudentAddEditPage({Key? key, this.studentToEdit}) : super(key: key);

  final Student? studentToEdit;

  @override
  // ignore: library_private_types_in_public_api
  _StudentAddEditPageState createState() => _StudentAddEditPageState();
}

class _StudentAddEditPageState extends State<StudentAddEditPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  final _repository = const StudentProvider();

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.studentToEdit?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.studentToEdit?.lastName ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentToEdit == null
            ? 'Add Student'
            : 'Edit Student № ${widget.studentToEdit!.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (widget.studentToEdit == null) {
                  final newStudent = Student(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                  );
                  await _repository.create(newStudent);
                  Navigator.of(context).pop(newStudent);
                } else {
                  final updatedStudent = widget.studentToEdit!.copyWith(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                  );
                  await _repository.update(updatedStudent.id!, updatedStudent);
                  Navigator.of(context).pop(updatedStudent);
                }
              },
              child:
                  Text(widget.studentToEdit == null ? 'Add' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
