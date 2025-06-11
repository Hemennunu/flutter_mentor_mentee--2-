import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  final List<String> images = [
    'assets/images/mento_mentee_picture.jpg',
    'assets/images/img_2.png',
    'assets/images/img.png',
  ];
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  // void navigateTo(String routeName) {
  //   Navigator.pushNamed(context, routeName);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Title
              const Text(
                'Welcome to Mentor Mentee',
                style: TextStyle(
                  color: Color(0xFF3F2C2C),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Image Pager
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      images[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                    );
                  },
                ),
              ),

              // Indicator
              SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Color(0xFF3F2C2C),
                  dotColor: Colors.grey.shade300,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),

              // Description
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Building meaningful mentorships to help you grow professionally.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3F2C2C),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('navigateToSignup'),
                      onPressed: () => context.push('/signup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F2C2C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('navigateToLogin'),
                      onPressed: () => context.push('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF0F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Login', style: TextStyle(color: Color(0xFF3F2C2C))),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
