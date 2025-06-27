import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/screens/home_screen.dart';
import '../../inside/screens/inside_screen.dart';
import '../../outside/screens/outside_screen.dart';
import '../../profile/screens/profile_screen.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    
    final screens = [
      const HomeScreen(),
      const InsideScreen(),
      const OutsideScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(currentIndexProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/home.svg',
                height: 24,
                colorFilter: ColorFilter.mode(
                  currentIndex == 0 ? AppTheme.primaryColor : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_work_outlined,
                color: currentIndex == 1 ? AppTheme.primaryColor : Colors.grey,
              ),
              label: 'Inside',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.landscape_outlined,
                color: currentIndex == 2 ? AppTheme.primaryColor : Colors.grey,
              ),
              label: 'Outside',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/profile.svg',
                height: 24,
                colorFilter: ColorFilter.mode(
                  currentIndex == 3 ? AppTheme.primaryColor : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
} 