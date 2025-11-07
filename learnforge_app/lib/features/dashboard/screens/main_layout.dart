import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navigationItems = [
    {
      'icon': Icons.home,
      'label': 'Home',
      'route': '/dashboard',
      'color': AppColors.neonPurple,
    },
    {
      'icon': Icons.book,
      'label': 'Courses',
      'route': '/courses',
      'color': AppColors.neonCyan,
    },
    {
      'icon': Icons.score,
      'label': 'Arena',
      'route': '/arena',
      'color': AppColors.neonPink,
    },
    {
      'icon': Icons.chat,
      'label': 'Chat',
      'route': '/chat',
      'color': AppColors.neonBlue,
    },
    {
      'icon': Icons.person,
      'label': 'Profile',
      'route': '/profile',
      'color': AppColors.neonPurple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.dark800.withOpacity(0.9),
              AppColors.dark900.withOpacity(0.9),
            ],
          ),
          border: Border(
            top: BorderSide(color: AppColors.neonPurple.withOpacity(0.3)),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPurple.withOpacity(0.3),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: const ColorFilter.mode(
              Colors.transparent,
              BlendMode.srcOver,
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() => _selectedIndex = index);
                context.go(_navigationItems[index]['route']);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.neonPurple,
              unselectedItemColor: AppColors.grey400,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
              ),
              items: _navigationItems
                  .asMap()
                  .entries
                  .map(
                    (entry) => BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedIndex == entry.key
                                  ? entry.value['color'].withOpacity(0.15)
                                  : Colors.transparent,
                              border: _selectedIndex == entry.key
                                  ? Border.all(
                                      color: entry.value['color'].withOpacity(
                                        0.6,
                                      ),
                                      width: 2,
                                    )
                                  : null,
                              boxShadow: _selectedIndex == entry.key
                                  ? [
                                      BoxShadow(
                                        color: entry.value['color'].withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              entry.value['icon'],
                              size: 22,
                              color: _selectedIndex == entry.key
                                  ? entry.value['color']
                                  : AppColors.grey400,
                            ),
                          ),
                          if (_selectedIndex == entry.key)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: entry.value['color'],
                                  boxShadow: [
                                    BoxShadow(
                                      color: entry.value['color'],
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      label: entry.value['label'],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
