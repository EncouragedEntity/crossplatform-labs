import 'package:flutter/material.dart';
import 'package:web_client_api/data/providers/subject_provider.dart';
import 'package:web_client_api/logic/models/sorting_value.dart';
import 'package:web_client_api/logic/models/subject/subject.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({
    super.key,
    this.sortingValue = SortingValue.asc,
  });

  final SortingValue sortingValue;

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final _repository = SubjectProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
      ),
      body: FutureBuilder<List<Subject>?>(
        future: _repository.getAll(sortingInput: widget.sortingValue),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No subjects found.'));
          } else {
            List<Subject> subjects = snapshot.data!;
            return ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(subjects[index].name),
                  subtitle: Text('ID: ${subjects[index].id}'),
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
                              await _repository.delete(subjects[index].id!);

                          setState(() {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response)));
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
          // TODO: Implement add subject functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
