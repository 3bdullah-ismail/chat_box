import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/core/di/injection_container.dart';
import 'package:chat_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  setUpAll(() {
    getIt.registerFactory<AuthCubit>(() => MockAuthCubit());
  });

  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Set a larger virtual screen size to prevent layout overflows in the test environment
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the onboarding screen is shown.
    expect(find.text('Get Started'), findsOneWidget);
  });
}
