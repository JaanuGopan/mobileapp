

import 'package:smartgarden/models/Post.dart';
import 'package:smartgarden/models/user.dart';

class Comment {
  final int commentId;
  final User user;
  final Post post;
  final String text;

  Comment(
      {required this.commentId,
      required this.user,
      required this.post,
      required this.text});
}
