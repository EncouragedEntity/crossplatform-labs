import 'package:flutter/material.dart';

import '../../logic/models/sorting_value.dart';
import 'sessions/sessions_page.dart';
import 'students/students_grid_page.dart';
import 'subjects/subjects_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  SortingValue _sortingValue = SortingValue.asc;
  final List<Widget> _pages = [
    const StudentGridPage(),
    const SubjectPage(),
    const SessionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onSortPressed() {
    setState(() {
      _sortingValue = _sortingValue == SortingValue.asc
          ? SortingValue.desc
          : SortingValue.asc;
    });

    _pages[_currentIndex] =
        _updatePageSorting(_pages[_currentIndex], _sortingValue);
  }

  Widget _updatePageSorting(Widget page, SortingValue sortingValue) {
    if (page is StudentGridPage) {
      return StudentGridPage(sortingValue: sortingValue);
    } else if (page is SubjectPage) {
      return SubjectPage(sortingValue: sortingValue);
    } else if (page is SessionPage) {
      return SessionPage(sortingValue: sortingValue);
    }
    return page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students API Client'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _onSortPressed,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Sessions',
          ),
        ],
      ),
    );
  }
}
