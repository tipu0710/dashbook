import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/contacts/presentation/cubit/contacts_cubit.dart';
import '../features/contacts/presentation/pages/contacts_page.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';

class ContactsApp extends StatelessWidget {
  const ContactsApp({
    super.key,
    required this.createContactsCubit,
    required this.palette,
  });
  final ContactsCubit Function() createContactsCubit;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, ThemeMode>(
    builder: (context, mode) => MaterialApp(
      title: 'Rocket Contacts',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromScheme(palette.light),
      darkTheme: AppTheme.fromScheme(palette.dark),
      themeMode: mode,
      home: BlocProvider(
        create: (_) => createContactsCubit()..loadContacts(),
        child: const ContactsScreen(),
      ),
    ),
  );
}
