import '../components/post.dart';

class User {
  final String userId;
  final String userName;
  final String password;
  final String email;
  final String profilePicture;
  final List<Post> posts;
  final List followers;
  final List followings;

  const User({
    required this.userId,
    required this.userName,
    required this.password,
    required this.email,
    required this.profilePicture,
    required this.posts,
    required this.followers,
    required this.followings,
  });

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "password": password,
        "email": email,
        "profilePicture": profilePicture,
        "posts": posts,
        "followers": followers,
        "followings": followings,
      };
}
