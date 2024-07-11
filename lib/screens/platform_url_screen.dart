import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetrackio/controllers/auth_controller.dart';
import 'package:codetrackio/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class Platform {
  final String name;
  final String imgUrl;
  final String url;
  final String username;
  bool isValid = false;
  Timer? debounce;

  TextEditingController controller;

  Platform(
    this.name,
    this.imgUrl,
    this.url,
    this.username,
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
        '',
        'leetcodeUsername'),
    Platform(
        'GeeksforGeeks',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/GeeksforGeeks.svg/1280px-GeeksforGeeks.svg.png',
        '',
        'gfgUsername'),
    // Platform('CodeStudio', '', 'https://www.naukri.com/code360/profile/'),
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
        if (data == null) {
          return true;
        } else {
          toast('Username not found ⚠️');
          return false;
        }
      } else {
        toast('Username not found ⚠️');
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
        if (data == "null") {
          toast('Username not found ⚠️');
          return false;
        } else {
          return true;
        }
      } else {
        toast('Username not found ⚠️');
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
        padding: EdgeInsets.all(width > 768 ? 25 : 10),
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width > 768 ? width * 0.1 : width * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Enter your username',
                        style: TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Colors.blueAccent.withOpacity(0.7))),
                        onPressed: () async {
                          // Handle update logic here
                          bool flag = true;
                          for (var platform in platforms) {
                            if (platform.controller.text.isNotEmpty) {
                              flag = false;
                            }
                          }
                          if (flag) {
                            toast('Please enter atleast 1 field');
                            return;
                          }
                          for (var platform in platforms) {
                            if (platform.controller.text.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(AuthController().getCurrentUser()!.uid)
                                  .update({
                                platform.username:
                                    platform.controller.text.trim()
                              });
                            }
                          }
                          context.goNamed('/home');
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
                        padding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: width * 0.01),
                        child: width > 768
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.network(
                                        platforms[index].imgUrl,
                                        width: 60,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.error,
                                            size: 55,
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Text(platforms[index].name),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: width * 0.5,
                                        child: TextField(
                                          controller:
                                              platforms[index].controller,
                                          onChanged: (value) async {
                                            if (platforms[index]
                                                    .debounce
                                                    ?.isActive ??
                                                false) {
                                              platforms[index]
                                                  .debounce!
                                                  .cancel();
                                            }
                                            platforms[index].debounce = Timer(
                                                const Duration(
                                                    milliseconds: 500),
                                                () async {
                                              bool isValid = index == 0
                                                  ? await saveLeetcodeUsername(
                                                      value)
                                                  : await saveGFGUsername(
                                                      value);
                                              setState(() {
                                                platforms[index].isValid =
                                                    isValid;
                                              });
                                            });
                                          },
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            hintText: 'Username',
                                            suffix: platforms[index]
                                                    .controller
                                                    .text
                                                    .isNotEmpty
                                                ? Icon(
                                                    platforms[index].isValid
                                                        ? Icons.check
                                                        : Icons.warning,
                                                    color:
                                                        platforms[index].isValid
                                                            ? Colors.green
                                                            : Colors.red,
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      platforms[index]
                                              .controller
                                              .text
                                              .isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () => {},
                                            )
                                          : const SizedBox(width: 40),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        platforms[index].imgUrl,
                                        width: 60,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.error,
                                            size: 55,
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        platforms[index].name,
                                        style: h3Style(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 0.6,
                                        child: TextField(
                                          controller:
                                              platforms[index].controller,
                                          onChanged: (value) async {
                                            if (platforms[index]
                                                    .debounce
                                                    ?.isActive ??
                                                false) {
                                              platforms[index]
                                                  .debounce!
                                                  .cancel();
                                            }
                                            platforms[index].debounce = Timer(
                                                const Duration(
                                                    milliseconds: 500),
                                                () async {
                                              bool isValid = index == 0
                                                  ? await saveLeetcodeUsername(
                                                      value)
                                                  : await saveGFGUsername(
                                                      value);
                                              setState(() {
                                                platforms[index].isValid =
                                                    isValid;
                                              });
                                            });
                                          },
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            hintText: 'Username',
                                            suffix: platforms[index]
                                                    .controller
                                                    .text
                                                    .isNotEmpty
                                                ? Icon(
                                                    platforms[index].isValid
                                                        ? Icons.check
                                                        : Icons.warning,
                                                    color:
                                                        platforms[index].isValid
                                                            ? Colors.green
                                                            : Colors.red,
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      platforms[index]
                                              .controller
                                              .text
                                              .isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () => {},
                                            )
                                          : const SizedBox(width: 40),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
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
