import 'package:smartgarden/models/Comment.dart';
import 'package:smartgarden/models/Like.dart';
import 'package:smartgarden/models/user.dart';

class Post {
  final int postId;
  final User user;
  final String photo;
  final List<Like> likes;
  final List<Comment> comments;

  Post(
      {required this.postId,
      required this.user,
      required this.photo,
      required this.likes,
      required this.comments});
}
