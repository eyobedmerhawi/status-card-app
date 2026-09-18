import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Status Card Demo',

      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      darkTheme: ThemeData.dark(),

      themeMode: _themeMode,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Status Card Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.teal
                        : Colors.blueGrey,
                child: const Icon(
                  Icons.person,
                  size: 42,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Flutter Theme Lab',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: 220,
                height: 64,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.teal
                      : Colors.amber,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Status: Online',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Choose the Theme:',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => changeTheme(ThemeMode.light),
                    child: const Text('Light Theme'),
                  ),
                  ElevatedButton(
                    onPressed: () => changeTheme(ThemeMode.dark),
                    child: const Text('Dark Theme'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}