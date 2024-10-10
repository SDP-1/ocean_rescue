import 'package:flutter/material.dart';
import '../../widget/button/GradientButton.dart';

class ViewProfilePage extends StatefulWidget {
        const ViewProfilePage({super.key});

        @override
        State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(
              Icons.search,
              color: Color(0xFF1877F2),
            ),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.message,
              color: Color(0xFF1877F2),
            ),
            tooltip: 'Message',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Row for profile photo and stats
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Aligns to the left
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                // Profile photo on the left
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/user/user1.jpg'), // Replace with your image
                ),
                const SizedBox(width: 20),

                // Stats on the right
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns the stats to the start
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
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
                      const SizedBox(height: 15),

                      Center(
                        child: GradientButton(
                          text: "Sign Out",
                          onTap: () {
                            // Add your logic for changing password
                          },
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Bronze Member achievement, other sections, etc.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/medals/bronze.png', // Replace with actual asset path
                  width: 50,
                  height: 50,
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
                  physics: NeverScrollableScrollPhysics(), // Disable grid scrolling
                  children: [
                    _buildGridItem(Icons.group, 'Followers'),
                    _buildGridItem(Icons.group_add, 'Following'),
                    _buildGridItem(Icons.history, 'Event History'),
                    _buildGridItem(Icons.leaderboard, 'Leader board'),
                    _buildGridItem(Icons.rss_feed, 'Feed'),
                    _buildGridItem(Icons.event_available, 'Event'),
                  ],
                ),
              ),
              const Divider(),
              // Rest of the options
              const ListTile(
                leading: Icon(Icons.card_membership),
                title: Text('About Memberships'),
              ),
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
                title: Text('Terms & Policies'),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('About Us'),
              ),
            ],
          ),
        ),


    );
  }

  // Helper method to create grid items with icon and label
  Widget _buildGridItem(IconData icon, String label) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFFDCF2F1), // Yellow background for each grid item
        borderRadius: BorderRadius.circular(8), // Slightly reduced corner radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.black), // Smaller icon size
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12, // Smaller font size
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
