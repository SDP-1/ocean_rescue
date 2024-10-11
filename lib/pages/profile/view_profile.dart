import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocean_rescue/pages/Achievements/achievements_page.dart';
import '../../widget/common/GradientButton.dart';
import '../leaderboard/leaderboard.dart';
import '../membership/membership.dart';
import '../welcome/signin_screen.dart';
import 'edit_profile.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize Firestore
  String username = ''; // Variable to store username
  int exp = 0; // Variable to store experience points
  bool isLoading = true; // Variable to track loading state
  String errorMessage = ''; // Variable to store error messages

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch user profile on initialization
  }

  Future<void> _fetchUserProfile() async {
    // Get the current user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      try {
        // Fetch the user document from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          // Assuming the username and exp fields are stored in Firestore
          var data = userDoc.data() as Map<String, dynamic>; // Get data as a Map
          setState(() {
            username = data['username'] ?? 'Unknown'; // Set the username
            exp = data['exp'] ?? 0; // Set the exp
            isLoading = false; // Set loading to false once data is fetched
          });
        } else {
          setState(() {
            errorMessage = 'User not found';
            isLoading = false; // Set loading to false if user document does not exist
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Error fetching user profile: $e'; // Set error message
          isLoading = false; // Set loading to false in case of an error
        });
      }
    } else {
      setState(() {
        errorMessage = 'User is not logged in'; // Set error message if UID is null
        isLoading = false; // Set loading to false if UID is null
      });
    }
  }

  String _getMembershipBadge(int exp) {
    if (exp < 50) {
      return 'assets/medals/bronze.png'; // Bronze badge
    } else if (exp < 100) {
      return 'assets/medals/silver.png'; // Silver badge
    } else if (exp < 150) {
      return 'assets/medals/gold.png'; // Gold badge
    } else {
      return 'assets/medals/platinum.png'; // Platinum badge
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            'assets/logo/logo_without_name.png',
            fit: BoxFit.contain,
            width: 30,
            height: 30,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.message, color: Color(0xFF1877F2)),
            tooltip: 'Message',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF1877F2)),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage)) // Show error message
          : Container(
        color: Colors.white,
            child: SingleChildScrollView(
                    child: Column(
            children: [
              const SizedBox(height: 20),
              // Row for profile photo and stats
              // Row for profile photo and stats
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Aligns to the left
                crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the top
                children: [
                  const SizedBox(width: 20),
                  // Left side - Profile photo, username, and exp
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/user/user1.jpg'), // Replace with your image
                      ),
                      const SizedBox(height: 10), // Space between image and username
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5), // Space between username and exp
                      Text(
                        'Exp: $exp', // Changed to 'Experience'
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20), // Space between the two sections

                  // Right side - Stats and Edit Profile button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligns the stats to the start
                      children: [
                        const SizedBox(height: 10), // Space for the top
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text('Post'),
                              ],
                            ),
                            Column(
                              children: [
                                Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text('Followers'),
                              ],
                            ),
                            Column(
                              children: [
                                Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text('Following'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30), // Space between stats and button

                        Center(
                          child: GradientButton(
                            text: "Edit Profile",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const EditProfile()),
                              );
                            },
                            width: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 20),

              // Membership achievement section with dynamic badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MembershipPage()),
                      );
                    },
                    child: Image.asset(
                      _getMembershipBadge(exp), // Get badge based on exp
                      width: 50,
                      height: 50,
                    ),
                  ),

                  const SizedBox(width: 10),
                  const Text(
                    'Member',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              // Achievements Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.yellow),
                        SizedBox(width: 10),
                        Text(
                          'Achievements',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text('See All', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.cleaning_services, color: Colors.red),
                        SizedBox(height: 10),
                        Text('5 cleanup complete'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.event, color: Colors.orange),
                        SizedBox(height: 10),
                        Text('2 Event create complete'),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Grid with 2 columns and 3 rows
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: GridView.count(
                  shrinkWrap: true, // Ensures the grid doesn't take up infinite height
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 2 / 1, // Adjusted for smaller box sizes
                  physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
                  children: [
                    _buildGridItem(Icons.group, 'Followers', () {}),
                    _buildGridItem(Icons.group_add, 'Following', () {}),
                    _buildGridItem(Icons.history, 'Event History', () {}),
                    _buildGridItem(Icons.leaderboard, 'Leader board', () {
                      // Add your leaderboard page navigation here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaderboardPage(), // Create a LeaderboardPage
                        ),
                      );
                    }),
                    _buildGridItem(Icons.card_membership, 'Memberships', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MembershipPage()),
                      );
                    }),
                    _buildGridItem(Icons.emoji_events, 'Achievements', () {
                      Navigator.push(
                          context,
                        MaterialPageRoute(builder: (context) => const AchievementsPage()),
                      );
                    }),
                  ],
                ),
              ),
              const Divider(),
              // Rest of the options
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings & Privacy'),
              ),
              const ListTile(
                leading: Icon(Icons.help),
                title: Text('Help & Support'),
              ),
              const ListTile(
                leading: Icon(Icons.policy),
                title: Text('Privacy Policy'),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () async {
                  // Show confirmation dialog
                  bool? shouldSignOut = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false), // Close the dialog
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true), // Confirm sign out
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );

                  // Check if the user confirmed to sign out
                  if (shouldSignOut == true) {
                    try {
                      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
                      // Navigate to the login page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()), // Replace with your actual login page
                      );
                    } catch (e) {
                      // Handle any errors that might occur during sign out
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error signing out: $e')),
                      );
                    }
                  }
                },
              )


            ],
                    ),
                  ),
          ),
    );
  }


  Widget _buildGridItem(IconData icon, String title, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 25),
              const SizedBox(height: 10),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
