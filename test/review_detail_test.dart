import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivjuuu/features/profile/view/review_detail_page.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: ReviewDetailPage(),
    );
  }

  group('ReviewDetailPage Tests', () {
    testWidgets('renders all review details matching review-detail.html and reference image', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Top Bar
      expect(find.text('Review'), findsOneWidget);

      // Restaurant context card
      expect(find.text('Trattoria Nonna Rosa'), findsOneWidget);
      expect(find.text('Italian · 1.2 km'), findsOneWidget);

      // Reviewer header
      expect(find.text('AK'), findsOneWidget);
      expect(find.text('Anna Kovács'), findsOneWidget);
      expect(find.text('8 Oct 2026 · '), findsOneWidget);
      expect(find.text('Visited with coupon'), findsOneWidget);
      expect(find.text('8.9'), findsOneWidget);

      // Review body text
      expect(
        find.text(
          "Best cacio e pepe I've had outside Rome. The staff scanned my coupon in seconds and the courtyard is lovely in the evening. The tiramisu was perfect, not too sweet. We'll be back for the truffle week.",
        ),
        findsOneWidget,
      );

      // 3 Images in grid (1 wide + 2 side-by-side)
      expect(find.byType(Image), findsNWidgets(4)); // 1 restaurant thumb + 3 review photos
    });

    testWidgets('more options button opens bottom sheet with share and report', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find more options (last gesture detector in top bar)
      final moreButton = find.byWidgetPredicate((widget) {
        return widget is Icon && widget.icon?.codePoint != null;
      }).at(1); // ellipsis icon

      await tester.tap(moreButton);
      await tester.pumpAndSettle();

      expect(find.text('Share review'), findsOneWidget);
      expect(find.text('Report review'), findsOneWidget);
    });
  });
}

