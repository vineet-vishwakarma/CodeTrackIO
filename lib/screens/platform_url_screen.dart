import 'dart:async';
import 'dart:convert';

import 'package:codetrackio/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Platform {
  final String name;
  final String imgUrl;
  final String url;
  bool isValid = false;
  Timer? debounce;

  TextEditingController controller;

  Platform(
    this.name,
    this.imgUrl,
    this.url,
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
        ''),
    // Platform('CodeStudio', '', 'https://www.naukri.com/code360/profile/'),
    Platform(
        'GeeksforGeeks',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/GeeksforGeeks.svg/1280px-GeeksforGeeks.svg.png',
        ''),
    // Platform('Codechef', '', 'https://www.codechef.com/users/'),
    // Platform('Codeforces', '', 'https://codeforces.com/profile/'),
  ];

  void _deletePlatform(int index) {}

  Future<bool> _sendRequest(String url) async {
    try {
      final response = await http.post(
          Uri.parse('http://localhost:3000/fetchusername'),
          body: jsonEncode({'url': url}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $url $e');
      return false;
    }
  }

  Future<bool> saveLeetcodeUsername(String username) async {
    try {
      final response = await http.post(
          Uri.parse('https://codetrackserver.onrender.com/fetchleetcode'),
          body: jsonEncode({'username': username}),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['errors'];
        print(data);
        if (data == null) {
          return true;
        } else {
          toast('Username not found');
          return false;
        }
      } else {
        toast('Username not found');
        return false;
      }
    } on Exception catch (e) {
      toast(e.toString());
      return false;
    }
  }

  Future<bool> saveGFGUsername(String username) async {
    try {
      final response = await http.post(
          Uri.parse('https://codetrackserver.onrender.com/fetchgfg'),
          body: jsonEncode({'username': username}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['message'];
        print(data);
        if (data == "null") {
          toast('Username not found');
          return false;
        } else {
          return true;
        }
      } else {
        toast('Username not found');
        return false;
      }
    } on Exception catch (e) {
      toast(e.toString());
      return false;
    }
  }

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
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enter your username',
                        style: TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Colors.blueAccent.withOpacity(0.7))),
                        onPressed: () {
                          // Handle update logic here
                        },
                        child: Text('Update'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: platforms.length,
                    itemBuilder: (context, index) {
                      final _controller = platforms[index].controller;
                      final prefix = platforms[index].url;
                      _controller.addListener(() {
                        if (!_controller.text.startsWith(prefix)) {
                          _controller.text = prefix;
                          _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length),
                          );
                        }
                      });
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
                                    onChanged: (value) async {
                                      if (platforms[index].debounce?.isActive ??
                                          false) {
                                        platforms[index].debounce!.cancel();
                                      }
                                      platforms[index].debounce = Timer(
                                          const Duration(milliseconds: 500),
                                          () async {
                                        bool isValid = index == 0
                                            ? await saveLeetcodeUsername(value)
                                            : await saveGFGUsername(value);
                                        setState(() {
                                          platforms[index].isValid = isValid;
                                        });
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: 'Username',
                                      suffixIcon: Icon(
                                        platforms[index].isValid
                                            ? Icons.check
                                            : Icons.warning,
                                        color: platforms[index].isValid
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                platforms[index].controller.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => {},
                                      )
                                    : SizedBox(width: 40),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
