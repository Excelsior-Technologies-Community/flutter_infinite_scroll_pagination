import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll_pagination/flutter_infinite_scroll_pagination.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Infinite Scroll Pagination Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PaginationController<String> controller;

  @override
  void initState() {
    super.initState();

    controller = PaginationController<String>(
      onLoadPage: (page) async {
        await Future.delayed(const Duration(seconds: 2));

        if (page > 5) {
          return [];
        }

        return List.generate(
          20,
              (index) => 'Item ${(page - 1) * 20 + index + 1}',
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Infinite Scroll Pagination',style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Expanded(
            child: InfiniteListView<String>(
              controller: controller,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, item, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item),
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
