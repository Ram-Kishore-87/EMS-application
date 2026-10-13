import 'package:drift/native.dart';
import 'package:ems_app/app.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EMS Dashboard loads and displays header', (WidgetTester tester) async {
    // Provide an in-memory database for testing
    final inMemoryDb = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(inMemoryDb),
        ],
        child: const EmsApp(),
      ),
    );

    // Initial pump and settle
    await tester.pumpAndSettle();

    // Verify app title and progress section are rendered
    expect(find.text('EMS Task Scheduler'), findsOneWidget);
    expect(find.text('Weekly Performance'), findsOneWidget);
    expect(find.text('No duties scheduled'), findsOneWidget);

    await inMemoryDb.close();
  });
}
