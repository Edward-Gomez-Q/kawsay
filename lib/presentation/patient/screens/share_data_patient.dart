import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/patient_screens_notifier.dart';
import 'package:project_3_kawsay/application/patient/share_data_patient_notifier.dart';
import 'package:project_3_kawsay/state/patient/share_data_patient_state.dart';

class ShareDataPatient extends ConsumerWidget {
  final int patientId;
  final int personId;
  const ShareDataPatient({
    super.key,
    required this.patientId,
    required this.personId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = PatientPersonKey(patientId, personId);
    final state = ref.watch(shareDataProvider(key));
    final notifier = ref.read(shareDataProvider(key).notifier);
    final theme = Theme.of(context);
    final navigator = ref.read(patientScreensProvider.notifier);

    return SingleChildScrollView(
      child: state.isSuccess
          ? _buildSuccessView(context, state, notifier, navigator)
          : _buildMainView(context, state, notifier, theme),
    );
  }

  Widget _buildMainView(
    BuildContext context,
    ShareDataState state,
    ShareDataNotifier notifier,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de sección
          Text(
            'Selecciona los datos a compartir',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Los datos personales son obligatorios y siempre se incluyen',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 24),

          // Lista de datos
          _buildDataSelectionCard(context, state, notifier, theme),

          SizedBox(height: 24),

          // Sección de tiempo
          Text(
            'Tiempo de disponibilidad',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          _buildTimeSelectionCard(context, state, notifier, theme),

          SizedBox(height: 32),

          // Error message
          if (state.error != null)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                state.error!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),

          if (state.error != null) SizedBox(height: 16),

          // Botón de compartir
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : () => notifier.shareData(),
              child: state.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Generando código...'),
                      ],
                    )
                  : Text('Generar código de compartir'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSelectionCard(
    BuildContext context,
    ShareDataState state,
    ShareDataNotifier notifier,
    ThemeData theme,
  ) {
    final dataOptions = {
      'personalData': 'Datos personales',
      'chronicConditions': 'Condiciones crónicas',
      'emergencyContacts': 'Contactos de emergencia',
      'familyHistories': 'Historial familiar',
      'hospitalizations': 'Hospitalizaciones',
      'insurances': 'Seguros médicos',
      'lifestyles': 'Estilo de vida',
      'medicalAllergies': 'Alergias médicas',
      'medicalCriticalInfo': 'Información crítica médica',
      'surgicalHistories': 'Historial quirúrgico',
      'vaccinations': 'Vacunas',
    };

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: dataOptions.entries.map((entry) {
            final isRequired = entry.key == 'personalData';
            final isSelected = state.selectedData[entry.key]!;

            return CheckboxListTile(
              value: isSelected,
              onChanged: isRequired
                  ? null
                  : (value) => notifier.toggleDataSelection(entry.key),
              title: Text(entry.value),
              subtitle: isRequired
                  ? Text(
                      'Obligatorio',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTimeSelectionCard(
    BuildContext context,
    ShareDataState state,
    ShareDataNotifier notifier,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTimeTypeButton(
                    context,
                    'Minutos',
                    TimeType.minutes,
                    state.selectedTimeType,
                    notifier,
                    theme,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildTimeTypeButton(
                    context,
                    'Horas',
                    TimeType.hours,
                    state.selectedTimeType,
                    notifier,
                    theme,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildTimeTypeButton(
                    context,
                    'Días',
                    TimeType.days,
                    state.selectedTimeType,
                    notifier,
                    theme,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildTimeTypeButton(
                    context,
                    'Semanas',
                    TimeType.weeks,
                    state.selectedTimeType,
                    notifier,
                    theme,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Selector de valores
            _buildTimeValueSelector(context, state, notifier, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTypeButton(
    BuildContext context,
    String label,
    TimeType type,
    TimeType selectedType,
    ShareDataNotifier notifier,
    ThemeData theme,
  ) {
    final isSelected = selectedType == type;

    return OutlinedButton(
      onPressed: () => notifier.setTimeType(type),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? theme.colorScheme.primaryContainer : null,
        foregroundColor: isSelected
            ? theme.colorScheme.onPrimaryContainer
            : null,
      ),
      child: Text(label),
    );
  }

  Widget _buildTimeValueSelector(
    BuildContext context,
    ShareDataState state,
    ShareDataNotifier notifier,
    ThemeData theme,
  ) {
    List<int> options;
    String unit;

    switch (state.selectedTimeType) {
      case TimeType.minutes:
        options = [4, 20, 40];
        unit = 'minutos';
        break;
      case TimeType.hours:
        options = [1, 6, 12];
        unit = 'horas';
        break;
      case TimeType.days:
        options = [1, 2, 4];
        unit = 'días';
        break;
      case TimeType.weeks:
        options = [1];
        unit = 'semana';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Duración:', style: theme.textTheme.titleMedium),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((value) {
            final isSelected = state.selectedTimeValue == value;
            return ChoiceChip(
              label: Text('$value $unit'),
              selected: isSelected,
              onSelected: (selected) => notifier.setTimeValue(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSuccessView(
    BuildContext context,
    ShareDataState state,
    ShareDataNotifier notifier,
    PatientScreensNotifier navigator,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 80, color: theme.colorScheme.primary),
          SizedBox(height: 24),
          Text(
            '¡Código generado exitosamente!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Comparte este código con el profesional médico:',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Text(
              state.generatedCode!,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => notifier.reset(),
              child: Text('Generar nuevo código'),
            ),
          ),
        ],
      ),
    );
  }
}
