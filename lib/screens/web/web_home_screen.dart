import 'dart:convert';

import 'package:codetrackio/controllers/auth_controller.dart';
import 'package:codetrackio/screens/navbar.dart';
import 'package:codetrackio/widgets/custom_button.dart';
import 'package:codetrackio/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetrackio/utils/utils.dart';
import 'package:codetrackio/widgets/custom_heatmap.dart';
import 'package:codetrackio/widgets/difficulty_tile.dart';
import 'package:codetrackio/widgets/language_chip.dart';
import 'package:codetrackio/widgets/platform_card.dart';
import 'package:codetrackio/widgets/platform_name.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class WebHomeScreen extends StatefulWidget {
  final DocumentSnapshot snapshot;
  const WebHomeScreen({super.key, required this.snapshot});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  List<dynamic> leetcodeData = [];
  List<dynamic> gfgData = [];
  final leetcodeUsernameController = TextEditingController();
  final gfgUsernameController = TextEditingController();
  Set<String> totalLanguages = {};

  saveLeetcodeUsername(String username) async {
    try {
      // final response = await http.get(Uri.parse(
      //     'https://leetcode.com/graphql?query=query%20{%20userContestRanking(username:%20%20%22$username%22)%20{%20attendedContestsCount%20rating%20globalRanking%20totalParticipants%20topPercentage%20}}'));

      final response = await http.post(
          Uri.parse('http://localhost:3000/fetchleetcode'),
          body: jsonEncode({'username': username}),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthController().getCurrentUser()!.uid)
            .update({'leetcodeUsername': username});

        fetchLeetcode();
      } else {
        Fluttertoast.showToast(msg: 'Username not found');
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  saveGfgUsername(String username) async {
    try {
      // final response = await http
      //     .get(Uri.parse('https://www.geeksforgeeks.org/user/$username/'));
      final response = await http.post(
          Uri.parse('http://localhost:3000/fetchgfg'),
          body: jsonEncode({'username': username}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthController().getCurrentUser()!.uid)
            .update({'gfgUsername': username});

        fetchGFG();
      } else {
        Fluttertoast.showToast(msg: 'Username not found');
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> fetchLeetcode() async {
    String username = widget.snapshot['leetcodeUsername'];
    // final response = await http.get(
    //   Uri.parse(
    //       'https://leetcode.com/graphql?query=query%20{%20userContestRanking(username:%20%20%22$username%22)%20{%20attendedContestsCount%20rating%20topPercentage%20}%20recentAcSubmissionList(username:%20%22$username%22,%20limit:%2025)%20{%20id%20title%20titleSlug%20timestamp%20}%20matchedUser(username:%20%22$username%22)%20{%20username%20userCalendar(year:%202024)%20{%20activeYears%20streak%20totalActiveDays%20dccBadges%20{%20timestamp%20badge%20{%20name%20icon%20}%20}%20submissionCalendar%20}%20activeBadge%20{%20displayName%20icon%20}%20submitStats:%20submitStatsGlobal%20{%20acSubmissionNum%20{%20difficulty%20count%20submissions%20}%20}%20languageProblemCount%20{%20languageName%20problemsSolved%20}%20problemsSolvedBeatsStats%20{%20difficulty%20percentage%20}%20}%20}'),
    // );
    try {
      final response = await http.post(
          Uri.parse('http://localhost:3000/fetchleetcode'),
          body: jsonEncode({'username': username}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data']['matchedUser']
            ['submitStats']['acSubmissionNum'];

        final languagesJson = jsonDecode(response.body)['data']['matchedUser']
            ['languageProblemCount'];

        final submission = jsonDecode(response.body)['data']['matchedUser']
            ['userCalendar']['submissionCalendar'];
        final submissionData = jsonDecode(submission);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthController().getCurrentUser()!.uid)
            .update({
          'leetcodeData': data,
          'submissionData': submissionData,
        });

        List<String> languages = [];

        languagesJson.forEach((map) {
          languages.add(map['languageName']);
        });

        setState(() {
          totalLanguages.addAll(languages);
        });
      } else {
        throw Exception('Error');
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString(), timeInSecForIosWeb: 100);
    }
  }

  int extract(String text) {
    String digits = '';
    for (int i = 0; i < text.length; i++) {
      if (text[i].contains(RegExp(r'[0-9]'))) {
        digits += text[i];
      }
    }
    int number = int.parse(digits);
    return number;
  }

  Future<void> fetchGFG() async {
    String username = widget.snapshot['gfgUsername'];
    try {
      // final response = await http
      //     .get(Uri.parse('https://www.geeksforgeeks.org/user/$username/'));

      final response = await http.post(
        Uri.parse('http://localhost:3000/fetchgfg'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final document = parser.parse(res);

        final question = document.querySelector(
            '#comp > div.AuthLayout_outer_div__20rxz > div > div.AuthLayout_head_content__ql3r2 > div > div > div.solvedProblemContainer_head__ZyIn0 > div.solvedProblemSection_head__VEUg4 > div.problemNavbar_head__cKSRi');
        final questionItems = question!.querySelectorAll('div');

        List<int> questionsNumbers = [];
        for (var element in questionItems) {
          int number = extract(element.text);
          questionsNumbers.add(number);
        }

        final language = document.querySelector(
            '#comp > div.AuthLayout_outer_div__20rxz > div > div.AuthLayout_head_content__ql3r2 > div > div > div._userName__head_userDetailsSection_section1__2fMAG > div > div.userDetails_head_right__YQBLH > div > div.educationDetails_head__eNlYv > div.educationDetails_head_right__x_qsr > div.educationDetails_head_right--text__lLOHI');

        final languageItems = language!.text;
        List<String> languages =
            languageItems.split(',').map((lang) => lang.trim()).toList();

        final data = [
          questionsNumbers[0],
          questionsNumbers[2],
          questionsNumbers[4],
          questionsNumbers[6],
          questionsNumbers[8],
        ];

        await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthController().getCurrentUser()!.uid)
            .update({'gfgData': data});

        setState(() {
          totalLanguages.addAll(languages);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString(), timeInSecForIosWeb: 100);
    }
  }

  updatePlatformData(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthController().getCurrentUser()!.uid)
        .update({'platform': data});
  }

  @override
  void initState() {
    if (widget.snapshot['leetcodeUsername'] != '') {
      fetchLeetcode();
    }
    if (widget.snapshot['gfgUsername'] != '') {
      fetchGFG();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    final String username = widget.snapshot['username'];
    final String leetcodeUsername = widget.snapshot['leetcodeUsername'];
    final String gfgUsername = widget.snapshot['gfgUsername'];

    gfgData = widget.snapshot['gfgData'];
    leetcodeData = widget.snapshot['leetcodeData'];
    final Map<String, dynamic> dataSets = widget.snapshot['submissionData'];

    int leetcodeEasy = 0;
    int leetcodeMedium = 0;
    int leetcodeHard = 0;
    int gfgEasy = 0;
    int gfgMedium = 0;
    int gfgHard = 0;
    int leetcodeTotalEasy = 0;
    int leetcodeTotalMedium = 0;
    int leetcodeTotalHard = 0;
    int gfgTotalEasy = 0;
    int gfgTotalMedium = 0;
    int gfgTotalHard = 0;

    if (leetcodeUsername != '' && leetcodeData.isNotEmpty) {
      leetcodeEasy = leetcodeData[1]['count'];
      leetcodeMedium = leetcodeData[2]['count'];
      leetcodeHard = leetcodeData[3]['count'];
      leetcodeTotalEasy = 790;
      leetcodeTotalMedium = 1647;
      leetcodeTotalHard = 698;
    }

    if (gfgUsername != '' && gfgData.isNotEmpty) {
      gfgEasy = gfgData[0] + gfgData[1] + gfgData[2];
      gfgMedium = gfgData[3];
      gfgHard = gfgData[4];
      gfgTotalEasy = 1724;
      gfgTotalMedium = 1008;
      gfgTotalHard = 197;
    }

    Map<String, dynamic> platformData = {
      'All': {
        'All': leetcodeEasy +
            leetcodeHard +
            leetcodeMedium +
            gfgEasy +
            gfgMedium +
            gfgHard,
        'Easy': leetcodeEasy + gfgEasy,
        'Medium': leetcodeMedium + gfgMedium,
        'Hard': leetcodeHard + gfgHard,
      },
      'Leetcode': {
        'All': leetcodeEasy + leetcodeHard + leetcodeMedium,
        'Easy': leetcodeEasy,
        'Medium': leetcodeMedium,
        'Hard': leetcodeHard,
      },
      'Gfg': {
        'All': gfgEasy + gfgMedium + gfgHard,
        'Easy': gfgEasy,
        'Medium': gfgMedium,
        'Hard': gfgHard,
      }
    };

    updatePlatformData(platformData);

    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/animations/laptop.json',
                              width: 350),
                          const SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.snapshot['fullname'],
                                style: h1Style(),
                                softWrap: true,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(width: 5),
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 2.0),
                                    child: Icon(
                                      FontAwesomeIcons.medal,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Row(
                                    children: [
                                      Text(
                                        widget.snapshot['rank'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      const Text(
                                        ' Rank',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Card 1 Left
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5,
                                    backgroundColor: Colors.grey,
                                    value: (leetcodeTotalHard + gfgTotalHard) ==
                                            0
                                        ? 0
                                        : (leetcodeHard + gfgHard) /
                                                        (leetcodeTotalHard +
                                                            gfgTotalHard) +
                                                    (leetcodeTotalMedium +
                                                        gfgTotalMedium) ==
                                                0
                                            ? 0
                                            : (leetcodeMedium + gfgMedium) /
                                                            (leetcodeTotalMedium +
                                                                gfgTotalMedium) +
                                                        (gfgTotalEasy +
                                                            leetcodeTotalEasy) ==
                                                    0
                                                ? 0
                                                : (leetcodeEasy + gfgEasy) /
                                                    (gfgTotalEasy +
                                                        leetcodeTotalEasy),
                                    strokeCap: StrokeCap.round,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.red),
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5,
                                    value: (gfgTotalEasy + leetcodeTotalEasy) ==
                                            0
                                        ? 0
                                        : (leetcodeMedium + gfgMedium) /
                                                        (leetcodeTotalMedium +
                                                            gfgTotalMedium) +
                                                    (gfgTotalEasy +
                                                        leetcodeTotalEasy) ==
                                                0
                                            ? 0
                                            : (leetcodeEasy + gfgEasy) /
                                                (gfgTotalEasy +
                                                    leetcodeTotalEasy),
                                    strokeCap: StrokeCap.round,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.amberAccent),
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5,
                                    value: (gfgTotalEasy + leetcodeTotalEasy) ==
                                            0
                                        ? 0
                                        : (leetcodeEasy + gfgEasy) /
                                            (gfgTotalEasy + leetcodeTotalEasy),
                                    strokeCap: StrokeCap.round,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.tealAccent),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${leetcodeEasy + leetcodeMedium + leetcodeHard + gfgEasy + gfgMedium + gfgHard}',
                                      style: h2Style(),
                                    ),
                                    const Text(
                                      'Solved',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: size * 0.25,
                              child: Column(
                                children: [
                                  DifficultyTile(
                                    size: size,
                                    difficulty: 'Easy',
                                    totalQuestion:
                                        leetcodeTotalEasy + gfgTotalEasy,
                                    solvedQuestion: leetcodeEasy + gfgEasy,
                                    color: Colors.tealAccent,
                                  ),
                                  DifficultyTile(
                                    size: size,
                                    difficulty: 'Medium',
                                    totalQuestion:
                                        leetcodeTotalMedium + gfgTotalMedium,
                                    solvedQuestion: leetcodeMedium + gfgMedium,
                                    color: Colors.amberAccent,
                                  ),
                                  DifficultyTile(
                                    size: size,
                                    difficulty: 'Hard',
                                    totalQuestion:
                                        leetcodeTotalHard + gfgTotalHard,
                                    solvedQuestion: leetcodeHard + gfgHard,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  //========================= Card 1 Right ============================================
                  Expanded(
                    child: Card(
                      child: Container(
                        height: 213,
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Languages Used',
                                style: h2Style(),
                              ),
                              Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                spacing: 5,
                                runSpacing: 5,
                                children: totalLanguages.isEmpty
                                    ? [
                                        const LanguageChip(
                                            text: 'Not Available')
                                      ]
                                    : totalLanguages.map((e) {
                                        return LanguageChip(text: e);
                                      }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // ====================== Heatmap ===================================================
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10),
                        child: CustomHeatMap(dataSet: dataSets),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // ===================== Platform Card 1 ====================================
                  Expanded(
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const PlatformName(
                              name: 'Leetcode',
                              imgUrl:
                                  'https://upload.wikimedia.org/wikipedia/commons/1/19/LeetCode_logo_black.png',
                            ),
                            const SizedBox(height: 20),
                            leetcodeUsername.isEmpty
                                ? SizedBox(
                                    height: 315,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextInputField(
                                          controller:
                                              leetcodeUsernameController,
                                          labelText: 'Username',
                                          icon: FontAwesomeIcons.noteSticky,
                                          width: size,
                                          vertical: 10,
                                          horizontal: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30.0),
                                          child: CustomButton(
                                            title: 'Save Username',
                                            onPressed: () {
                                              saveLeetcodeUsername(
                                                leetcodeUsernameController.text
                                                    .trim(),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : leetcodeData.isEmpty
                                    ? const PlatformLoader()
                                    : PlatformCard(
                                        size: size,
                                        totalQuestions: leetcodeTotalHard +
                                            leetcodeTotalEasy +
                                            leetcodeTotalMedium,
                                        easyQuestionSolved: leetcodeData[1]
                                            ['count'],
                                        mediumQuestionSolved: leetcodeData[2]
                                            ['count'],
                                        hardQuestionSolved: leetcodeData[3]
                                            ['count'],
                                        easyQuestions: leetcodeTotalEasy,
                                        mediumQuestions: leetcodeTotalMedium,
                                        hardQuestions: leetcodeTotalHard,
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // ===================== Platform Card 2 ====================================
                  Expanded(
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const PlatformName(
                              name: 'GeeksForGeek',
                              imgUrl:
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/GeeksforGeeks.svg/1280px-GeeksforGeeks.svg.png',
                            ),
                            const SizedBox(height: 20),
                            gfgUsername.isEmpty
                                ? SizedBox(
                                    height: 315,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextInputField(
                                          controller: gfgUsernameController,
                                          labelText: 'Username',
                                          icon: FontAwesomeIcons.noteSticky,
                                          width: size,
                                          vertical: 10,
                                          horizontal: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30.0),
                                          child: CustomButton(
                                            title: 'Save Username',
                                            onPressed: () {
                                              saveGfgUsername(
                                                gfgUsernameController.text
                                                    .trim(),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : gfgData.isEmpty
                                    ? const PlatformLoader()
                                    : PlatformCard(
                                        size: size,
                                        totalQuestions: gfgTotalHard +
                                            gfgTotalMedium +
                                            gfgTotalEasy,
                                        easyQuestionSolved: gfgData[0] +
                                            gfgData[1] +
                                            gfgData[2],
                                        mediumQuestionSolved: gfgData[3],
                                        hardQuestionSolved: gfgData[4],
                                        easyQuestions: gfgTotalEasy,
                                        mediumQuestions: gfgTotalMedium,
                                        hardQuestions: gfgTotalHard,
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
