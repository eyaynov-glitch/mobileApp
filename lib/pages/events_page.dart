import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../services/firestore_service.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key, this.clubId});
  final String? clubId;

  @override
  Widget build(BuildContext context) {
    final asGrid = context.watch<AppState>().eventsAsGrid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morocco Campus Events'),
        actions: [
          IconButton(
            icon: Icon(asGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => context.read<AppState>().toggleEventLayout(!asGrid),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirestoreService.instance.events(clubId: clubId),
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (asGrid) {
            return GridView.count(
              crossAxisCount: 2,
              children: items
                  .map((e) => Card(
                        child: Column(
                          children: [
                            Expanded(child: Image.network(e.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image))),
                            Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${e.city} • ${e.date.toLocal()}'),
                          ],
                        ),
                      ))
                  .toList(),
            );
          }
          return ListView(
            children: items
                .map((e) => ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(e.imageUrl)),
                      title: Text(e.title),
                      subtitle: Text('${e.city} - ${e.description}'),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
