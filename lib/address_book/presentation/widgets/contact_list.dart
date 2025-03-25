import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../data/models/contact_model.dart';
import '../bloc/contact_bloc.dart';
import '../bloc/contact_state.dart';
import '../bloc/contact_event.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  String _searchQuery = '';
  bool showFavouritesOnly = false;

  @override
  void initState() {
    super.initState();
    context.read<ContactBloc>().add(LoadContacts());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Contact List')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Toggle Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton('Contact', !showFavouritesOnly, isDark),
                const SizedBox(width: 10),
                _buildToggleButton('Favourite', showFavouritesOnly, isDark),
              ],
            ),

            const SizedBox(height: 16),

            // List Title based on mode
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                showFavouritesOnly ? 'Favourite List' : 'Contact List',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // Contact List
            Expanded(
              child: BlocBuilder<ContactBloc, ContactState>(
                builder: (context, state) {
                  if (state is ContactLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ContactLoaded) {
                    // Filter favourites if toggled
                    List<ContactModel> contacts = showFavouritesOnly
                        ? state.contacts.where((c) => c.isFavorite).toList()
                        : state.contacts;

                    // Search filter
                    contacts = contacts
                        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();

                    if (contacts.isEmpty) {
                      // Show Lottie animation if no data
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/animations/empty_box.json', width: 200),
                          const SizedBox(height: 16),
                          Text(
                            showFavouritesOnly
                                ? 'No favorite contacts found'
                                : 'No contacts found',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      );
                    }

                    // Sort and group by alphabet
                    contacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                    Map<String, List<ContactModel>> grouped = {};
                    for (var contact in contacts) {
                      String letter = contact.name.isNotEmpty
                          ? contact.name[0].toUpperCase()
                          : '#';
                      grouped.putIfAbsent(letter, () => []).add(contact);
                    }

                    return ListView(
                      children: grouped.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.key,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 8),
                            ...entry.value.map((contact) => _buildContactCard(contact, isDark)),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const Center(child: Text('Failed to load contacts'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addContact').then((_) {
          context.read<ContactBloc>().add(LoadContacts());
        }),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Toggle Button Widget
  Widget _buildToggleButton(String label, bool isActive, bool isDark) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() {
          showFavouritesOnly = label == 'Favourite';
        }),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive
              ? (isDark ? Colors.deepPurple[300] : Colors.deepPurple)
              : (isDark ? Colors.grey[700] : Colors.grey[300]),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: TextStyle(color: isActive ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // Contact Card Widget
  Widget _buildContactCard(ContactModel contact, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/contactDetail', arguments: contact)
          .then((_) => context.read<ContactBloc>().add(LoadContacts())),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: isDark ? Colors.grey[800] : Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: contact.avatar != null && contact.avatar!.isNotEmpty
                ? AssetImage(contact.avatar!)
                : const AssetImage('assets/images/user.png'),
            radius: 25,
          ),
          title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(contact.phone),
          trailing: contact.isFavorite
              ? const Icon(Icons.star, color: Colors.amber)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
