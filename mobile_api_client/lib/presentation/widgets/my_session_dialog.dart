import 'package:flutter/material.dart';

import '../../data/providers/session_provider.dart';
import '../../data/providers/student_provider.dart';
import '../../data/providers/subject_provider.dart';
import '../../logic/models/session/session.dart';
import '../../logic/models/student/student.dart';
import '../../logic/models/subject/subject.dart';

class MySessionDialog extends StatefulWidget {
  const MySessionDialog({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<MySessionDialog> createState() => _MySessionDialogState();
}

class _MySessionDialogState extends State<MySessionDialog> {
  final _sessionProvider = const SessionProvider();
  final _studentProvider = const StudentProvider();
  final _subjectProvider = const SubjectProvider();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints.tightFor(width: 300, height: 200),
        child: FutureBuilder(
          future: _sessionProvider.getById(widget.id),
          builder: (context, AsyncSnapshot<Session?> sessionSnapshot) {
            if (sessionSnapshot.connectionState == ConnectionState.done) {
              if (sessionSnapshot.hasData) {
                final Session session = sessionSnapshot.data!;
                final Future<Student?> studentFuture =
                    _studentProvider.getById(session.studentId);
                final Future<Subject?> subjectFuture =
                    _subjectProvider.getById(session.subjectId);

                return FutureBuilder(
                  future: Future.wait([studentFuture, subjectFuture]),
                  builder:
                      (context, AsyncSnapshot<List<dynamic>> dataSnapshot) {
                    if (dataSnapshot.connectionState == ConnectionState.done) {
                      if (dataSnapshot.hasData) {
                        final Student? student = dataSnapshot.data![0];
                        final Subject? subject = dataSnapshot.data![1];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Session',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text('ID: ${session.id}'),
                            Text(
                                'Student: ${student?.firstName ?? 'N/A'} ${student?.lastName ?? 'N/A'}'),
                            Text('Subject: ${subject?.name ?? 'N/A'}'),
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
                      } else {
                        return const Text('Student or Subject not found.');
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                );
              } else if (sessionSnapshot.hasError) {
                return Text('Error: ${sessionSnapshot.error}');
              } else {
                return const Text('Session not found.');
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
