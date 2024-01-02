import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String _selectedPhoto = "";

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.studentToEdit?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.studentToEdit?.lastName ?? '');
    _selectedPhoto = widget.studentToEdit?.photo ?? "";
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = pickedFile.path;
      });
    }
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
              onPressed: _pickImage,
              child: const Text('Pick Photo'),
            ),
            if (_selectedPhoto.isNotEmpty)
              Image.file(
                File(_selectedPhoto),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (widget.studentToEdit == null) {
                  final newStudent = Student(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    photo: _selectedPhoto,
                  );
                  await _repository.create(newStudent);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(newStudent);
                } else {
                  final updatedStudent = widget.studentToEdit!.copyWith(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    photo: _selectedPhoto,
                  );
                  await _repository.update(updatedStudent.id!, updatedStudent);
                  // ignore: use_build_context_synchronously
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
