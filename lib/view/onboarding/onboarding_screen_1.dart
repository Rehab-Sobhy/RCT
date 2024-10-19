import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = "OnboardingScreen";

  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              OnboardingPage(
                imagePath: '$imagePath/onboarding-1.png',
                title: local.page1Title,
                description: local.page1Description,
              ),
              OnboardingPage(
                imagePath: '$imagePath/onboarding-2.png',
                title: local.page2Title,
                description: local.page2Description,
              ),
              OnboardingPage(
                imagePath: '$imagePath/onboarding-1.png',
                title: local.page3Title,
                description: local.page3Description,
              ),
              OnboardingPage(
                imagePath: 'assets/images/Group 469314.png',
                title: local.page4Title,
                description: local.page4Description,
              ),
            ],
          ),
          Positioned(
            bottom: 10.h,
            left: 10.w,
            right: 10.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Skip button action
                    _pageController.jumpToPage(3);
                  },
                  child: Text(
                    local.skip,
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                Row(
                  children: List.generate(
                    4,
                    (index) => buildDot(index, context),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Next or Done button action
                    if (_currentPage == 3) {
                      // Navigate to the main app or home screen
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == 3 ? local.done : local.next,
                    selectionColor: primaryColor,
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: _currentPage == index ? 10 : 6,
      height: _currentPage == index ? 10 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.black : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * .6,
      // width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipPath(
            clipper: SinCosineWaveClipper(
              horizontalPosition: HorizontalPosition.right,
              verticalPosition: VerticalPosition.top,
            ),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height *
                  .35, // Fixed height for the text container
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
