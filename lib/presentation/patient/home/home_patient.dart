import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';

class HomePatient extends ConsumerWidget {
  const HomePatient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.read(navigationServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Home Patient')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the Patient\'s Home Page',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                navigation.goToLogin();
              },
              child: const Text('Go to Appointment List'),
            ),
          ],
        ),
      ),
    );
  }
}
