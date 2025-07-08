import 'package:sqflite/sqflite.dart';

class DatabaseInitializer {
  static Future<void> createDatabase(Database db, int version) async {
    // Crear tablas
    await _createTables(db);

    // Insertar datos por defecto
    await _insertDefaultData(db);
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE patient (
        id INTEGER NOT NULL CONSTRAINT patient_pk PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE chronic_condition (
        id INTEGER NOT NULL CONSTRAINT chronic_condition_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        condition TEXT NOT NULL,
        diagnosis_date DATE,
        controlled BOOLEAN NOT NULL,
        CONSTRAINT chronic_condition_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE emergency_contact (
        id INTEGER NOT NULL CONSTRAINT emergency_contact_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        full_name TEXT NOT NULL,
        relationship TEXT NOT NULL,
        phone TEXT NOT NULL,
        is_family_doctor BOOLEAN NOT NULL,
        CONSTRAINT Table_17_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE family_history (
        id INTEGER NOT NULL CONSTRAINT family_history_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        relationship TEXT NOT NULL,
        condition TEXT NOT NULL,
        age_of_onset INTEGER NOT NULL,
        CONSTRAINT family_history_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE hospitalization (
        id INTEGER NOT NULL CONSTRAINT hospitalization_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        reason TEXT NOT NULL,
        admission_date DATE NOT NULL,
        discharge_date DATE NOT NULL,
        CONSTRAINT hospitalization_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE insurance (
        id INTEGER NOT NULL CONSTRAINT insurance_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        provider TEXT NOT NULL,
        policy_number TEXT NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        CONSTRAINT insurance_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE lifestyle (
        id INTEGER NOT NULL CONSTRAINT lifestyle_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        smokes BOOLEAN NOT NULL,
        drinks_alcohol BOOLEAN NOT NULL,
        drinks_alcohol_frequency_per_mounth INTEGER NOT NULL,
        exercises BOOLEAN NOT NULL,
        exercises_frequency_per_week BOOLEAN NOT NULL,
        sleep_hours INTEGER NOT NULL,
        diet_type TEXT NOT NULL,
        CONSTRAINT lifestyle_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE medical_allergy (
        id INTEGER NOT NULL CONSTRAINT medical_allergy_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        allergen_from TEXT NOT NULL,
        allergen TEXT NOT NULL,
        reaction TEXT,
        severity TEXT,
        CONSTRAINT medical_allergy_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE medical_critical_info (
        id INTEGER NOT NULL CONSTRAINT medical_critical_info_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        blood_type TEXT NOT NULL,
        pregnant BOOLEAN NOT NULL,
        has_implants BOOLEAN NOT NULL,
        notes TEXT,
        CONSTRAINT medical_critical_info_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE surgical_history (
        id INTEGER NOT NULL CONSTRAINT surgical_history_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        surgery TEXT NOT NULL,
        surgery_date DATE NOT NULL,
        complications BOOLEAN NOT NULL,
        note_complications TEXT,
        CONSTRAINT surgical_history_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE vaccination (
        id INTEGER NOT NULL CONSTRAINT vaccination_pk PRIMARY KEY,
        patient_id INTEGER NOT NULL,
        vaccine TEXT NOT NULL,
        dose TEXT NOT NULL,
        date_vaccine DATE NOT NULL,
        institution TEXT NOT NULL,
        CONSTRAINT vaccination_patient FOREIGN KEY (patient_id)
        REFERENCES patient (id)
      )
    ''');
  }

  static Future<void> _insertDefaultData(Database db) async {
    // Crear paciente por defecto
    await db.insert('patient', {'id': 1});

    // Insertar datos por defecto de lifestyle
    await db.insert('lifestyle', {
      'patient_id': 1,
      'smokes': 0,
      'drinks_alcohol': 0,
      'drinks_alcohol_frequency_per_mounth': 0,
      'exercises': 0,
      'exercises_frequency_per_week': 0,
      'sleep_hours': 8,
      'diet_type': 'Normal',
    });

    // Insertar datos por defecto de medical_critical_info
    await db.insert('medical_critical_info', {
      'patient_id': 1,
      'blood_type': 'O+',
      'pregnant': 0,
      'has_implants': 0,
      'notes': '',
    });
  }
}
