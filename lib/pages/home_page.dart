import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../pages/add_event_page.dart';

class HomePage extends StatelessWidget {
  final List<Event> events;
  final Function(Event) onAddEvent;
  final Function(int) onRemoveEvent;
  final VoidCallback onExport;

  const HomePage({
    super.key,
    required this.events,
    required this.onAddEvent,
    required this.onRemoveEvent,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEventPage(onSave: onAddEvent),
            ),
          );
          if (newEvent != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event berhasil ditambahkan')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      body: events.isEmpty
          ? const Center(
              child: Text(
                'Belum ada event',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: events.length,
              itemBuilder: (context, i) {
                return EventCard(
                  event: events[i],
                  onDelete: () => onRemoveEvent(i),
                );
              },
            ),
    );
  }
}
