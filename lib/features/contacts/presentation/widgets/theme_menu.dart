import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_cubit.dart';

class ThemeMenu extends StatelessWidget {
  const ThemeMenu({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, ThemeMode>(
    builder: (context, mode) => PopupMenuButton<ThemeMode>(
      tooltip: 'Change appearance',
      icon: Icon(
        Theme.of(context).brightness == Brightness.dark
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
      ),
      initialValue: mode,
      onSelected: context.read<ThemeCubit>().setMode,
      itemBuilder: (_) => [
        for (final entry in const {
          ThemeMode.system: 'Use device setting',
          ThemeMode.light: 'Light',
          ThemeMode.dark: 'Dark',
        }.entries)
          CheckedPopupMenuItem(
            value: entry.key,
            checked: mode == entry.key,
            child: Text(entry.value),
          ),
      ],
    ),
  );
}
