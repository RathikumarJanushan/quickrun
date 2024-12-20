import 'package:flutter/material.dart';
import 'package:quickrun/common/color_extension.dart';
import 'package:quickrun/common_widget/round_button.dart';
import 'package:quickrun/view/admin/admin_login_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust UI for large screen sizes
            final isWideScreen = constraints.maxWidth > 600;
            final horizontalPadding = isWideScreen ? 100.0 : 25.0;
            final logoSize = isWideScreen ? 300.0 : constraints.maxWidth * 0.5;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1), // Top spacing
                  Text(
                    "QuickRun",
                    style: TextStyle(
                      fontSize: isWideScreen ? 48 : constraints.maxWidth * 0.15,
                      color: const Color.fromARGB(
                          255, 234, 234, 234), // Adjust for better contrast
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: logoSize,
                      child: Image.asset(
                        "assets/img/quickrun.jpeg", // Replace with your logo image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: constraints.maxHeight * 0.05), // Adjust spacing
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: RoundButton(
                      title: "Admin Login",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminLoginView(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Adjust spacing
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
