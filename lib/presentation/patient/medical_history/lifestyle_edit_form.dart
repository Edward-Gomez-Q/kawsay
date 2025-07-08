import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/model/patient/lifestyle.dart';

class LifestyleEditForm extends ConsumerStatefulWidget {
  final Lifestyle lifestyle;
  final Function(Lifestyle) onSave;
  final VoidCallback onCancel;

  const LifestyleEditForm({
    super.key,
    required this.lifestyle,
    required this.onSave,
    required this.onCancel,
  });

  @override
  ConsumerState<LifestyleEditForm> createState() => _LifestyleEditFormState();
}

class _LifestyleEditFormState extends ConsumerState<LifestyleEditForm> {
  final _formKey = GlobalKey<FormState>();
  late bool _smokes;
  late bool _drinksAlcohol;
  late int _drinksAlcoholFrequency;
  late bool _exercises;
  late int _exercisesFrequency;
  late int _sleepHours;
  late String _dietType;

  final List<String> _dietTypes = [
    'Normal',
    'Vegetariana',
    'Vegana',
    'Mediterránea',
    'Baja en carbohidratos',
    'Baja en grasas',
    'Sin gluten',
    'Otra',
  ];

  @override
  void initState() {
    super.initState();
    _smokes = widget.lifestyle.smokes;
    _drinksAlcohol = widget.lifestyle.drinksAlcohol;
    _drinksAlcoholFrequency = widget.lifestyle.drinksAlcoholFrequencyPerMonth;
    _exercises = widget.lifestyle.exercises;
    _exercisesFrequency = widget.lifestyle.exercisesFrequencyPerWeek;
    _sleepHours = widget.lifestyle.sleepHours;
    _dietType = widget.lifestyle.dietType;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Hábitos
            _buildSectionHeader('Hábitos', Icons.local_bar),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Fumador'),
                      subtitle: const Text('¿Fuma regularmente?'),
                      value: _smokes,
                      onChanged: (value) {
                        setState(() {
                          _smokes = value;
                        });
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Consume Alcohol'),
                      subtitle: const Text('¿Consume bebidas alcohólicas?'),
                      value: _drinksAlcohol,
                      onChanged: (value) {
                        setState(() {
                          _drinksAlcohol = value;
                          if (!value) _drinksAlcoholFrequency = 0;
                        });
                      },
                    ),
                    if (_drinksAlcohol) ...[
                      const Divider(),
                      ListTile(
                        title: const Text('Frecuencia de Alcohol'),
                        subtitle: Text(
                          '$_drinksAlcoholFrequency veces por mes',
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: TextFormField(
                            initialValue: _drinksAlcoholFrequency.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              suffix: Text('veces'),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _drinksAlcoholFrequency =
                                    int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Actividad Física
            _buildSectionHeader('Actividad Física', Icons.fitness_center),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Hace Ejercicio'),
                      subtitle: const Text(
                        '¿Realiza actividad física regularmente?',
                      ),
                      value: _exercises,
                      onChanged: (value) {
                        setState(() {
                          _exercises = value;
                          if (!value) _exercisesFrequency = 0;
                        });
                      },
                    ),
                    if (_exercises) ...[
                      const Divider(),
                      ListTile(
                        title: const Text('Frecuencia de Ejercicio'),
                        subtitle: Text('$_exercisesFrequency veces por semana'),
                        trailing: SizedBox(
                          width: 100,
                          child: TextFormField(
                            initialValue: _exercisesFrequency.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              suffix: Text('veces'),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _exercisesFrequency = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Descanso y Alimentación
            _buildSectionHeader('Descanso y Alimentación', Icons.restaurant),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Horas de Sueño'),
                      subtitle: Text('$_sleepHours horas por noche'),
                      trailing: SizedBox(
                        width: 100,
                        child: TextFormField(
                          initialValue: _sleepHours.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            suffix: Text('hrs'),
                            isDense: true,
                          ),
                          validator: (value) {
                            final hours = int.tryParse(value ?? '');
                            if (hours == null || hours < 1 || hours > 24) {
                              return 'Entre 1-24';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _sleepHours = int.tryParse(value) ?? 8;
                            });
                          },
                        ),
                      ),
                    ),
                    const Divider(),
                    DropdownButtonFormField<String>(
                      value: _dietType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Dieta',
                        border: OutlineInputBorder(),
                      ),
                      items: _dietTypes
                          .map(
                            (diet) => DropdownMenuItem(
                              value: diet,
                              child: Text(diet),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _dietType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedLifestyle = Lifestyle(
        id: widget.lifestyle.id,
        patientId: widget.lifestyle.patientId,
        smokes: _smokes,
        drinksAlcohol: _drinksAlcohol,
        drinksAlcoholFrequencyPerMonth: _drinksAlcoholFrequency,
        exercises: _exercises,
        exercisesFrequencyPerWeek: _exercisesFrequency,
        sleepHours: _sleepHours,
        dietType: _dietType,
      );

      widget.onSave(updatedLifestyle);
    }
  }
}
