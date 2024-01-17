

import 'package:smartgarden/models/Post.dart';
import 'package:smartgarden/models/user.dart';

class Like {
  final int likeId;
  final User user;
  final Post post;

  Like({
    required this.likeId,
    required this.user,
    required this.post,
  });


}
