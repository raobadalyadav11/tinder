import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/theme/app_theme.dart';
import 'hangout_create_screen.dart';
import 'hangout_detail_screen.dart';

class HangoutListScreen extends StatefulWidget {
  const HangoutListScreen({super.key});

  @override
  State<HangoutListScreen> createState() => _HangoutListScreenState();
}

class _HangoutListScreenState extends State<HangoutListScreen> {
  final List<Map<String, dynamic>> _hangouts = [
    {
      'id': '1',
      'title': 'Coffee & Chat',
      'description': 'Let\'s grab coffee and have a great conversation!',
      'location': 'Starbucks Downtown',
      'time': 'Today, 3:00 PM',
      'participants': 5,
      'maxParticipants': 8,
      'category': 'Coffee',
      'distance': '0.5 km away',
      'hostName': 'Sarah',
      'hostAvatar': 'https://picsum.photos/100/100?random=host1',
    },
    {
      'id': '2',
      'title': 'Hiking Adventure',
      'description': 'Join us for a scenic hike in the mountains!',
      'location': 'Mountain Trail Park',
      'time': 'Tomorrow, 8:00 AM',
      'participants': 3,
      'maxParticipants': 6,
      'category': 'Outdoor',
      'distance': '2.1 km away',
      'hostName': 'Mike',
      'hostAvatar': 'https://picsum.photos/100/100?random=host2',
    },
    {
      'id': '3',
      'title': 'Movie Night',
      'description': 'Watch the latest blockbuster together!',
      'location': 'Cinema Plaza',
      'time': 'Friday, 7:30 PM',
      'participants': 7,
      'maxParticipants': 10,
      'category': 'Entertainment',
      'distance': '1.3 km away',
      'hostName': 'Emma',
      'hostAvatar': 'https://picsum.photos/100/100?random=host3',
    },
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Coffee', 'Outdoor', 'Entertainment', 'Sports'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilters(),
            Expanded(child: _buildHangoutsList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HangoutCreateScreen()),
        ),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group Hangouts',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Join local events near you',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.location_on, color: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHangoutsList() {
    final filteredHangouts = _selectedFilter == 'All' 
        ? _hangouts 
        : _hangouts.where((h) => h['category'] == _selectedFilter).toList();

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filteredHangouts.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildHangoutCard(filteredHangouts[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHangoutCard(Map<String, dynamic> hangout) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HangoutDetailScreen(hangout: hangout),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(hangout['hostAvatar']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hangout['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Hosted by ${hangout['hostName']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hangout['category'],
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              hangout['description'],
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hangout['location'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Text(
                  hangout['distance'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  hangout['time'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                Icon(Icons.people, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${hangout['participants']}/${hangout['maxParticipants']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}