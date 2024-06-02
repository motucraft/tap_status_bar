import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_status_bar/status_bar_tap_notifier/status_bar_tap_notifier.dart';

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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarTapNotifier(
      onStatusBarTap: () => _controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear),
      child: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          controller: _controller,
          itemCount: 20,
          itemBuilder: (_, index) => ListTile(title: Text('Home ${index + 1}')),
        ),
      ),
    );
  }
}

class Like extends StatefulWidget {
  const Like({super.key});

  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarTapNotifier(
      onStatusBarTap: () => _controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear),
      child: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          controller: _controller,
          itemCount: 20,
          itemBuilder: (_, index) => ListTile(title: Text('Like ${index + 1}')),
        ),
      ),
    );
  }
}
