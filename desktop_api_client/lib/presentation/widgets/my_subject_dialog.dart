import 'package:flutter/material.dart';
import 'package:web_client_api/data/providers/subject_provider.dart';

import '../../logic/models/subject/subject.dart';

class MySubjectDialog extends StatefulWidget {
  const MySubjectDialog({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<MySubjectDialog> createState() => _MySubjectDialogState();
}

class _MySubjectDialogState extends State<MySubjectDialog> {
  final _repository = const SubjectProvider();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints.tightFor(width: 200, height: 150),
        child: FutureBuilder(
          future: _repository.getById(widget.id),
          builder: (context, AsyncSnapshot<Subject?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final Subject subject = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subject',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text('ID: ${subject.id}'),
                    Text('Subject name: ${subject.name}'),
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
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('Subject not found.');
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
