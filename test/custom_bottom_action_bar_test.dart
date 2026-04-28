import 'package:arbinex_bottom_bar/arbinex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('supports initial index and external tap callback', (
    tester,
  ) async {
    var selectedIndex = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CustomBottomActionBar(
            initialActiveIndex: 1,
            onTap: (index) => selectedIndex = index,
            centerAction: BottomActionBarCenterItem(
              child: GestureDetector(
                onTap: () => selectedIndex = 99,
                child: const Icon(Icons.add),
              ),
            ),
            items: const [
              BottomActionBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomActionBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomActionBarItem(icon: Icon(Icons.task), label: 'Tasks'),
              BottomActionBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Search')).style?.fontWeight,
      FontWeight.w700,
    );

    await tester.tap(find.text('Tasks'));
    await tester.pump();
    expect(selectedIndex, 2);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(selectedIndex, 99);
  });
}
