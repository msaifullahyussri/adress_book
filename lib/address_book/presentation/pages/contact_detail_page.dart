import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/contact_model.dart';
import '../bloc/contact_bloc.dart';
import '../bloc/contact_state.dart';
import '../bloc/contact_event.dart';

class ContactDetailPage extends StatelessWidget {
  final ContactModel contact;

  const ContactDetailPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        // Pastikan dapat data terkini jika ada perubahan
        final updatedContact = (state is ContactLoaded)
            ? state.contacts.firstWhere(
              (c) => c.id == contact.id,
          orElse: () => contact,
        )
            : contact;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Contact Details'),
            actions: [
              IconButton(
                icon: Icon(
                  updatedContact.isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.yellow[700],
                ),
                onPressed: () {
                  context
                      .read<ContactBloc>()
                      .add(ToggleFavoriteContact(updatedContact.id));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: updatedContact.avatar != null &&
                          updatedContact.avatar!.isNotEmpty
                          ? AssetImage(updatedContact.avatar!)
                          : const AssetImage('assets/images/user.png'),
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      updatedContact.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow(Icons.phone, updatedContact.phone),
                    const SizedBox(height: 10),
                    _buildDetailRow(Icons.email, updatedContact.email),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/editContact',
                              arguments: updatedContact,
                            ).then((_) {
                              context.read<ContactBloc>().add(LoadContacts());
                            });
                          },
                          icon: const Icon(Icons.edit, color: Colors.black87),
                          label: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color.fromARGB(255, 240, 230, 140),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _confirmDelete(context, updatedContact);
                          },
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, ContactModel contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ContactBloc>().add(DeleteContact(contact.id));
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Back to list
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
