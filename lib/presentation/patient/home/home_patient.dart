import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';

class HomePatient extends ConsumerWidget {
  const HomePatient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.read(navigationServiceProvider);
    final authMethods = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: _buildAppBar(context, authMethods, navigation),
      body: const _HomePatientBody(),
      bottomNavigationBar: const _BottomNavigationBar(),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    dynamic authMethods,
    dynamic navigation,
  ) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          const Text('☀️'),
          const SizedBox(width: 8),
          Text(
            'Buenos días, Juan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            // Handle settings
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            authMethods.logout();
            navigation.goToWelcome();
          },
        ),
      ],
    );
  }
}

class _HomePatientBody extends StatelessWidget {
  const _HomePatientBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthSummaryCard(context),
          const SizedBox(height: 24),
          _buildQuickActionsSection(context),
          const SizedBox(height: 24),
          _buildStatisticsCard(context),
          const SizedBox(height: 80), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildHealthSummaryCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Resumen de salud',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Última actualización: Hoy',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildSummaryItem(context, '✅', 'Perfil: 85% completo'),
                  const SizedBox(height: 8),
                  _buildSummaryItem(context, '📅', 'Próxima cita: 15 Jul'),
                  const SizedBox(height: 8),
                  _buildSummaryItem(context, '💊', 'Medicamentos: 2 activos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.speed, size: 20),
            const SizedBox(width: 8),
            Text(
              'Acciones rápidas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                '📝',
                'Actualizar\nhistorial',
                () {
                  // Handle update history
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                '📤',
                'Compartir\ncon médico',
                () {
                  // Handle share with doctor
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(context, '📊', 'Ver\nhistorial', () {
                // Handle view history
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(context, '📋', 'Síntomas\ny notas', () {
                // Handle symptoms and notes
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String emoji,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Estadísticas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consultas este año: 4',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProgressBar(context, 0.4), // 4 out of 10 consultations
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Estado general: Bueno',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('😊', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double progress) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavItem(
                context,
                Icons.home_outlined,
                'Casa',
                isSelected: true,
                onTap: () {
                  // Handle home navigation
                },
              ),
              _buildBottomNavItem(
                context,
                Icons.bar_chart_outlined,
                'Hist.',
                onTap: () {
                  // Handle history navigation
                },
              ),
              _buildBottomNavItem(
                context,
                Icons.medication_outlined,
                'Meds',
                onTap: () {
                  // Handle medications navigation
                },
              ),
              _buildBottomNavItem(
                context,
                Icons.share_outlined,
                'Comp.',
                onTap: () {
                  // Handle share navigation
                },
              ),
              _buildBottomNavItem(
                context,
                Icons.person_outline,
                'Perfil',
                onTap: () {
                  // Handle profile navigation
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    final color = isSelected
        ? Theme.of(context).primaryColor
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
