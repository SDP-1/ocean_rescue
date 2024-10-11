import 'package:flutter/material.dart';

import '../profile/view_profile.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
              onTap: () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ViewProfilePage()),
        );
        },
              child: const Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'About Membership',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    membershipCard('Platinum', 'assets/medals/platinum.png', 'Exclusive access to all premium features, priority support, and additional rewards. Unlock the ultimate benefits with our highest tier membership.'),
                    membershipCard('Gold', 'assets/medals/gold.png', 'Enhanced access to premium features and priority customer support. Stay ahead with extra perks and rewards.'),
                    membershipCard('Silver', 'assets/medals/silver.png', 'Enjoy access to several premium features and faster support to enhance your experience.'),
                    membershipCard('Bronze', 'assets/medals/bronze.png', 'Basic membership that offers entry-level access to the platform’s features and community support.'),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget membershipCard(String title, String imagePath, String description) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 70,
          height: 90,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1877F2),
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
