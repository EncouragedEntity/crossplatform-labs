// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../../data/providers/subject_provider.dart';
import '../../../logic/models/subject/subject.dart';

class SubjectAddEditPage extends StatefulWidget {
  const SubjectAddEditPage({Key? key, this.subjectToEdit}) : super(key: key);

  final Subject? subjectToEdit;

  @override
  // ignore: library_private_types_in_public_api
  _SubjectAddEditPageState createState() => _SubjectAddEditPageState();
}

class _SubjectAddEditPageState extends State<SubjectAddEditPage> {
  late TextEditingController _subjectNameController;
  final _repository = const SubjectProvider();

  @override
  void initState() {
    super.initState();
    _subjectNameController =
        TextEditingController(text: widget.subjectToEdit?.name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectToEdit == null
            ? 'Add Subject'
            : 'Edit Subject № ${widget.subjectToEdit!.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectNameController,
              decoration: const InputDecoration(labelText: 'Subject Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (widget.subjectToEdit == null) {
                  final newSubject = Subject(
                    name: _subjectNameController.text,
                  );
                  await _repository.create(newSubject);
                  Navigator.of(context).pop(newSubject);
                } else {
                  final updatedSubject = widget.subjectToEdit!.copyWith(
                    name: _subjectNameController.text,
                  );
                  await _repository.update(updatedSubject.id!, updatedSubject);
                  Navigator.of(context).pop(updatedSubject);
                }
              },
              child:
                  Text(widget.subjectToEdit == null ? 'Add' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
