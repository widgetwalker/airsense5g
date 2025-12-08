import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_quality_guardian/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:air_quality_guardian/presentation/screens/forecast/forecast_screen.dart';
import 'package:air_quality_guardian/presentation/screens/chat/chat_screen.dart';
import 'package:air_quality_guardian/presentation/screens/profile/profile_screen.dart';
import 'package:air_quality_guardian/presentation/providers/dashboard_provider.dart';
import 'package:air_quality_guardian/presentation/widgets/animated_bottom_nav_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ChangeNotifierProvider(
        create: (_) => DashboardProvider()..fetchDashboardData(),
        child: const DashboardScreen(),
      ),
      const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Map View', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Coming Soon', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      const ForecastScreen(),
      const ChatScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AnimatedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Dashboard',
          ),
          BottomNavItem(
            icon: Icons.map_outlined,
            activeIcon: Icons.map,
            label: 'Map',
          ),
          BottomNavItem(
            icon: Icons.trending_up_outlined,
            activeIcon: Icons.trending_up,
            label: 'Forecast',
          ),
          BottomNavItem(
            icon: Icons.chat_outlined,
            activeIcon: Icons.chat,
            label: 'Chat',
          ),
          BottomNavItem(
            icon: Icons.person_outlined,
            activeIcon: Icons.person,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
