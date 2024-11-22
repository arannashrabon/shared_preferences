import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(BookmarksApp());
}

class BookmarksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookmarks App',
      home: BookmarksPage(),
    );
  }
}

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<String> _bookmarks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarks = prefs.getStringList('bookmarks') ?? [];
    });
  }

  Future<void> _addBookmark() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _bookmarks.add(_controller.text);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('bookmarks', _bookmarks);
      _controller.clear();
    }
  }

  Future<void> _removeBookmark(int index) async {
    setState(() {
      _bookmarks.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarks', _bookmarks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Add Bookmark',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addBookmark,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_bookmarks[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeBookmark(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}