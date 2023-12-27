import 'package:flutter/material.dart';
import 'package:web_client_api/logic/models/student/student.dart';

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
              onPressed: () {
                // TODO: Implement save functionality
                if (widget.studentToEdit == null) {
                  final newStudent = Student(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                  );
                  // TODO: Save new student to the repository
                } else {
                  final updatedStudent = widget.studentToEdit!.copyWith(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                  );
                  // TODO: Save updated student to the repository
                }
                // TODO: Navigate back or perform other actions after saving
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
