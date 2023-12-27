import 'package:flutter/material.dart';
import 'package:web_client_api/data/providers/student_provider.dart';
import 'package:web_client_api/logic/models/sorting_value.dart';
import 'package:web_client_api/logic/models/student/student.dart';
import 'package:web_client_api/presentation/pages/students/student_add_edit_page.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key, this.sortingValue = SortingValue.asc});

  final SortingValue sortingValue;
  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _repository = StudentProvider();
  final _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 60,
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration:
                      const InputDecoration(hintText: "Student name..."),
                  controller: _searchController,
                  autofocus: true,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text;
                  });
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          FutureBuilder<List<Student>?>(
            future: _repository.getAll(
              sortingInput: widget.sortingValue,
              searchInput: _searchQuery,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No students found.'));
              } else {
                List<Student> students = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          '${students[index].firstName} ${students[index].lastName}',
                        ),
                        subtitle: Text('ID: ${students[index].id}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: () {
                                // TODO: Implement details page navigation
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // TODO: Implement edit action
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final response = await _repository
                                    .delete(students[index].id!);

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
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const StudentAddEditPage(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
