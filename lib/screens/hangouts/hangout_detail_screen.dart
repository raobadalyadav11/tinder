import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/gradient_button.dart';

class HangoutDetailScreen extends StatefulWidget {
  final Map<String, dynamic> hangout;

  const HangoutDetailScreen({super.key, required this.hangout});

  @override
  State<HangoutDetailScreen> createState() => _HangoutDetailScreenState();
}

class _HangoutDetailScreenState extends State<HangoutDetailScreen> {
  bool _isRSVPed = false;
  final List<Map<String, String>> _participants = [
    {'name': 'Sarah', 'avatar': 'https://picsum.photos/100/100?random=p1'},
    {'name': 'Mike', 'avatar': 'https://picsum.photos/100/100?random=p2'},
    {'name': 'Emma', 'avatar': 'https://picsum.photos/100/100?random=p3'},
    {'name': 'John', 'avatar': 'https://picsum.photos/100/100?random=p4'},
    {'name': 'Lisa', 'avatar': 'https://picsum.photos/100/100?random=p5'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEventInfo(),
                  const SizedBox(height: 24),
                  _buildDescription(),
                  const SizedBox(height: 24),
                  _buildParticipants(),
                  const SizedBox(height: 24),
                  _buildGroupChat(),
                  const SizedBox(height: 32),
                  _buildRSVPButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getCategoryIcon(widget.hangout['category']),
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.hangout['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfo() {
    return Container(
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
        children: [
          _buildInfoRow(Icons.access_time, 'Time', widget.hangout['time']),
          const Divider(height: 24),
          _buildInfoRow(Icons.location_on, 'Location', widget.hangout['location']),
          const Divider(height: 24),
          _buildInfoRow(Icons.people, 'Participants', 
              '${widget.hangout['participants']}/${widget.hangout['maxParticipants']} joined'),
          const Divider(height: 24),
          _buildInfoRow(Icons.person, 'Host', widget.hangout['hostName']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this hangout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.hangout['description'],
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Participants',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '${widget.hangout['participants']} joined',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _participants.length,
            itemBuilder: (context, index) {
              final participant = _participants[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(participant['avatar']!),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      participant['name']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupChat() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.chat, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Group Chat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Chat with other participants',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.primaryColor,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildRSVPButton() {
    return GradientButton(
      text: _isRSVPed ? 'Cancel RSVP' : 'Join Hangout',
      width: double.infinity,
      gradientColors: _isRSVPed 
          ? [Colors.grey.shade400, Colors.grey.shade500]
          : [AppTheme.primaryColor, AppTheme.primaryLight],
      onPressed: () {
        setState(() => _isRSVPed = !_isRSVPed);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isRSVPed ? 'RSVP confirmed!' : 'RSVP cancelled'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Coffee':
        return Icons.local_cafe;
      case 'Outdoor':
        return Icons.nature;
      case 'Entertainment':
        return Icons.movie;
      case 'Sports':
        return Icons.sports;
      case 'Food':
        return Icons.restaurant;
      case 'Art':
        return Icons.palette;
      case 'Music':
        return Icons.music_note;
      default:
        return Icons.event;
    }
  }
}