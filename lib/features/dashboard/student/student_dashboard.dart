import 'package:flutter/material.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _DashboardCardData(
        title: 'Timetable',
        subtitle: 'View your weekly schedule',
        icon: Icons.calendar_today,
      ),
      _DashboardCardData(
        title: 'Courses & Syllabus',
        subtitle: 'Lessons, notes, and resources',
        icon: Icons.menu_book,
      ),
      _DashboardCardData(
        title: 'Grades',
        subtitle: 'Performance out of 20',
        icon: Icons.bar_chart,
      ),
      _DashboardCardData(
        title: 'Clubs',
        subtitle: 'Join campus communities',
        icon: Icons.groups,
      ),
      _DashboardCardData(
        title: 'Events',
        subtitle: 'Trips, talks, and more',
        icon: Icons.event,
      ),
      _DashboardCardData(
        title: 'Messaging',
        subtitle: 'Real-time chat',
        icon: Icons.chat_bubble_outline,
      ),
      _DashboardCardData(
        title: 'Profile',
        subtitle: 'Edit your details & activity',
        icon: Icons.person,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, Student'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your campus today',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track classes, events, messages, and progress in one place.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(card.icon),
                            ),
                            const Spacer(),
                            Text(
                              card.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              card.subtitle,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCardData {
  const _DashboardCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
