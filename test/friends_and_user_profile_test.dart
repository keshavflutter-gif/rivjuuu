import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/routes/app_router.dart';
import 'package:rivjuuu/features/profile/view/friends_page.dart';
import 'package:rivjuuu/features/profile/view/user_profile_page.dart';

void main() {
  testWidgets('FriendsPage renders matching friends.html and reference image with tabbar',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: FriendsPage(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Top Bar
    expect(find.text('Friends'), findsWidgets);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(LucideIcons.search), findsOneWidget);

    // 2. Tab Bar: Friends · 32 & Requests · 2
    expect(find.text('Friends · 32'), findsOneWidget);
    expect(find.text('Requests · 2'), findsOneWidget);

    // 3. Friends List
    expect(find.text('Anna Kovács'), findsOneWidget);
    expect(find.text('Last visit · Trattoria Nonna Rosa'), findsOneWidget);
    expect(find.text('Bence Tóth'), findsOneWidget);
    expect(find.text('Last visit · Kōya Sushi & Ramen'), findsOneWidget);
    expect(find.text('Zsófia Balogh'), findsOneWidget);
    expect(find.text('Last visit · Café Mókus'), findsOneWidget);
    expect(find.text('Dávid Molnár'), findsOneWidget);
    expect(find.text('Activity is private'), findsOneWidget);
    expect(find.text('Lilla Kiss'), findsOneWidget);
    expect(find.text('Last visit · Bamba Burger Bar'), findsOneWidget);

    // 4. Switch to Requests Tab
    await tester.tap(find.text('Requests · 2'));
    await tester.pumpAndSettle();

    expect(find.text('RECEIVED'), findsOneWidget);
    expect(find.text('Péter Nagy'), findsOneWidget);
    expect(find.text('4 mutual friends'), findsOneWidget);
    expect(find.text('Eszter Farkas'), findsOneWidget);
    expect(find.text('1 mutual friend'), findsOneWidget);
    expect(find.text('SENT'), findsOneWidget);
    expect(find.text('Anna Szabó'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
  });

  testWidgets('UserProfilePage renders matching user-profile.html and handles options',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: UserProfilePage(
          name: 'Bence Tóth',
          initials: 'BT',
          subtitle: 'Food lover · Joined Mar 2026',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Profile details
    expect(find.text('BT'), findsOneWidget);
    expect(find.text('Bence Tóth'), findsOneWidget);
    expect(find.text('Food lover · Joined Mar 2026'), findsOneWidget);

    // 2. Stats
    expect(find.text('14'), findsOneWidget);
    expect(find.text('Visits'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('Reviews'), findsNWidgets(2));
    expect(find.text('32'), findsOneWidget);
    expect(find.text('Friends'), findsWidgets);

    // 3. Add friend button
    expect(find.text('Add friend'), findsOneWidget);

    // 4. Latest visit
    expect(find.text('Latest visit'), findsOneWidget);
    expect(find.text('Kōya Sushi & Ramen'), findsOneWidget);
    expect(find.text('Visited 5 Oct 2026'), findsOneWidget);
    expect(find.text('9.6'), findsOneWidget);

    // 5. Reviews
    expect(find.text('Bamba Burger Bar'), findsOneWidget);
    expect(find.text('2 Oct 2026'), findsOneWidget);
    expect(find.text('8.4'), findsOneWidget);
    expect(
      find.text('Juicy smash burgers and the 1+1 deal on weekdays is great value.'),
      findsOneWidget,
    );

    // 6. Private activity note
    expect(
      find.text('Some of Bence’s activity is only visible to friends.'),
      findsOneWidget,
    );

    // 7. More Options Sheet (user-profile-actions.html)
    await tester.tap(find.byIcon(Icons.more_horiz_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Report user'), findsOneWidget);
    expect(find.text('Block Bence'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Tap cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Report user'), findsNothing);
  });
}
