import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/contact_model.dart';
import '../bloc/contact_bloc.dart';
import '../bloc/contact_event.dart';

class AddEditContactPage extends StatefulWidget {
  final ContactModel? contact;
  const AddEditContactPage({super.key, this.contact});

  @override
  _AddEditContactPageState createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  String _selectedAvatar = 'assets/images/user.png';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    _selectedAvatar = widget.contact?.avatar ?? 'assets/images/user.png';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final contact = ContactModel(
        id: widget.contact?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        avatar: _selectedAvatar,
      );

      if (widget.contact == null) {
        context.read<ContactBloc>().add(AddContact(contact));
      } else {
        context.read<ContactBloc>().add(UpdateContact(contact));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.contact == null ? 'Contact Added' : 'Contact Updated'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true); // Return true for refresh
    }
  }

  void _selectAvatar(String avatarPath) {
    setState(() {
      _selectedAvatar = avatarPath;
    });
  }

  void _showAvatarSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          children: [
            'assets/images/hacker.png',
            'assets/images/man.png',
            'assets/images/man2.png',
            'assets/images/office-man.png',
            'assets/images/user.png',
            'assets/images/woman.png',
            'assets/images/woman2.png',
            'assets/images/woman3.png',
          ].map((avatarPath) {
            return GestureDetector(
              onTap: () {
                _selectAvatar(avatarPath);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(avatarPath),
                  radius: 40,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contact == null ? 'Add Contact' : 'Edit Contact')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(_selectedAvatar),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _showAvatarSelection(context),
                child: const Text('Change Avatar'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a phone number';
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Phone must be numbers only';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter an email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveContact,
                  child: Text(widget.contact == null ? 'Save' : 'Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
