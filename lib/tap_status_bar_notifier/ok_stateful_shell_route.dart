import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_status_bar/tap_status_bar_notifier/tap_status_bar_notifier.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final likeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'like');

final routerConfig = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) => Root(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (_, __) => const MaterialPage(child: Home()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: likeNavigatorKey,
          routes: [
            GoRoute(
              path: '/like',
              pageBuilder: (_, __) => const MaterialPage(child: Like()),
            ),
          ],
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

class Root extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const Root({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
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
    return TapStatusBarNotifier(
      onTapStatusBar: () {
        if (GoRouter.of(context).routerDelegate.currentConfiguration.last.matchedLocation == '/home') {
          _controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear);
        }
      },
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
    return TapStatusBarNotifier(
      onTapStatusBar: () {
        if (GoRouter.of(context).routerDelegate.currentConfiguration.last.matchedLocation == '/like') {
          _controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear);
        }
      },
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
