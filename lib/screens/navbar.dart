import 'package:codetrackio/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<String> pages = [
  '/home',
  '/leaderboard',
  '/setting',
];

_logout() async {
  final auth = AuthController();
  await auth.logut();
}

void _onItemTapped(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go('/home');
      break;
    case 1:
      context.go('/leaderboard');
      break;
    case 2:
      context.go('/setting');
      break;
  }
}

int _calculateSelectedIndex(BuildContext context) {
  final String location = GoRouterState.of(context).matchedLocation;
  if (location.startsWith('/home')) {
    return 0;
  }
  if (location.startsWith('/leaderboard')) {
    return 1;
  }
  if (location.startsWith('/setting')) {
    return 2;
  }
  return 0;
}

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      scrolledUnderElevation: 0,
      title: const Padding(
        padding: EdgeInsets.only(left: 50),
        child: Row(
          children: [
            Text(
              'Code',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Track',
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        CupertinoButton(
          onPressed: () {
            // onchanged(0);
            context.go('/home');
          },
          child: Text('Home'),
        ),
        CupertinoButton(
          onPressed: () {
            // onchanged(2);
            context.go('/leaderboard');
          },
          child: Text('Leaderboard'),
        ),
        CupertinoButton(
          onPressed: () {
            // onchanged(3);
            context.go('/setting');
          },
          child: Text('Settings'),
        ),
        ElevatedButton(
          onPressed: () {
            _logout();
            context.go('/');
          },
          child: Text('Logout'),
        ),
        const Padding(padding: EdgeInsets.only(right: 50))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    int _currentIndex = _calculateSelectedIndex(context);
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        _onItemTapped(context, index);
      },
      type: BottomNavigationBarType.shifting,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      backgroundColor: Colors.grey.shade800,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
