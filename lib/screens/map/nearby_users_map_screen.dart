import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../utils/location_helper.dart';
import '../../providers/map_provider.dart';
import '../profile/user_profile_view_screen.dart';

class NearbyUsersMapScreen extends StatefulWidget {
  const NearbyUsersMapScreen({super.key});

  @override
  State<NearbyUsersMapScreen> createState() => _NearbyUsersMapScreenState();
}

class _NearbyUsersMapScreenState extends State<NearbyUsersMapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  final List<Map<String, dynamic>> _nearbyUsers = [
    {
      'id': '1',
      'name': 'Emma',
      'age': 24,
      'avatar': 'https://picsum.photos/200/200?random=user1',
      'distance': '0.5 km',
      'latitude': 37.7849,
      'longitude': -122.4094,
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Sarah',
      'age': 26,
      'avatar': 'https://picsum.photos/200/200?random=user2',
      'distance': '1.2 km',
      'latitude': 37.7849,
      'longitude': -122.4074,
      'isOnline': false,
    },
    {
      'id': '3',
      'name': 'Jessica',
      'age': 23,
      'avatar': 'https://picsum.photos/200/200?random=user3',
      'distance': '2.1 km',
      'latitude': 37.7829,
      'longitude': -122.4084,
      'isOnline': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      final mapProvider = Provider.of<MapProvider>(context, listen: false);
      await mapProvider.loadNearbyUsers();
      
      _currentPosition = mapProvider.currentPosition;
      if (_currentPosition != null) {
        await _createMarkers();
      }
    } catch (e) {
      print('Error initializing map: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createMarkers() async {
    final markers = <Marker>{};

    // Add current user marker
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_user'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: await _createCustomMarker(
            'https://picsum.photos/200/200?random=me',
            AppTheme.primaryColor,
            true,
          ),
          infoWindow: const InfoWindow(title: 'You'),
        ),
      );
    }

    // Add nearby users markers
    for (final user in _nearbyUsers) {
      markers.add(
        Marker(
          markerId: MarkerId(user['id']),
          position: LatLng(user['latitude'], user['longitude']),
          icon: await _createCustomMarker(
            user['avatar'],
            user['isOnline'] ? AppTheme.successColor : AppTheme.textSecondary,
            false,
          ),
          infoWindow: InfoWindow(
            title: '${user['name']}, ${user['age']}',
            snippet: user['distance'],
          ),
          onTap: () => _showUserProfile(user),
        ),
      );
    }

    setState(() => _markers = markers);
  }

  Future<BitmapDescriptor> _createCustomMarker(String imageUrl, Color color, bool isCurrentUser) async {
    return BitmapDescriptor.defaultMarkerWithHue(
      isCurrentUser ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildTopBar(),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    if (_isLoading || _currentPosition == null) {
      return Container(
        color: AppTheme.backgroundColor,
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 14,
      ),
      markers: _markers,
      onMapCreated: (controller) => _mapController = controller,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nearby Users',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${_nearbyUsers.length} users found',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _centerOnCurrentLocation,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.my_location, color: AppTheme.secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Nearby Users',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _nearbyUsers.length,
                  itemBuilder: (context, index) {
                    return _buildUserCard(_nearbyUsers[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return GestureDetector(
      onTap: () => _showUserProfile(user),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user['avatar']),
                ),
                if (user['isOnline'])
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user['name']}, ${user['age']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        user['distance'],
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
            GestureDetector(
              onTap: () => _focusOnUser(user),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.center_focus_strong, color: AppTheme.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserProfile(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileViewScreen(user: user),
      ),
    );
  }

  void _focusOnUser(Map<String, dynamic> user) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(user['latitude'], user['longitude']),
        16,
      ),
    );
  }

  void _centerOnCurrentLocation() {
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          14,
        ),
      );
    }
  }
}