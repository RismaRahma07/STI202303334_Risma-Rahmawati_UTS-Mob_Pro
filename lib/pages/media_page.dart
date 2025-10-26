import 'package:flutter/material.dart';
import '../models/event.dart';

class MediaPage extends StatelessWidget {
  final List<Event> events;
  const MediaPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final mediaItems = events
        .where((e) => e.gambarBytes != null && e.gambarBytes!.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: mediaItems.isEmpty
          ? const Center(
              child: Text('Belum ada media.', style: TextStyle(color: Colors.white70)),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: mediaItems.length,
              itemBuilder: (context, i) {
                final e = mediaItems[i];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: const Color(0xFF1E293B),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (e.gambarBytes != null)
                              Image.memory(e.gambarBytes!, fit: BoxFit.contain),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.judul, style: const TextStyle(color: Colors.white70)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(e.gambarBytes!, fit: BoxFit.cover),
                  ),
                );
              },
            ),
    );
  }
}
