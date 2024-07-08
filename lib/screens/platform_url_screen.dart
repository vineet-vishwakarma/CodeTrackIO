import 'package:flutter/material.dart';

class Platform {
  final String name;
  final String imgUrl;
  final String url;

  TextEditingController controller;

  Platform(
    this.name,
    this.imgUrl,
    this.url,
    // String controllerUrl,
  ) : controller = TextEditingController(text: url);
}

class PlatformUrlScreen extends StatefulWidget {
  const PlatformUrlScreen({super.key});

  @override
  PlatformUrlScreenState createState() => PlatformUrlScreenState();
}

class PlatformUrlScreenState extends State<PlatformUrlScreen> {
  List<Platform> platforms = [
    Platform(
        'Leetcode',
        'https://upload.wikimedia.org/wikipedia/commons/1/19/LeetCode_logo_black.png',
        'https://leetcode.com/u/_viineet_'),
    Platform(
        'CodeStudio', '', 'https://www.naukri.com/code360/profile/johndoe'),
    Platform('GeeksforGeeks', '',
        'https://www.geeksforgeeks.org/user/vineetvishwakarma'),
    Platform('Codechef', '', 'https://www.codechef.com/users/naam_nahi_pta'),
    Platform(
        'Codeforces', '', 'https://codeforces.com/profile/AyanVishwakarma'),
  ];

  void _deletePlatform(int index) {}

  @override
  void dispose() {
    // Dispose of all the controllers when the widget is disposed
    for (var platform in platforms) {
      platform.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You can update your platform details here.',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: platforms.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.network(
                                  platforms[index].imgUrl,
                                  width: 60,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.error,
                                      size: 55,
                                    );
                                  },
                                ),
                                SizedBox(width: 10),
                                Text(platforms[index].name),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.5,
                                  child: TextField(
                                    controller: platforms[index].controller,
                                    onChanged: (value) {
                                      print(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: platforms[index].url,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle update logic here
                  },
                  child: Text('Update'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'If you are getting this warning, please check the FAQ to know more.',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
