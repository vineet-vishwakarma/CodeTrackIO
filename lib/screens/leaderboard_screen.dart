import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetrackio/controllers/auth_controller.dart';
import 'package:codetrackio/screens/navbar.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> users = [];
  String selectedPlatform = 'All';
  String selectedDifficulty = 'All';

  final firestore = FirebaseFirestore.instance.collection('users');

  Future<List> getUsersData() async {
    final querySnapshot =
        await firestore.orderBy('platform', descending: true).get();
    final users = querySnapshot.docs.map((doc) => doc.data()).toList();
    return users;
  }

  List filterByPlatform(List users, String platform) {
    return users
        .where((user) =>
            user.containsKey('platform') &&
            user['platform'].containsKey(platform))
        .toList();
  }

  List filterByDifficulty(List users, String difficulty, String platform) {
    return users
        .where((user) =>
            user.containsKey('platform') &&
            user['platform'].containsKey(platform) &&
            user['platform'][platform].containsKey(difficulty))
        .toList();
  }

  List filterByBoth(List users, String platform, String difficulty) {
    final platformFiltered = filterByPlatform(users, platform);
    return filterByDifficulty(platformFiltered, difficulty, platform);
  }

  List filterUsers() {
    if (selectedPlatform == 'All' && selectedDifficulty == 'All') {
      return users;
    } else if (selectedPlatform != 'All' && selectedDifficulty == 'All') {
      return filterByPlatform(users, selectedPlatform);
    } else if (selectedPlatform == 'All' && selectedDifficulty != 'All') {
      return filterByDifficulty(users, selectedDifficulty, selectedPlatform);
    } else {
      return filterByBoth(users, selectedPlatform, selectedDifficulty);
    }
  }

  @override
  void initState() {
    super.initState();
    getUsersData().then((filteredUsers) {
      setState(() {
        users = filteredUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUser = filterUsers();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width > 768
          ? const CustomAppbar()
          : AppBar(
              title: const Text('Leaderboard'),
              centerTitle: true,
              toolbarHeight: 60,
              scrolledUnderElevation: 0,
            ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildFilters(),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: width > 768 ? 5.0 : 2.0,
                horizontal: width > 768 ? 50 : 5),
            child: const Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Rank', style: TextStyle(fontSize: 17)),
                  ),
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 17),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Problem',
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getUsersData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildLeaderboard(filteredUser);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          width < 768 ? const CustomBottomNavigationBar() : null,
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Platform'),
            const SizedBox(width: 20),
            DropdownButton<String>(
              value: selectedPlatform,
              hint: const Text('Platform'),
              onChanged: (newValue) {
                setState(() {
                  selectedPlatform = newValue!;
                });
              },
              items: ['All', 'Leetcode', 'Gfg']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Difficulties'),
            const SizedBox(width: 20),
            DropdownButton<String>(
              value: selectedDifficulty,
              hint: const Text('Difficulty'),
              onChanged: (newValue) {
                setState(() {
                  selectedDifficulty = newValue!;
                });
              },
              items: ['All', 'Easy', 'Medium', 'Hard']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaderboard(List data) {
    double width = MediaQuery.of(context).size.width;
    data.sort((b, a) => a['platform'][selectedPlatform][selectedDifficulty]
        .compareTo(b['platform'][selectedPlatform][selectedDifficulty]));
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: width > 768 ? 5.0 : 2.0,
              horizontal: width > 768 ? 50 : 5),
          child: Card(
            color: data[index]['uid'] == AuthController().getCurrentUser()!.uid
                ? ThemeData().highlightColor
                : ThemeData().cardTheme.color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      (index + 1 < 10) ? '0${index + 1}' : '${index + 1}',
                      style: const TextStyle(fontSize: 17)),
                ),
                Text(
                  data[index]['fullname'],
                  style: const TextStyle(fontSize: 17),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '${data[index]['platform'][selectedPlatform][selectedDifficulty]}',
                    style: const TextStyle(fontSize: 17),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
