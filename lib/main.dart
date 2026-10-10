import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/contacts/presentation/cubit/contacts_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    BlocProvider(
      create: (_) => getIt<ThemeCubit>(),
      child: ContactsApp(
        createContactsCubit: () => getIt<ContactsCubit>(),
        palette: AppPalette.monochrome(),
      ),
    ),
  );
}
