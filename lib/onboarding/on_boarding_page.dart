import 'package:flutter/material.dart';
import 'package:road_safty_cm/app_colors.dart';
import 'package:road_safty_cm/screens/home_screen.dart';

import '../widgets/custom_button.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            SizedBox(
              height: 500,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return onBoardingContent(
                      illustration: onboardingData[index]['illustration'],
                      title: onboardingData[index]['title'],
                      text: onboardingData[index]['text']);
                },
              ),
            ),
            const Spacer(),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: AnimatedDot(
                      isActive: _selectedIndex == index,
                    ),
                  ),
                )),
            const Spacer(
              flex: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: buttonBuilder(
                text: "Get Started",
                background: RColors.buttonColor,
                textColor: Colors.white,
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class AnimatedDot extends StatelessWidget {
  const AnimatedDot({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
          color: isActive
              ? RColors.buttonColor
              : RColors.primary.withOpacity(0.25),
          borderRadius: const BorderRadius.all(Radius.circular(22))),
    );
  }
}

class onBoardingContent extends StatelessWidget {
  const onBoardingContent({
    super.key,
    required this.illustration,
    required this.title,
    required this.text,
  });

  final String illustration, title, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image(
              image: AssetImage(illustration),
              fit: BoxFit.cover,
              width: 400,
              height: 400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                text,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );
  }
}

List<Map<String, dynamic>> onboardingData = [
  {
    "illustration": "assets/images/onboard1.png",
    "title": "Report the Unseen",
    "text":
        "Help others stay safe by reporting road blockages, incidents, and hazards in real-time."
  },
  {
    "illustration": "assets/images/onboard2.png",
    "title": "Your Eyes on the Road",
    "text":
        "Contribute to a safer journey by reporting accidents and obstacles that could cause danger."
  },
  {
    "illustration": "assets/images/onboard3.png",
    "title": "Together We Make Roads Safer",
    "text":
        "Be part of a community dedicated to keeping the roads clear and safe for everyone."
  }
];
