import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:logger/logger.dart';
import 'package:webpage_parser/logic/decoded_string.dart';
import 'package:webpage_parser/presentation/pages/category_songs_page.dart';

import '../../data/constants/string_constants.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final String endpoint = '/songlist';
  List<Map<String, String>> songCategories = [];

  @override
  void initState() {
    super.initState();
    fetchHTML();
  }

  void fetchHTML() async {
    try {
      final response = await http.get(Uri.parse(hostname + endpoint));
      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final elements = document.getElementsByTagName('a');

        for (final element in elements) {
          String title = element.text.decoded;
          if (title.isEmpty) {
            continue;
          }
          final href = element.attributes['href'];
          if (RegExp(r'^/songlist/.*1\.html$').hasMatch(href ?? '')) {
            final categoryMap = <String, String>{
              'title': title,
              'href': href ?? "",
            };
            songCategories.add(categoryMap);

            final retrievedTitle = categoryMap['title'];
            Logger().i('Retrieved Title: $retrievedTitle');
          }
        }

        setState(() {});
      } else {
        Logger()
            .e('Failed to fetch web page. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Logger().e('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Links'),
      ),
      body: songCategories.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: songCategories.length,
              itemBuilder: (context, index) {
                final categoryItem = songCategories[index];

                return ListTile(
                  title: Text(categoryItem['title'] ?? 'title undefined'),
                  subtitle: Text(categoryItem['href'] ?? 'link undefined'),
                  onTap: () {
                    if (categoryItem['href'] != null) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return CategorySongsPage(link: categoryItem['href']!);
                      }));
                      return;
                    }
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Sorry, your link is invalid"),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
