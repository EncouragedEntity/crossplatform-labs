import 'package:flutter/material.dart';
import 'package:web_client_api/data/providers/session_provider.dart';
import 'package:web_client_api/logic/models/session/session.dart';
import 'package:web_client_api/logic/models/sorting_value.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key, this.sortingValue = SortingValue.asc});

  final SortingValue sortingValue;
  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final _repository = SessionProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
      ),
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
                return ListTile(
                  title: Text('Student ID: ${sessions[index].studentId}'),
                  subtitle: Text('Subject ID: ${sessions[index].subjectId}'),
                  onTap: () {
                    // TODO: Implement details page navigation
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // TODO: Implement edit action
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final response =
                              await _repository.delete(sessions[index].id!);

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
        onPressed: () {
          // TODO: Implement add session functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
