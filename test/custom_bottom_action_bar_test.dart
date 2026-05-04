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
      FontWeight.w600,
    );

    await tester.tap(find.text('Tasks'));
    await tester.pump();
    expect(selectedIndex, 2);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(selectedIndex, 99);
  });

  testWidgets('supports multiline labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: ArbinexBottomBar(
            items: const [
              BottomActionBarItem(
                icon: Icon(Icons.home),
                label: 'Ana Sehife',
                labelMaxLines: 2,
                labelSoftWrap: true,
                labelOverflow: TextOverflow.visible,
              ),
              BottomActionBarItem(icon: Icon(Icons.task), label: 'Tapsiriqlar'),
            ],
          ),
        ),
      ),
    );

    final label = tester.widget<Text>(find.text('Ana Sehife'));
    expect(label.maxLines, 2);
    expect(label.softWrap, isTrue);
    expect(label.overflow, TextOverflow.visible);
  });

  testWidgets('supports item padding overrides and center gap', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: ArbinexBottomBar(
            minimumBottomInset: 12,
            itemTopPadding: 4,
            itemBottomPadding: 14,
            centerAction: const BottomActionBarCenterItem(
              centerActionGap: 6,
              child: Icon(Icons.fingerprint),
            ),
            items: const [
              BottomActionBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomActionBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            ],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.fingerprint), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('expands height for lifted center action hit area', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: ArbinexBottomBar(
            centerAction: const BottomActionBarCenterItem(
              top: -20,
              centerActionGap: 12,
              child: Icon(Icons.fingerprint),
            ),
            items: const [
              BottomActionBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomActionBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            ],
          ),
        ),
      ),
    );

    final sizedBox = tester.widgetList<SizedBox>(find.byType(SizedBox)).first;
    expect(sizedBox.height, 89);
    final fingerprintRect = tester.getRect(find.byIcon(Icons.fingerprint).first);
    expect(fingerprintRect.top, greaterThanOrEqualTo(0));
  });

  testWidgets('uses automatic height when height is not provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: ArbinexBottomBar(
            itemTopPadding: 6,
            itemBottomPadding: 12,
            itemSpacing: 4,
            items: const [
              BottomActionBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                iconSize: 30,
                labelMaxLines: 2,
                labelSoftWrap: true,
                activeLabelStyle: TextStyle(fontSize: 12, height: 1.2),
              ),
              BottomActionBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            ],
          ),
        ),
      ),
    );

    final sizedBox = tester.widgetList<SizedBox>(find.byType(SizedBox)).first;
    expect(sizedBox.height, 80.8);
  });

  testWidgets('uses explicit height when provided', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: ArbinexBottomBar(
            height: 90,
            items: const [
              BottomActionBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomActionBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            ],
          ),
        ),
      ),
    );

    final sizedBox = tester.widgetList<SizedBox>(find.byType(SizedBox)).first;
    expect(sizedBox.height, 90);
  });

  testWidgets('supports configurable top border width', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: ArbinexBottomBar(
            showTopBorder: true,
            topBorderColor: Colors.red,
            topBorderWidth: 2,
            items: const [
              BottomActionBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomActionBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(CustomPaint), findsWidgets);
  });
}
