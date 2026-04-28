import 'package:arbinex_bottom_bar/arbinex_bottom_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F4F6),
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  int currentIndex = 2;

  BottomActionBarItem homePage() {
    return const BottomActionBarItem(
      icon: Icon(Icons.home_rounded),
      label: 'Ana Səhifə',
      activeLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      inactiveLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Color(0xFF8A8A8A),
      ),
    );
  }

  BottomActionBarItem projectsPage() {
    return const BottomActionBarItem(
      icon: Icon(Icons.dashboard_customize_outlined),
      label: 'Layihələr',
      activeLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      inactiveLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Color(0xFF8A8A8A),
      ),
    );
  }

  BottomActionBarItem tasksPage() {
    return const BottomActionBarItem(
      icon: Icon(Icons.list_alt_rounded),
      label: 'Tapşırıqlar',
      activeLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      inactiveLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Color(0xFF8A8A8A),
      ),
    );
  }

  BottomActionBarItem accountPage() {
    return const BottomActionBarItem(
      icon: Icon(Icons.person_outline_rounded),
      label: 'Profilim',
      activeLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      inactiveLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Color(0xFF8A8A8A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 160),
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, index) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ana səhifənin tamamlanması',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE6BE),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'Davam edir',
                        style: TextStyle(
                          color: Color(0xFFFF9800),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '2 gün 1 saat',
                      style: TextStyle(
                        color: Color(0xFF7B7B7B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 84,
                height: 84,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: CircularProgressIndicator(
                        value: .25,
                        strokeWidth: 7,
                        backgroundColor: const Color(0xFFF1F1F1),
                        color: const Color(0xFFFFB23F),
                      ),
                    ),
                    const Text(
                      '25%',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ArbinexBottomBar(
        backgroundColor: const Color(0xFF262626),
        currentIndex: currentIndex,
        initialActiveIndex: 2,
        height: 76,
        horizontalPadding: 10,
        notchMargin: 8,
        notchDepth: 24,
        itemVerticalPadding: const EdgeInsets.fromLTRB(6, 6, 6, 12),
        activeColor: Colors.white,
        inactiveColor: const Color(0xFF8A8A8A),
        shadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 28,
            offset: Offset(0, -8),
          ),
        ],
        centerAction: BottomActionBarCenterItem(
          top: -18,
          size: 88,
          backgroundColor: const Color(0xFF6460F1),
          borderColor: Colors.white,
          borderWidth: 6,
          semanticLabel: 'Biometric action',
          boxShadow: const [
            BoxShadow(
              color: Color(0x2A5E63F2),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showMessage('Center action clicked'),
            child: const Icon(Icons.fingerprint, color: Colors.white, size: 42),
          ),
        ),
        items: [homePage(), projectsPage(), tasksPage(), accountPage()],
        onTap: (int index) {
          if (index == 2) {
            _showMessage('Tapşırıqlar');
          }
          setState(() => currentIndex = index);
        },
      ),
    );
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
}
