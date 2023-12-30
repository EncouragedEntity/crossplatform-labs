import 'package:flutter/material.dart';

import '../../../data/providers/student_provider.dart';
import '../../../logic/models/sorting_value.dart';
import '../../../logic/models/student/student.dart';
import '../../widgets/my_search_bar.dart';
import '../../widgets/my_student_dialog.dart';
import 'student_add_edit_page.dart';

class StudentGridPage extends StatefulWidget {
  const StudentGridPage({super.key, this.sortingValue = SortingValue.asc});

  final SortingValue sortingValue;

  @override
  State<StudentGridPage> createState() => _StudentGridPageState();
}

class _StudentGridPageState extends State<StudentGridPage> {
  final _repository = const StudentProvider();
  final _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MySearchBar(
            searchController: _searchController,
            onSearched: () {
              setState(() {
                _searchQuery = _searchController.text;
              });
            },
            hintText: 'Student name...',
          ),
          Expanded(
            child: FutureBuilder<List<Student>?>(
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
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final item = students[index];

                      return InkWell(
                        onTap: () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) => MyStudentDialog(id: item.id!),
                          );
                        },
                        child: Card(
                          elevation: 2.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${item.firstName} ${item.lastName}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8.0),
                              Text('ID: ${item.id}',
                                  textAlign: TextAlign.center),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final result = await Navigator.of(context)
                                          .push<Student?>(
                                        MaterialPageRoute(
                                          builder: (ctx) {
                                            return StudentAddEditPage(
                                                studentToEdit: item);
                                          },
                                        ),
                                      );

                                      setState(() {
                                        if (result != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Student ${result.id} updated',
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(response),
                                          ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<Student?>(
            MaterialPageRoute(
              builder: (context) => const StudentAddEditPage(),
            ),
          );

          setState(() {
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Student ${result.firstName} ${result.lastName} created'),
              ));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
