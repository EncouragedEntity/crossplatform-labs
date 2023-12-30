import 'package:flutter/material.dart';

import '../../../data/providers/subject_provider.dart';
import '../../../logic/models/sorting_value.dart';
import '../../../logic/models/subject/subject.dart';
import '../../widgets/my_search_bar.dart';
import '../../widgets/my_subject_dialog.dart';
import 'subject_add_edit_page.dart';

class SubjectGridPage extends StatefulWidget {
  const SubjectGridPage({Key? key, this.sortingValue = SortingValue.asc})
      : super(key: key);

  final SortingValue sortingValue;

  @override
  State<SubjectGridPage> createState() => _SubjectGridPageState();
}

class _SubjectGridPageState extends State<SubjectGridPage> {
  final _repository = const SubjectProvider();
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
            hintText: 'Subject name...',
          ),
          FutureBuilder<List<Subject>?>(
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
                return const Center(child: Text('No subjects found.'));
              } else {
                List<Subject> subjects = snapshot.data!;
                return Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final item = subjects[index];

                      return InkWell(
                        onTap: () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) => MySubjectDialog(id: item.id!),
                          );
                        },
                        child: Card(
                          elevation: 2.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('ID: ${item.id}',
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 8.0),
                              Text(
                                item.name,
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final result = await Navigator.of(context)
                                          .push<Subject?>(
                                        MaterialPageRoute(
                                          builder: (ctx) {
                                            return SubjectAddEditPage(
                                              subjectToEdit: item,
                                            );
                                          },
                                        ),
                                      );

                                      setState(() {
                                        if (result != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Subject ${result.id} updated',
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
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<Subject?>(
            MaterialPageRoute(
              builder: (context) => const SubjectAddEditPage(),
            ),
          );

          setState(() {
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Subject ${result.name} created')));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
