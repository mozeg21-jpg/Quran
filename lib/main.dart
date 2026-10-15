import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import 'pages/home_page.dart';
import 'pages/quran_page.dart';
import 'pages/player_page.dart';
import 'pages/adhkar_page.dart';
import 'pages/settings_page.dart';
import 'services/audio_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = StorageService();
  await storageService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => storageService),
        ChangeNotifierProvider(create: (_) => AudioService()),
      ],
      child: const HolyQuranApp(),
    ),
  );
}

class HolyQuranApp extends StatelessWidget {
  const HolyQuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    
    return CupertinoApp(
      title: 'القرآن الكريم',
      debugShowCheckedModeBanner: false,
      theme: storage.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', 'SA')],
      locale: const Locale('ar', 'SA'),
      home: const MainTabNavigator(),
    );
  }
}

class MainTabNavigator extends StatelessWidget {
  const MainTabNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: AppTheme.activeGreen,
        inactiveColor: CupertinoColors.systemGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'المصحف',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.play_circle),
            label: 'التلاوات',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'الأذكار',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'المزيد',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const HomePage();
          case 1:
            return const QuranPage();
          case 2:
            return const PlayerPage();
          case 3:
            return const AdhkarPage();
          case 4:
            return const SettingsPage();
          default:
            return const HomePage();
        }
      },
    );
  }
}
