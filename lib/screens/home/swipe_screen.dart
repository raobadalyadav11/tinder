import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/user_card.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> with TickerProviderStateMixin {
  final SwiperController _cardController = SwiperController();
  late AnimationController _likeAnimationController;
  late AnimationController _passAnimationController;
  late AnimationController _superLikeAnimationController;

  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Emma',
      'age': 24,
      'bio': 'Love hiking and coffee ☕',
      'images': ['https://picsum.photos/400/600?random=1'],
      'distance': '2 km away',
    },
    {
      'name': 'Sarah',
      'age': 26,
      'bio': 'Photographer & traveler 📸',
      'images': ['https://picsum.photos/400/600?random=2'],
      'distance': '5 km away',
    },
    {
      'name': 'Jessica',
      'age': 23,
      'bio': 'Yoga instructor 🧘‍♀️',
      'images': ['https://picsum.photos/400/600?random=3'],
      'distance': '3 km away',
    },
  ];

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _passAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _superLikeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _buildSwipeCards(),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryLight],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 20),
          ),
          Text(
            'ConnectSphere',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeCards() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Swiper(
        controller: _cardController,
        itemCount: _users.length,
        itemBuilder: (context, index) => UserCard(user: _users[index]),
        viewportFraction: 0.9,
        scale: 0.9,
        loop: false,
        onIndexChanged: (index) => _handleSwipe(index),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.close,
            color: Colors.grey.shade400,
            size: 56,
            onPressed: () => _handleSwipeAction('pass'),
            animationController: _passAnimationController,
          ),
          _buildActionButton(
            icon: Icons.star,
            color: AppTheme.accentColor,
            size: 48,
            onPressed: () => _handleSwipeAction('super_like'),
            animationController: _superLikeAnimationController,
          ),
          _buildActionButton(
            icon: Icons.favorite,
            color: AppTheme.primaryColor,
            size: 56,
            onPressed: () => _handleSwipeAction('like'),
            animationController: _likeAnimationController,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onPressed,
    required AnimationController animationController,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 0.9).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(size / 2),
            onTap: () {
              animationController.forward().then((_) {
                animationController.reverse();
              });
              onPressed();
            },
            child: Icon(icon, color: color, size: size * 0.4),
          ),
        ),
      ),
    );
  }

  void _handleSwipe(int index) {
    if (index % 3 == 0) {
      _showFeedback('Liked', Icons.favorite, AppTheme.primaryColor);
      _checkForMatch();
    } else if (index % 3 == 1) {
      _showFeedback('Passed', Icons.close, Colors.grey);
    } else {
      _showFeedback('Super Like!', Icons.star, AppTheme.accentColor);
      _checkForMatch();
    }
  }

  void _handleSwipeAction(String action) async {
    final swipeProvider = Provider.of<SwipeProvider>(context, listen: false);
    
    try {
      bool isMatch = false;
      
      switch (action) {
        case 'like':
          isMatch = await swipeProvider.likeUser();
          _showFeedback('Liked', Icons.favorite, AppTheme.primaryColor);
          break;
        case 'pass':
          await swipeProvider.passUser();
          _showFeedback('Passed', Icons.close, Colors.grey);
          break;
        case 'super_like':
          isMatch = await swipeProvider.superLikeUser();
          _showFeedback('Super Like!', Icons.star, AppTheme.accentColor);
          break;
      }
      
      if (isMatch) {
        _showMatchDialog();
        NotificationService.showMatchNotification('Emma', 'avatar_url');
      }
      
      _cardController.next();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showFeedback(String text, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _checkForMatch() {
    if (DateTime.now().millisecond % 3 == 0) {
      _showMatchDialog();
    }
  }

  void _showMatchDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 60),
              const SizedBox(height: 16),
              const Text(
                "It's a Match!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You and Emma liked each other',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Keep Swiping', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Say Hello'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    _passAnimationController.dispose();
    _superLikeAnimationController.dispose();
    super.dispose();
  }
}