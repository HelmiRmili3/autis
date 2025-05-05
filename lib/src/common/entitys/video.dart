import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

class Video {
  final String id;
  final String title;
  final String thumbnail;
  final String videoUrl;
  final String duration;
  final String uploadDate;
  final String patientId; // Added patientId field

  Video({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
    required this.uploadDate,
    required this.patientId, // Added patientId to the constructor
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      videoUrl: json['videoUrl'],
      duration: json['duration'],
      uploadDate: json['uploadDate'],
      patientId:
          json['patientId'], // Added patientId to the factory constructor
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'duration': duration,
      'uploadDate': uploadDate,
      'patientId': patientId, // Added patientId to the JSON map
    };
  }

  // Static method to create a new Video instance with auto-generated ID and upload date
  static Video create({
    required String title,
    required String thumbnail,
    required String videoUrl,
    required String duration,
    required String patientId, // Added patientId as a required parameter
  }) {
    final String id = const Uuid().v4(); // Generate a new UUID
    final String uploadDate =
        DateTime.now().toIso8601String(); // Get current date and time
    return Video(
      id: id,
      title: title,
      thumbnail: thumbnail,
      videoUrl: videoUrl,
      duration: duration,
      uploadDate: uploadDate,
      patientId: patientId, // Pass patientId to the constructor
    );
  }
}

void main() {
  // Example usage of the create function
  Video newVideo = Video.create(
    title: "Sample Video",
    thumbnail: "http://example.com/thumbnail.jpg",
    videoUrl: "http://example.com/video.mp4",
    duration: "00:10:00",
    patientId: "12345", // Example patientId
  );

  // Print the JSON representation of the new video
  developer.log(newVideo.toJson().toString());
}
