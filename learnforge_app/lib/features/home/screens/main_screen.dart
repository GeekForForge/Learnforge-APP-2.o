import 'package:flutter/material.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'package:learnforge_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:learnforge_app/features/courses/screens/courses_screen.dart';
import 'package:learnforge_app/features/arena/screens/arena_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CoursesScreen(),
    const ArenaScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.dark900,
          border: Border(
            top: BorderSide(
              color: AppColors.neonBlue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonBlue.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: AppColors.neonBlue.withValues(alpha: 0.2),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: AppColors.neonBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Orbitron',
                );
              }
              return TextStyle(
                color: AppColors.grey400,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: AppColors.neonBlue, size: 26);
              }
              return IconThemeData(color: AppColors.grey400, size: 24);
            }),
          ),
          child: NavigationBar(
            height: 70,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTap,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school_rounded),
                label: 'Courses',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events_rounded),
                label: 'Arena',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
