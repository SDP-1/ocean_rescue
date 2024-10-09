import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/event/create_event_screen1.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/navbar/TopAppBar%20.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Events Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Events",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Lorem Ipsum Event ipsum lorem",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  _buildActionIcon(
                    Icons.add,
                    "Create Event",
                    ColorTheme.lightBlue1,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateEventScreen1()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Featured Events",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFeaturedEventCard('assets/event/event01.png'),
                  _buildFeaturedEventCard('assets/event/event02.png'),
                  _buildFeaturedEventCard('assets/event/event01.png'),
                  _buildFeaturedEventCard('assets/event/event02.png'),
                ],
              ),
            ),

            // Nearby Events (Map) Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Nearby Events",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/event/map.png',
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
              ),
            ),

            // All Events Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    "All Events",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.filter_list),
                ],
              ),
            ),

            // Event Cards (Placeholder)
            _buildEventCard(
              imageUrl: 'assets/event/event01.png',
              title: "SLIIT Beach Clean Up",
              date: "25 Sep 2024",
              time: "9:00 AM - 3:00 PM",
              location: "Galle Face Beach",
              volunteers: "25-50 Volunteers",
            ),
            _buildEventCard(
              imageUrl: 'assets/event/event02.png',
              title: "Marine Life Protection",
              date: "10 Oct 2024",
              time: "8:00 AM - 2:00 PM",
              location: "Mount Lavinia Beach",
              volunteers: "10-20 Volunteers",
            ),
            _buildEventCard(
              imageUrl: 'assets/event/event01.png',
              title: "Riverbank Clean Up",
              date: "15 Oct 2024",
              time: "7:00 AM - 12:00 PM",
              location: "Kelani Riverbank",
              volunteers: "15-30 Volunteers",
            ),

            // Load More Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Load more action
                  },
                  child: const Text("Load More"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: const Text(
        "Events",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: Colors.blue),
          onPressed: () {
            // Create event action
          },
        ),
      ],
    );
  }

  Widget _buildFeaturedEventCard(String imageUrl) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required String imageUrl,
    required String title,
    required String date,
    required String time,
    required String location,
    required String volunteers,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$date | $time",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      volunteers,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 24),
            onPressed: onPressed,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Colors.black54),
        ),
      ],
    );
  }
}
