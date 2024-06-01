import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerConfig = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: rootNavigatorKey,
      builder: (_, __, child) {
        return Root(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (_, __) => const MaterialPage(child: Home()),
        ),
        GoRoute(
          path: '/like',
          pageBuilder: (_, __) => const MaterialPage(child: Like()),
        ),
      ],
    ),
  ],
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routerConfig,
    );
  }
}

class Root extends StatefulWidget {
  final Widget child;

  const Root({super.key, required this.child});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Like',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });

          switch (value) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/like');
              break;
          }
        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (_, index) => ListTile(title: Text('Home ${index + 1}')),
      ),
    );
  }
}

class Like extends StatelessWidget {
  const Like({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        primary: true,
        itemCount: 20,
        itemBuilder: (_, index) => ListTile(title: Text('Like ${index + 1}')),
      ),
    );
  }
}
