import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view/auth/sendotp.dart';

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
      backgroundColor: Colors.white,
      // backgroundColor: Colors.white,
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
                imagePath: 'assets/images/unsplash_tHkJAMcO3QE (1).png',
                title: local.page1Title,
                description: local.page1Description,
              ),
              OnboardingPage(
                imagePath: 'assets/images/unsplash_V5OEpF12pzw (1).png',
                title: local.page2Title,
                description: local.page2Description,
              ),
              OnboardingPage(
                imagePath: 'assets/images/unsplash_V5OEpF12pzw (3).png',
                title: local.page3Title,
                description: local.page3Description,
              ),
              OnboardingPage(
                imagePath: "assets/images/onborading4.png",
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SendOtp()));
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
    return Stack(
      children: [
        // First Container for the Image
        ClipPath(
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.65, // Adjust this as needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.fill, // Fit the image properly in the space
              ),
            ),
          ),
        ),
        // Second Container for Title and Description
        Positioned(
          bottom: 50, // Position it at the bottom
          left: 0,
          right: 0,
          child: ClipPath(
            // Optional: You can use a different clipper if desired
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(120)),
                // border: Border.all(
                //     color: Colors.black, width: 1), // Add border here
              ),
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height *
                  0.40, // Adjusted height for the t   ext container
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
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
        ),
      ],
    );
  }
}
