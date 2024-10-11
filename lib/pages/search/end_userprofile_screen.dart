import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:ocean_rescue/resources/enduser_firestore_methods.dart';
import 'package:ocean_rescue/widget/end_user/_StatColumn.dart';
import 'package:ocean_rescue/widget/end_user/_UserInfo.dart';
import 'package:ocean_rescue/widget/end_user/_MedalSection.dart';
import '../../models/user.dart';
import '../../resources/auth_methods.dart';
import '../chat/chat_detail_screen.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<Map<String, dynamic>> userAndStatsFuture;
  late Stream<bool> isFollowingStream;

  @override
  void initState() {
    super.initState();
    // Fetch both user details and stats at the same time for better performance
    userAndStatsFuture = fetchUserAndStats(widget.userId);
    isFollowingStream = getFollowingStream(
        auth.FirebaseAuth.instance.currentUser!.uid, widget.userId);
  }

  Future<Map<String, dynamic>> fetchUserAndStats(String userId) async {
    try {
      final userFuture = AuthMethods().getUserDetailsById(userId);
      final postFuture = FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: userId)
          .get();

      final userSnapshot =
          FirebaseFirestore.instance.collection('users').doc(userId).get();

      final results = await Future.wait([userFuture, postFuture, userSnapshot]);

      User user = results[0] as User;
      int postCount = (results[1] as QuerySnapshot).docs.length;
      DocumentSnapshot userDoc = results[2] as DocumentSnapshot;

      final followersCount = (userDoc['followers'] as List).length;
      final followingCount = (userDoc['following'] as List).length;

      return {
        'user': user,
        'postCount': postCount,
        'followersCount': followersCount,
        'followingCount': followingCount
      };
    } catch (e) {
      print('Error fetching user and stats: $e');
      throw Exception('Error fetching data');
    }
  }

  Stream<bool> getFollowingStream(String currentUserId, String targetUserId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .map((doc) {
      User currentUser = User.fromSnap(doc);
      return currentUser.following.contains(targetUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = auth.FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<Map<String, dynamic>>(
      future: userAndStatsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error loading user data')),
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data!['user'] as User;
          final postCount = snapshot.data!['postCount'] as int;
          final followersCount = snapshot.data!['followersCount'] as int;
          final followingCount = snapshot.data!['followingCount'] as int;

          return StreamBuilder<bool>(
            stream: isFollowingStream,
            builder: (context, followSnapshot) {
              if (followSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (followSnapshot.hasError) {
                return const Scaffold(
                  body: Center(child: Text('Error checking follow status')),
                );
              } else if (followSnapshot.hasData) {
                bool isFollowingUser = followSnapshot.data!;

                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Text(user.username),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProfilePicture(photoUrl: user.photoUrl),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        StatColumn(
                                          label: 'Post',
                                          count: postCount.toString(),
                                        ),
                                        StatColumn(
                                          label: 'Followers',
                                          count: followersCount.toString(),
                                        ),
                                        StatColumn(
                                          label: 'Following',
                                          count: followingCount.toString(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _ActionButtons(
                                      isFollowingUser: isFollowingUser,
                                      onFollowPressed: () async {
                                        await EnduserFirestoreMethods()
                                            .toggleFollow(
                                                currentUserId, widget.userId);
                                      },
                                      user: user,
                                      currentUserId: currentUserId,
                                      targetUserId: widget.userId,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        UserInfo(user: user),
                        const Divider(),
                        const MedalSection(),
                      ],
                    ),
                  ),
                );
              } else {
                return const Scaffold(
                  body: Center(child: Text('User not found')),
                );
              }
            },
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('User not found')),
          );
        }
      },
    );
  }
}

class _ProfilePicture extends StatelessWidget {
  final String photoUrl;

  const _ProfilePicture({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(photoUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isFollowingUser;
  final VoidCallback onFollowPressed;
  final User user;
  final String currentUserId;
  final String targetUserId;

  const _ActionButtons({
    required this.isFollowingUser,
    required this.onFollowPressed,
    required this.user,
    required this.currentUserId,
    required this.targetUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onFollowPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowingUser ? Colors.red : Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isFollowingUser ? 'Unfollow' : 'Follow',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                  chatId: '${currentUserId}_$targetUserId',
                  senderId: currentUserId,
                  receiverId: targetUserId,
                  name: user.username,
                  avatar: user.photoUrl,
                ),
              ),
            );
          },
          icon: const Icon(Icons.message),
          color: Colors.blue,
          iconSize: 30,
        ),
      ],
    );
  }
}
