import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_client_api/data/providers/student_provider.dart';

import '../../logic/models/student/student.dart';

class MyStudentDialog extends StatefulWidget {
  const MyStudentDialog({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<MyStudentDialog> createState() => _MyStudentDialogState();
}

class _MyStudentDialogState extends State<MyStudentDialog> {
  final _repository = const StudentProvider();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
        child: FutureBuilder(
          future: _repository.getById(widget.id),
          builder: (context, AsyncSnapshot<Student?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final Student student = snapshot.data!;

                return Row(
                  children: [
                    if (student.photo != null && student.photo!.isNotEmpty)
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.file(
                          File(student.photo!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Student',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Text('ID: ${student.id}'),
                        Text('First name: ${student.firstName}'),
                        Text('Last name: ${student.lastName}'),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('Student not found.');
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
