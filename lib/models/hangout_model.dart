import 'user_model.dart';

class HangoutModel {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final LocationModel location;
  final DateTime dateTime;
  final int maxParticipants;
  final List<String> participants;
  final String category;
  final bool isActive;

  HangoutModel({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.location,
    required this.dateTime,
    required this.maxParticipants,
    required this.participants,
    required this.category,
    this.isActive = true,
  });

  factory HangoutModel.fromJson(Map<String, dynamic> json) {
    return HangoutModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      creatorId: json['creatorId'] ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
      dateTime: DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()),
      maxParticipants: json['maxParticipants'] ?? 10,
      participants: List<String>.from(json['participants'] ?? []),
      category: json['category'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'location': location.toJson(),
      'dateTime': dateTime.toIso8601String(),
      'maxParticipants': maxParticipants,
      'participants': participants,
      'category': category,
      'isActive': isActive,
    };
  }
}