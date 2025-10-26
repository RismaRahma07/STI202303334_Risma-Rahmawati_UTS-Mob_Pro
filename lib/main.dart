import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/media_page.dart';
import 'models/event.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const EventPlannerApp());
}

class EventPlannerApp extends StatelessWidget {
  const EventPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Planner',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF60A5FA),
          secondary: Color(0xFF93C5FD),
          surface: Color(0xFF1E293B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF60A5FA),
        ),
      ),
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  List<Event> _events = [];

  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await _storageService.loadEvents();
    setState(() => _events = events);
  }

  Future<void> _saveEvents() async {
    await _storageService.saveEvents(_events);
  }

  void _addEvent(Event event) {
    setState(() => _events.add(event));
    _saveEvents();
  }

  void _removeEvent(int index) {
    setState(() => _events.removeAt(index));
    _saveEvents();
  }

  void _exportEvents() async {
    await _storageService.exportToDownloads(_events);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event berhasil diekspor ke Downloads')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        events: _events,
        onAddEvent: _addEvent,
        onRemoveEvent: _removeEvent,
        onExport: _exportEvents,
      ),
      MediaPage(events: _events),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Planner'),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E293B),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF60A5FA),
        unselectedItemColor: Colors.grey[400],
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Event'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Media'),
        ],
      ),
    );
  }
}
