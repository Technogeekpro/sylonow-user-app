import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Theater section widget with sliding image animation
class TheaterSection extends StatefulWidget {
  const TheaterSection({super.key});

  @override
  State<TheaterSection> createState() => _TheaterSectionState();
}

class _TheaterSectionState extends State<TheaterSection>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  int currentIndex = 0;

  // Sample theater cover images
  final List<String> theaterImages = [
    'https://images.unsplash.com/photo-1489185078074-0d83576b4d1c?w=400&q=80',
    'https://images.unsplash.com/photo-1574267432553-4b4628081c31?w=400&q=80',
    'https://images.unsplash.com/photo-1603190287605-e6ade32fa852?w=400&q=80',
    'https://images.unsplash.com/photo-1596727147705-61a532a659bd?w=400&q=80',
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    startAutoSlide();
    animationController.forward();
  }

  void startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        animationController.reverse().then((_) {
          if (mounted) {
            setState(() {
              currentIndex = (currentIndex + 1) % theaterImages.length;
            });
            animationController.forward();
            startAutoSlide();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          context.push('/theater/date-selection');
        },
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            child: Stack(
              children: [
                // Background image with fade animation
                FadeTransition(
                  opacity: fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(theaterImages[currentIndex]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Content overlay
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Private Theater',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Book your private theater experience',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
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