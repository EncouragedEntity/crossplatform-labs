import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:webpage_parser/logic/decoded_string.dart';

import '../../data/constants/string_constants.dart';

class SongPage extends StatefulWidget {
  const SongPage({Key? key, required this.songLink}) : super(key: key);

  final String songLink;

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  String currentPageTitle = "";
  late Future<String> futureSongContent;

  @override
  void initState() {
    super.initState();
    futureSongContent = _fetchSongContent();
  }

  Future<String> _fetchSongContent() async {
    final url = Uri.parse('$hostname${widget.songLink}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final document = html_parser.parse(response.body);
      final songContentElement = document.querySelector('pre.songwords');

      final pageTitle = document.querySelector('h1.nomarg')?.text.decoded ?? "";
      currentPageTitle = pageTitle;

      if (songContentElement != null) {
        setState(() {});

        return songContentElement.text.decoded;
      } else {
        throw Exception('Song content not found in HTML');
      }
    } else {
      throw Exception('Failed to load HTML: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPageTitle),
      ),
      body: FutureBuilder(
        future: futureSongContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final songContent = snapshot.data as String;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songContent,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
