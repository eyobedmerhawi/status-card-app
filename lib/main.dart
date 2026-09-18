import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const RunMyApp());
}

// SPECIAL FEATURE 3:
// Custom ThemeExtension for our status-card colors.
@immutable
class StatusCardTheme extends ThemeExtension<StatusCardTheme> {
  final Color statusColor;
  final Color avatarColor;

  const StatusCardTheme({
    required this.statusColor,
    required this.avatarColor,
  });

  @override
  StatusCardTheme copyWith({
    Color? statusColor,
    Color? avatarColor,
  }) {
    return StatusCardTheme(
      statusColor: statusColor ?? this.statusColor,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }

  @override
  StatusCardTheme lerp(
    covariant ThemeExtension<StatusCardTheme>? other,
    double t,
  ) {
    if (other is! StatusCardTheme) {
      return this;
    }

    return StatusCardTheme(
      statusColor: Color.lerp(statusColor, other.statusColor, t)!,
      avatarColor: Color.lerp(avatarColor, other.avatarColor, t)!,
    );
  }
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // SPECIAL FEATURE 2:
  // Load the saved theme when the app starts.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;

    if (!mounted) return;

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Change the theme and remember the user's choice.
  Future<void> changeTheme(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'isDarkMode',
      themeMode == ThemeMode.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    // SPECIAL FEATURE 1:
    // Material 3 themes created with custom seed ColorSchemes.
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey[200],
      extensions: const [
        StatusCardTheme(
          statusColor: Colors.amber,
          avatarColor: Colors.blueGrey,
        ),
      ],
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
      extensions: const [
        StatusCardTheme(
          statusColor: Colors.teal,
          avatarColor: Colors.teal,
        ),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Status Card Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,

      // SPECIAL FEATURE 4 is handled by the AnimatedTheme
      // surrounding the screen below.
      home: Builder(
        builder: (context) {
          final isDark =
              Theme.of(context).brightness == Brightness.dark;

          final statusTheme =
              Theme.of(context).extension<StatusCardTheme>()!;

          return AnimatedTheme(
            data: Theme.of(context),
            duration: const Duration(milliseconds: 400),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Status Card Demo'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: statusTheme.avatarColor,
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

                    // PART 2:
                    // AnimatedContainer with 400ms transition.
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 220,
                      height: 64,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: statusTheme.statusColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // PART 2:
                          // Icon changes based on theme.
                          Icon(
                            isDark
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 18,
                            color: Colors.black87,
                          ),

                          const SizedBox(width: 8),

                          const Text(
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
                          onPressed: () =>
                              changeTheme(ThemeMode.light),
                          child: const Text('Light Theme'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              changeTheme(ThemeMode.dark),
                          child: const Text('Dark Theme'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}