import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/lifestyle_notifier.dart';
import 'package:project_3_kawsay/model/patient/lifestyle.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/lifestyle_edit_form.dart';

class LifestylePatient extends ConsumerStatefulWidget {
  final int patientId;

  const LifestylePatient({super.key, required this.patientId});

  @override
  ConsumerState<LifestylePatient> createState() => _LifestylePatientState();
}

class _LifestylePatientState extends ConsumerState<LifestylePatient> {
  @override
  void initState() {
    super.initState();
    // Cargar datos al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lifestyleProvider(widget.patientId).notifier).loadLifestyle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lifestyleProvider(widget.patientId));
    final notifier = ref.read(lifestyleProvider(widget.patientId).notifier);

    // Mostrar error si existe
    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
        );
        notifier.clearError();
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estilo de Vida',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (state.lifestyle != null && !state.isEditing)
                ElevatedButton.icon(
                  onPressed: state.isLoading
                      ? null
                      : () => notifier.toggleEditing(),
                  icon: const Icon(Icons.edit),
                  label: Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Contenido
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.lifestyle == null
                ? _buildEmptyState()
                : state.isEditing
                ? _buildEditForm(state.lifestyle!, notifier)
                : _buildViewMode(state.lifestyle!),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay información de estilo de vida',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildViewMode(Lifestyle lifestyle) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hábitos
          _buildSection('Hábitos', Icons.local_bar, [
            _buildInfoCard(
              'Fumador',
              lifestyle.smokes ? 'Sí' : 'No',
              lifestyle.smokes ? Colors.red : Colors.green,
              lifestyle.smokes ? Icons.smoking_rooms : Icons.smoke_free,
            ),
            _buildInfoCard(
              'Consume Alcohol',
              lifestyle.drinksAlcohol ? 'Sí' : 'No',
              lifestyle.drinksAlcohol ? Colors.orange : Colors.green,
              lifestyle.drinksAlcohol ? Icons.local_bar : Icons.no_drinks,
            ),
            if (lifestyle.drinksAlcohol)
              _buildInfoCard(
                'Frecuencia Alcohol',
                '${lifestyle.drinksAlcoholFrequencyPerMonth} veces/mes',
                Colors.orange,
                Icons.calendar_month,
              ),
          ]),

          // Actividad Física
          _buildSection('Actividad Física', Icons.fitness_center, [
            _buildInfoCard(
              'Hace Ejercicio',
              lifestyle.exercises ? 'Sí' : 'No',
              lifestyle.exercises ? Colors.green : Colors.red,
              lifestyle.exercises ? Icons.fitness_center : Icons.event_seat,
            ),
            _buildInfoCard(
              'Frecuencia Ejercicio',
              '${lifestyle.exercisesFrequencyPerWeek} veces/semana',
              _getFrequencyColor(lifestyle.exercisesFrequencyPerWeek),
              Icons.calendar_view_week,
            ),
          ]),

          // Descanso y Alimentación
          _buildSection('Descanso y Alimentación', Icons.restaurant, [
            _buildInfoCard(
              'Horas de Sueño',
              '${lifestyle.sleepHours} horas',
              _getSleepColor(lifestyle.sleepHours),
              Icons.bedtime,
            ),
            _buildInfoCard(
              'Tipo de Dieta',
              lifestyle.dietType,
              Colors.blue,
              Icons.restaurant_menu,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w500, color: color),
        ),
      ),
    );
  }

  Color _getSleepColor(int hours) {
    if (hours >= 7 && hours <= 9) return Colors.green;
    if (hours >= 6 && hours <= 10) return Colors.orange;
    return Colors.red;
  }

  Color _getFrequencyColor(int frequency) {
    if (frequency >= 3) return Colors.green;
    if (frequency == 2) return Colors.orange;
    return Colors.red;
  }

  Widget _buildEditForm(Lifestyle lifestyle, LifestyleNotifier notifier) {
    return LifestyleEditForm(
      lifestyle: lifestyle,
      onSave: (updatedLifestyle) {
        notifier.updateLifestyle(updatedLifestyle);
      },
      onCancel: () {
        notifier.cancelEditing();
      },
    );
  }
}
