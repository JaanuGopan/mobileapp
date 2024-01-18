
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String imageUrl;
  final String caption;
  final String userId;
  final Timestamp timestamp;

  Post({
    required this.imageUrl,
    required this.caption,
    required this.userId,
    required this.timestamp,
  });
}