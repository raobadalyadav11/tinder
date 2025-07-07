class UserModel {
  final String id;
  final String name;
  final String email;
  final int age;
  final String gender;
  final String bio;
  final List<String> photos;
  final List<String> interests;
  final LocationModel location;
  final bool isOnline;
  final DateTime lastSeen;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.bio,
    required this.photos,
    required this.interests,
    required this.location,
    this.isOnline = false,
    required this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      age: json['age'] ?? 18,
      gender: json['gender'] ?? '',
      bio: json['bio'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      location: LocationModel.fromJson(json['location'] ?? {}),
      isOnline: json['isOnline'] ?? false,
      lastSeen: DateTime.parse(json['lastSeen'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'bio': bio,
      'photos': photos,
      'interests': interests,
      'location': location.toJson(),
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }
}

class LocationModel {
  final double latitude;
  final double longitude;
  final String address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.address = '',
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}