import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/screens/optimized_home_screen.dart';
import '../../inside/screens/inside_screen.dart';
import '../../outside/screens/outside_screen.dart';
import '../../profile/screens/profile_screen.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _indicatorController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _indicatorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _indicatorController, curve: Curves.elasticOut),
    );
    _indicatorController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);
    
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          OptimizedHomeScreen(), // Using optimized HomeScreen with performance improvements
          InsideScreen(),
          OutsideScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(currentIndexProvider.notifier).state = index;
          _animationController.forward().then((_) {
            _animationController.reverse();
          });
        },
        scaleAnimation: _scaleAnimation,
        indicatorAnimation: _indicatorAnimation,
      ),
    );
  }
}

class _CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Animation<double> scaleAnimation;
  final Animation<double> indicatorAnimation;

  const _CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.scaleAnimation,
    required this.indicatorAnimation,
  });

  @override
  State<_CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<_CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _indicatorPositionController;
  late Animation<double> _indicatorPositionAnimation;

  @override
  void initState() {
    super.initState();
    _indicatorPositionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _indicatorPositionAnimation = Tween<double>(
      begin: widget.currentIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(CurvedAnimation(
      parent: _indicatorPositionController,
      curve: Curves.decelerate, 
    ));
  }

  @override
  void didUpdateWidget(_CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _indicatorPositionAnimation = Tween<double>(
        begin: oldWidget.currentIndex.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(
        parent: _indicatorPositionController,
        curve: Curves.decelerate,
      ));
      _indicatorPositionController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _indicatorPositionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Water drop indicator
          AnimatedBuilder(
            animation: Listenable.merge([
              _indicatorPositionAnimation,
              widget.indicatorAnimation,
            ]),
            builder: (context, child) {
              final screenWidth = MediaQuery.of(context).size.width;
              final itemWidth = screenWidth / 4;
              final indicatorWidth = 60.0;
              final leftPosition = (_indicatorPositionAnimation.value * itemWidth) +
                  (itemWidth - indicatorWidth) / 2;

              return Positioned(
                top: 0,
                left: leftPosition,
                child: Transform.scale(
                  scale: widget.indicatorAnimation.value,
                  child: Container(
                    width: indicatorWidth,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.8),
                          AppTheme.primaryColor,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Navigation items
          Row(
            children: [
              _buildNavItem(0, 'assets/svgs/home.svg', 'Home', isIcon: false),
              _buildNavItem(1, Icons.home_work_outlined, 'Inside', isIcon: true),
              _buildNavItem(2, Icons.landscape_outlined, 'Outside', isIcon: true),
              _buildNavItem(3, 'assets/svgs/profile.svg', 'Profile', isIcon: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, dynamic icon, String label, {required bool isIcon}) {
    final isSelected = widget.currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: widget.scaleAnimation,
          builder: (context, child) {
            return SizedBox(
              height: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  // Icon with scale animation
                  Transform.scale(
                    scale: isSelected ? widget.scaleAnimation.value : 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primaryColor.withOpacity(0.1) 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isIcon
                          ? AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                icon as IconData,
                                key: ValueKey('$index-$isSelected'),
                                size: 26,
                                color: isSelected 
                                    ? AppTheme.primaryColor 
                                    : Colors.grey[400],
                              ),
                            )
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: SvgPicture.asset(
                                icon as String,
                                key: ValueKey('$index-$isSelected'),
                                height: 26,
                                colorFilter: ColorFilter.mode(
                                  isSelected 
                                      ? AppTheme.primaryColor 
                                      : Colors.grey[400]!,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Label with smooth color transition
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: isSelected ? 12 : 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected 
                          ? AppTheme.primaryColor 
                          : Colors.grey[500],
                      fontFamily: 'Okra',
                    ),
                    child: Text(label),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} 