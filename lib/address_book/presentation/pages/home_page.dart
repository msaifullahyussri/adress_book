import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../core/export_helper.dart';
import '../bloc/contact_bloc.dart';
import '../bloc/contact_state.dart';
import '../widgets/contact_list.dart';
import '../../theme/theme_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ContactListPage(),
    const SettingsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _exportContacts(BuildContext context, bool isPdf) async {
    final state = context.read<ContactBloc>().state;
    if (state is ContactLoaded && state.contacts.isNotEmpty) {
      final file = isPdf
          ? await ExportHelper.exportToPdf(state.contacts)
          : await ExportHelper.exportToExcel(state.contacts);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File saved: ${file.path}'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No contacts to export!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state.brightness == Brightness.dark;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Address Book'),
      //   actions: [
      //     // IconButton(
      //     //   icon: const Icon(Icons.picture_as_pdf),
      //     //   onPressed: () => _exportContacts(context, true),
      //     // ),
      //     // IconButton(
      //     //   icon: const Icon(Icons.table_chart),
      //     //   onPressed: () => _exportContacts(context, false),
      //     // ),
      //     IconButton(
      //       icon: const Icon(Icons.brightness_6),
      //       onPressed: () {
      //         context.read<ThemeCubit>().toggleTheme(!isDarkMode);
      //       },
      //     ),
      //   ],
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addContact');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
