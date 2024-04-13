import 'package:flutter/material.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repositories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GitHubRepoList(),
    );
  }
}

class GitHubRepoList extends StatefulWidget {
  const GitHubRepoList({super.key});

  @override
  _GitHubRepoListState createState() => _GitHubRepoListState();
}

class _GitHubRepoListState extends State<GitHubRepoList> {
  List<dynamic> _repositories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRepositories();
  }

  Future<void> fetchRepositories() async {
    final response =
        await http.get(Uri.parse('https://api.github.com/repositories'));

    if (response.statusCode == 200) {
      setState(() {
        _repositories = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Repositories'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _repositories.length,
              itemBuilder: (context, index) {
                final repo = _repositories[index];
                return ListTile(
                  title: Text(repo['name']),
                  subtitle: Text(repo['description'] ?? 'No description'),
                  onTap: () {
                    // Do something when a repository is tapped
                  },
                );
              },
            ),
    );
  }
}
