import 'package:flutter/material.dart';

import '../../../data/providers/session_provider.dart';
import '../../../logic/models/session/session.dart';
import '../../../logic/models/sorting_value.dart';
import '../../widgets/my_session_dialog.dart';
import 'session_add_edit_page.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key, this.sortingValue = SortingValue.asc});

  final SortingValue sortingValue;
  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
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
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final item = sessions[index];

                return ListTile(
                  title: Text('Student ID: ${item.studentId}'),
                  subtitle: Text('Subject ID: ${item.subjectId}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined),
                        onPressed: () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) => MySessionDialog(id: item.id!),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.of(context)
                              .push<Session?>(MaterialPageRoute(
                            builder: (ctx) {
                              return SessionAddEditPage(
                                sessionToEdit: item,
                              );
                            },
                          ));

                          setState(() {
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Session ${result.id} updated')));
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final response = await _repository.delete(item.id!);

                          setState(() {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response)),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.of(context).push<Session?>(MaterialPageRoute(
            builder: (context) => const SessionAddEditPage(),
          ));

          setState(() {
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Session created')));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
