import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:webpage_parser/data/constants/string_constants.dart';
import 'package:webpage_parser/logic/decoded_string.dart';
import 'package:webpage_parser/presentation/pages/song_page.dart';

class CategorySongsPage extends StatefulWidget {
  const CategorySongsPage({super.key, required this.link});

  final String link;

  @override
  State<CategorySongsPage> createState() => _CategorySongsPageState();
}

class _CategorySongsPageState extends State<CategorySongsPage> {
  late String currentPageLink;
  int currentPageIndex = 1;
  late Future<List<Map<String, String>>> futureSongs;
  late String currentPageTitle;

  @override
  void initState() {
    currentPageLink = widget.link;
    futureSongs = _fetchSongs();

    super.initState();
  }

  Future<List<Map<String, String>>> _fetchSongs() async {
    final url = Uri.parse(hostname + currentPageLink);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final document = html_parser.parse(response.body);
      final pageTitle = document.getElementsByTagName("h1")[0].text.decoded;
      currentPageTitle = pageTitle;
      final tableRows = document.querySelectorAll('table.list tr.li');
      final List<Map<String, String>> songs = [];

      for (final row in tableRows) {
        final titleElement = row.getElementsByTagName('a');
        final tdElements = row.getElementsByTagName('td');

        final title = titleElement[0].text.decoded;
        final href = titleElement[0].attributes['href'].toString();
        final authors = tdElements[1].text.decoded;

        final songMap = {
          'title': title,
          'href': href,
          'authors': authors,
        };

        songs.add(songMap);
      }

      return songs;
    } else {
      Logger().e('Failed to load HTML: ${response.statusCode}');
      throw Exception('Failed to load HTML');
    }
  }

  void _loadNextPage() {
    setState(() {
      currentPageLink = currentPageLink.replaceAllMapped(
        RegExp(r'\d+'),
        (match) => (int.parse(match.group(0)!) + 1).toString(),
      );
      currentPageIndex += 1;
      futureSongs = _fetchSongs();
    });
  }

  void _loadPreviousPage() {
    setState(() {
      currentPageLink = currentPageLink.replaceAllMapped(
        RegExp(r'\d+'),
        (match) => (int.parse(match.group(0)!) - 1).toString(),
      );
      currentPageIndex -= 1;
      futureSongs = _fetchSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureSongs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          List<Map<String, String>> songs =
              snapshot.data as List<Map<String, String>>;
          return Scaffold(
            appBar: AppBar(
              title: Text(currentPageTitle),
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentPageIndex != 1)
                      IconButton(
                        onPressed: _loadPreviousPage,
                        icon: const Icon(Icons.chevron_left),
                        iconSize: 32,
                      ),
                    Text(
                      'Page: $currentPageIndex',
                      style: const TextStyle(fontSize: 22),
                    ),
                    IconButton(
                      onPressed: _loadNextPage,
                      icon: const Icon(Icons.chevron_right),
                      iconSize: 32,
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return ListTile(
                        title: Text(song['title'] ?? ''),
                        subtitle: Text(song['authors'] ?? ''),
                        trailing: Text(song['href'] ?? ''),
                        onTap: () {
                          if (song['href'] != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SongPage(songLink: song['href']!);
                                },
                              ),
                            );
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
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
