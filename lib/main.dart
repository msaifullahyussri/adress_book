import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
// import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
// import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'address_book/presentation/bloc/contact_bloc.dart';
import 'address_book/presentation/bloc/contact_event.dart';
import 'address_book/data/repositories/contact_repository.dart';
import 'address_book/presentation/pages/add_edit_contact_page.dart';
import 'address_book/presentation/pages/contact_detail_page.dart';
import 'address_book/data/models/contact_model.dart';
import 'address_book/presentation/pages/home_page.dart';
import 'address_book/presentation/pages/login_page.dart';
import 'settings/presentation/pages/settings_page.dart';
import 'address_book/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AddressBookApp());
}

class AddressBookApp extends StatelessWidget {
  const AddressBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final contactRepository = ContactRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ContactBloc(contactRepository)..add(LoadContacts()),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Address Book',
            theme: theme,
            themeMode: ThemeMode.system,
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginPage(),
              '/home': (context) => const HomePage(),
              '/addContact': (context) => const AddEditContactPage(),
              '/settings': (context) => const SettingsPage(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/editContact') {
                final contact = settings.arguments as ContactModel;
                return MaterialPageRoute(
                  builder: (context) => AddEditContactPage(contact: contact),
                );
              }
              if (settings.name == '/contactDetail') {
                final contact = settings.arguments as ContactModel;
                return MaterialPageRoute(
                  builder: (context) => ContactDetailPage(contact: contact),
                );
              }
              return null;
            },
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Page Not Found')),
              ),
            ),
          );
        },
      ),
    );
  }
}
