import 'package:flutter/material.dart';

import '../../../data/providers/session_provider.dart';
import '../../../logic/models/session/session.dart';
import '../../../logic/models/sorting_value.dart';
import '../../widgets/my_session_dialog.dart';
import 'session_add_edit_page.dart';

class SessionGridPage extends StatefulWidget {
  const SessionGridPage({super.key, this.sortingValue = SortingValue.asc});

  final SortingValue sortingValue;
  @override
  State<SessionGridPage> createState() => _SessionGridPageState();
}

class _SessionGridPageState extends State<SessionGridPage> {
  final _repository = const SessionProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Session>?>(
        future: _repository.getAll(sortingInput: widget.sortingValue),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sessions found.'));
          } else {
            List<Session> sessions = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final item = sessions[index];

                return InkWell(
                  onTap: () {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) => MySessionDialog(id: item.id!),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Student ID: ${item.studentId}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Subject ID: ${item.subjectId}',
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result =
                                    await Navigator.of(context).push<Session?>(
                                  MaterialPageRoute(
                                    builder: (ctx) {
                                      return SessionAddEditPage(
                                        sessionToEdit: item,
                                      );
                                    },
                                  ),
                                );

                                setState(() {
                                  if (result != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Session ${result.id} updated',
                                        ),
                                      ),
                                    );
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final response =
                                    await _repository.delete(item.id!);

                                setState(() {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response)),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<Session?>(
            MaterialPageRoute(
              builder: (context) => const SessionAddEditPage(),
            ),
          );

          setState(() {
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session created')),
              );
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
