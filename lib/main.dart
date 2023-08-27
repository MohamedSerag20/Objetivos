import 'package:flutter/material.dart';
import 'package:my_duties/Screens/home.dart';
import 'package:my_duties/Screens/work.dart';
import 'package:my_duties/Screens/religion.dart';
import 'package:my_duties/Screens/self.dart';
import 'package:my_duties/Screens/final.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int myIndex = 0;
  final List<Widget> screens = const [
    Home(),
    Work(),
    Me_and_Allah(),
    My_Self(),
    Missions_in_Order()
  ];

  @override
  Widget build(BuildContext context) {
    const appName = 'My Duties';

    return MaterialApp(
        title: appName,
        theme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 147, 229, 250),
            brightness: Brightness.dark,
            surface: const Color.fromARGB(255, 130, 140, 148),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
        ),
        home: Scaffold(
          body: IndexedStack(
            index: myIndex,
            children: screens,
          ),
          appBar: AppBar(
              title: Text(screens[myIndex].toString().split('_').join(' '))),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              currentIndex: myIndex,
              onTap: (index) {
                setState(() {
                  myIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.work,
                  ),
                  label: "Work",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.mosque,
                  ),
                  label: "Religion",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: "Self",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.summarize,
                  ),
                  label: "Summary",
                )
              ]),
        ));
  }
}
