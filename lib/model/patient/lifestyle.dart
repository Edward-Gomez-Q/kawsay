class Lifestyle {
  final int? id;
  final int patientId;
  final bool smokes;
  final bool drinksAlcohol;
  final int drinksAlcoholFrequencyPerMonth;
  final bool exercises;
  final int exercisesFrequencyPerWeek;
  final int sleepHours;
  final String dietType;

  Lifestyle({
    this.id,
    required this.patientId,
    required this.smokes,
    required this.drinksAlcohol,
    required this.drinksAlcoholFrequencyPerMonth,
    required this.exercises,
    required this.exercisesFrequencyPerWeek,
    required this.sleepHours,
    required this.dietType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'smokes': smokes ? 1 : 0,
      'drinks_alcohol': drinksAlcohol ? 1 : 0,
      'drinks_alcohol_frequency_per_mounth': drinksAlcoholFrequencyPerMonth,
      'exercises': exercises ? 1 : 0,
      'exercises_frequency_per_week': exercisesFrequencyPerWeek,
      'sleep_hours': sleepHours,
      'diet_type': dietType,
    };
  }

  factory Lifestyle.fromMap(Map<String, dynamic> map) {
    return Lifestyle(
      id: map['id'],
      patientId: map['patient_id'],
      smokes: map['smokes'] == 1,
      drinksAlcohol: map['drinks_alcohol'] == 1,
      drinksAlcoholFrequencyPerMonth:
          map['drinks_alcohol_frequency_per_mounth'],
      exercises: map['exercises'] == 1,
      exercisesFrequencyPerWeek: map['exercises_frequency_per_week'],
      sleepHours: map['sleep_hours'],
      dietType: map['diet_type'],
    );
  }
}
