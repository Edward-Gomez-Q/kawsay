import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/emergency_contact_notifier.dart';
import 'package:project_3_kawsay/model/patient/emergency_contact.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/emergency_contact_dialog.dart';

class EmergencyContactPatient extends ConsumerStatefulWidget {
  final int patientId;

  const EmergencyContactPatient({super.key, required this.patientId});

  @override
  ConsumerState<EmergencyContactPatient> createState() =>
      _EmergencyContactPatientState();
}

class _EmergencyContactPatientState
    extends ConsumerState<EmergencyContactPatient> {
  @override
  void initState() {
    super.initState();
    // Cargar contactos al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(emergencyContactProvider(widget.patientId).notifier)
          .loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emergencyContactProvider(widget.patientId));
    final notifier = ref.read(
      emergencyContactProvider(widget.patientId).notifier,
    );

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
          // Header con botón de agregar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contactos de Emergencia',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddContactDialog(context, notifier),
                icon: const Icon(Icons.add),
                label: Text(""),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lista de contactos
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.contacts.isEmpty
                ? _buildEmptyState()
                : _buildContactsList(state.contacts, notifier),
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
          Icon(Icons.contacts_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay contactos de emergencia registrados',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega el primer contacto de emergencia',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList(
    List<EmergencyContact> contacts,
    EmergencyContactNotifier notifier,
  ) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: contact.isFamilyDoctor
                  ? Colors.green
                  : Colors.blue,
              child: Icon(
                contact.isFamilyDoctor ? Icons.local_hospital : Icons.person,
                color: Colors.white,
              ),
            ),
            title: Text(
              contact.fullName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${contact.relationship} • ${contact.phone}'),
                if (contact.isFamilyDoctor)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Médico de Familia',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Eliminar'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(context, contact, notifier);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddContactDialog(
    BuildContext context,
    EmergencyContactNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => EmergencyContactDialog(
        patientId: widget.patientId,
        onSave: (contact) {
          notifier.createContact(contact);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    EmergencyContact contact,
    EmergencyContactNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que quieres eliminar a ${contact.fullName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              notifier.deleteContact(contact.id!);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
