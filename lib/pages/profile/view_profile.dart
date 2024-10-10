import 'package:flutter/material.dart';

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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // User info section
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/user/user1.jpg'), // Replace with your image
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sanul Kavinda',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Member'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                      ),
                    ),
                  ],
                ),
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
                        SizedBox(height: 5),
                        Text('5 cleanup complete'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.event, color: Colors.orange),
                        SizedBox(height: 5),
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
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 3 / 2.5, // Adjusted for smaller box sizes
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
      ),

    );
  }

  // Helper method to create grid items with icon and label
  Widget _buildGridItem(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1877F2), // Yellow background for each grid item
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
