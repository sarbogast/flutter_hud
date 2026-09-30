import 'package:flutter/material.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Default Popup HUD', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Text('This is body'),
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                final popup = PopupHUD(context);
                await popup.show();
              },
              child: const Icon(Icons.refresh),
            );
          }),
        ),
      ),
    );

    final bodyFinder = find.text('This is body');
    expect(bodyFinder, findsOneWidget);

    final fabFinder = find.byIcon(Icons.refresh);
    await tester.tap(fabFinder);
    await tester.pump();

    final progressFinder = find.byType(CircularProgressIndicator);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Popup HUD indicator only', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Text('This is body'),
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                final popup = PopupHUD(
                  context,
                  hud: HUD(
                    progressIndicator: const CircularProgressIndicator(),
                  ),
                );
                await popup.show();
              },
              child: const Icon(Icons.refresh),
            );
          }),
        ),
      ),
    );

    final bodyFinder = find.text('This is body');
    expect(bodyFinder, findsOneWidget);

    final fabFinder = find.byIcon(Icons.refresh);
    await tester.tap(fabFinder);
    await tester.pump();

    final progressFinder = find.byType(CircularProgressIndicator);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Popup HUD with label', (WidgetTester tester) async {
    late PopupHUD popup;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Text('This is body'),
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                popup = PopupHUD(
                  context,
                  hud: HUD(
                    progressIndicator: const CircularProgressIndicator(),
                    label: 'Loading..',
                  ),
                );
                await popup.show();
              },
              child: const Icon(Icons.refresh),
            );
          }),
        ),
      ),
    );

    final bodyFinder = find.text('This is body');
    expect(bodyFinder, findsOneWidget);

    final fabFinder = find.byIcon(Icons.refresh);
    await tester.tap(fabFinder);
    await tester.pump();

    final progressFinder = find.byType(CircularProgressIndicator);
    final labelFinder = find.text('Loading..');
    expect(progressFinder, findsOneWidget);
    expect(labelFinder, findsOneWidget);

    expect(popup.label, 'Loading..');
    popup.setLabel('Done');
    await tester.pump();
    expect(popup.label, 'Done');
  });

  testWidgets('Popup HUD with label and detail', (WidgetTester tester) async {
    late PopupHUD popup;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Text('This is body'),
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                popup = PopupHUD(
                  context,
                  hud: HUD(
                    progressIndicator: const CircularProgressIndicator(),
                    label: 'Loading..',
                    detailLabel: 'Please wait',
                  ),
                );
                await popup.show();
              },
              child: const Icon(Icons.refresh),
            );
          }),
        ),
      ),
    );

    final bodyFinder = find.text('This is body');
    expect(bodyFinder, findsOneWidget);

    final fabFinder = find.byIcon(Icons.refresh);
    await tester.tap(fabFinder);
    await tester.pump();

    var progressFinder = find.byType(CircularProgressIndicator);
    var labelFinder = find.text('Loading..');
    var detailFinder = find.text('Please wait');
    expect(progressFinder, findsOneWidget);
    expect(labelFinder, findsOneWidget);
    expect(detailFinder, findsOneWidget);

    expect(popup.detailLabel, 'Please wait');
    popup.setDetailLabel('OK');
    await tester.pump();
    expect(popup.detailLabel, 'OK');

    popup.dismiss();
    await tester.pump();

    progressFinder = find.byType(CircularProgressIndicator);
    labelFinder = find.text('Loading..');
    detailFinder = find.text('OK');
    expect(progressFinder, findsNothing);
    expect(labelFinder, findsNothing);
    expect(detailFinder, findsNothing);
  });

  testWidgets('Popup HUD cancelable', (WidgetTester tester) async {
    var canceled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Text('This is body'),
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                final popup = PopupHUD(
                  context,
                  hud: HUD(
                    progressIndicator: const CircularProgressIndicator(),
                  ),
                  onCancel: () {
                    canceled = true;
                  },
                );
                await popup.show();
              },
              child: const Icon(Icons.refresh),
            );
          }),
        ),
      ),
    );

    final bodyFinder = find.text('This is body');
    expect(bodyFinder, findsOneWidget);

    final fabFinder = find.byIcon(Icons.refresh);
    await tester.tap(fabFinder);
    await tester.pump();

    final progressFinder = find.byType(CircularProgressIndicator);
    expect(progressFinder, findsOneWidget);

    final cancelButtonFinder = find.text('Cancel');
    expect(cancelButtonFinder, findsOneWidget);
    expect(canceled, isFalse);

    await tester.tap(cancelButtonFinder);
    await tester.pump();

    expect(canceled, isTrue);
  });

  testWidgets('Popup HUD progress', (WidgetTester tester) async {
    late PopupHUD popup;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Text('This is body'),
          floatingActionButton: Builder(builder: (context) {
            popup = PopupHUD(
              context,
              hud: HUD(
                progressIndicator: const CircularProgressIndicator(),
              ),
            );
            return FloatingActionButton(
              onPressed: () async {
                await popup.show();
              },
              child: const Icon(Icons.exposure_plus_1),
            );
          }),
        ),
      ),
    );

    final bodyFinder = find.text('This is body');
    expect(bodyFinder, findsOneWidget);

    final fab1Finder = find.byIcon(Icons.exposure_plus_1);
    await tester.tap(fab1Finder);
    await tester.pump();

    final progressFinder = find.byType(CircularProgressIndicator);
    expect(progressFinder, findsOneWidget);
    expect(popup.value, isNull);

    popup.setValue(0.5);

    expect(popup.value, isNotNull);
  });

  group('dismiss', () {
    const transition = Duration(milliseconds: 600);
    final hudFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    testWidgets('works after the owner widget is unmounted',
        (WidgetTester tester) async {
      final showOwner = ValueNotifier<bool>(true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<bool>(
              valueListenable: showOwner,
              builder: (context, show, _) =>
                  show ? const _Owner() : const Text('replacement'),
            ),
          ),
        ),
      );
      final popup = PopupHUD(tester.state(find.byType(_Owner)).context);
      popup.show();
      await tester.pump();
      await tester.pump(transition);
      expect(hudFinder, findsOneWidget);

      showOwner.value = false;
      await tester.pump();
      expect(find.byType(_Owner), findsNothing);
      expect(hudFinder, findsOneWidget);

      expect(popup.dismiss(), isTrue);
      await tester.pump();
      await tester.pump(transition);
      expect(hudFinder, findsNothing);
      expect(find.text('replacement'), findsOneWidget);
    });

    testWidgets('is a no-op once the HUD was removed with its page',
        (WidgetTester tester) async {
      final showPage = ValueNotifier<bool>(true);
      await tester.pumpWidget(
        MaterialApp(
          home: ValueListenableBuilder<bool>(
            valueListenable: showPage,
            builder: (context, show, _) => Navigator(
              pages: [
                const MaterialPage<void>(
                  key: ValueKey('list'),
                  child: Scaffold(body: Text('list')),
                ),
                if (show)
                  const MaterialPage<void>(
                    key: ValueKey('detail'),
                    child: Scaffold(body: _Owner()),
                  ),
              ],
              onDidRemovePage: (_) {},
            ),
          ),
        ),
      );
      final popup = PopupHUD(tester.state(find.byType(_Owner)).context);
      popup.show();
      await tester.pump();
      await tester.pump(transition);
      expect(hudFinder, findsOneWidget);

      showPage.value = false;
      await tester.pump();
      await tester.pump(transition);
      expect(find.byType(_Owner, skipOffstage: false), findsNothing);
      expect(hudFinder, findsNothing);

      expect(popup.dismiss(), isFalse);
      await tester.pump();
      await tester.pump(transition);
      expect(find.text('list'), findsOneWidget);
    });

    testWidgets('removes the HUD, not a route pushed above it',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _Owner())),
      );
      final ownerContext = tester.state(find.byType(_Owner)).context;
      final popup = PopupHUD(ownerContext);
      popup.show();
      await tester.pump();
      await tester.pump(transition);
      Navigator.of(ownerContext).push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('top')),
        ),
      );
      await tester.pump();
      await tester.pump(transition);
      expect(find.text('top'), findsOneWidget);
      expect(hudFinder, findsOneWidget);

      expect(popup.dismiss(), isTrue);
      await tester.pump();
      await tester.pump(transition);
      expect(find.text('top'), findsOneWidget);
      expect(hudFinder, findsNothing);
    });

    testWidgets('a second call does nothing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _Owner())),
      );
      final popup = PopupHUD(tester.state(find.byType(_Owner)).context);
      popup.show();
      await tester.pump();
      await tester.pump(transition);

      expect(popup.dismiss(), isTrue);
      expect(popup.dismiss(), isFalse);
      await tester.pump();
      await tester.pump(transition);
      expect(hudFinder, findsNothing);
      expect(find.text('owner'), findsOneWidget);
    });
  });
}

class _Owner extends StatefulWidget {
  const _Owner({Key? key}) : super(key: key);

  @override
  State<_Owner> createState() => _OwnerState();
}

class _OwnerState extends State<_Owner> {
  @override
  Widget build(BuildContext context) => const Text('owner');
}
