import 'package:dropbox_colors/dropbox_color.dart';
import 'package:dropbox_colors/dropbox_colors_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Builder(
          builder: (context) {
            final screenWidth = MediaQuery.widthOf(context);

            if (screenWidth < 990) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Minimal required screen width for this demo is 990px.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 24 / 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: DropboxColors.graphite.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return const DropboxColorsPage();
          },
        ),
      ),
    );
  }
}
