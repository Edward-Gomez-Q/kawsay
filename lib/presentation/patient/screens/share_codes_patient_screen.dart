import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/patient/sharing_sessions_notifier.dart';
import 'package:project_3_kawsay/model/common/sharing_session_model.dart';
import 'package:project_3_kawsay/state/patient/sharing_sessions_state.dart';

class ShareCodesPatientScreen extends ConsumerStatefulWidget {
  const ShareCodesPatientScreen({super.key});

  @override
  ConsumerState<ShareCodesPatientScreen> createState() =>
      _ShareCodesPatientScreenState();
}

class _ShareCodesPatientScreenState
    extends ConsumerState<ShareCodesPatientScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSessions();
    });
  }

  void _loadSessions() {
    final authState = ref.read(authProvider);
    final patientId = authState.patientId?.id;

    if (patientId != null) {
      ref.read(sharingSessionsProvider.notifier).loadSessions(patientId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final sessionsState = ref.watch(sharingSessionsProvider);
    final sessionsNotifier = ref.read(sharingSessionsProvider.notifier);

    return Container(
      color: themeData.scaffoldBackgroundColor,
      child: _buildBody(context, themeData, sessionsState, sessionsNotifier),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData themeData,
    SharingSessionsState sessionsState,
    SharingSessionsNotifier sessionsNotifier,
  ) {
    if (sessionsState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: themeData.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Cargando sesiones...', style: themeData.textTheme.bodyMedium),
          ],
        ),
      );
    }

    if (sessionsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: themeData.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar las sesiones',
              style: themeData.textTheme.headlineSmall?.copyWith(
                color: themeData.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                sessionsState.error!,
                textAlign: TextAlign.center,
                style: themeData.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                sessionsNotifier.clearError();
                _loadSessions();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (sessionsState.sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.share_outlined,
              size: 64,
              color: themeData.iconTheme.color?.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay sesiones de compartición',
              style: themeData.textTheme.headlineSmall?.copyWith(
                color: themeData.iconTheme.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aún no has compartido ninguna información',
              style: themeData.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadSessions(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessionsState.sessions.length,
        itemBuilder: (context, index) {
          final session = sessionsState.sessions[index];
          return _buildSessionCard(
            context,
            themeData,
            session,
            sessionsState,
            sessionsNotifier,
          );
        },
      ),
    );
  }

  Widget _buildSessionCard(
    BuildContext context,
    ThemeData themeData,
    SharingSessionModel session,
    SharingSessionsState sessionsState,
    SharingSessionsNotifier sessionsNotifier,
  ) {
    final now = DateTime.now();
    final isExpired = session.expiresAt.isBefore(now);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: themeData.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con código y estado
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Código de Compartición',
                        style: themeData.textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              session.shareCode,
                              style: themeData.textTheme.headlineSmall
                                  ?.copyWith(
                                    color: themeData.colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.copy,
                              color: themeData.colorScheme.primary,
                            ),
                            onPressed: () =>
                                _copyToClipboard(context, session.shareCode),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Información de fechas
            Row(
              children: [
                Expanded(
                  child: _buildDateInfo(
                    themeData,
                    'Creado',
                    session.createdAt,
                    Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateInfo(
                    themeData,
                    'Expira',
                    session.expiresAt,
                    Icons.schedule,
                    isExpired: isExpired,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(
    ThemeData themeData,
    String label,
    DateTime date,
    IconData icon, {
    bool isExpired = false,
  }) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    final textColor = isExpired
        ? themeData.colorScheme.error
        : themeData.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: themeData.textTheme.labelMedium),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                formatter.format(date),
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Código copiado al portapapeles'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
