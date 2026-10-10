import 'package:flutter/material.dart';

class ContactsSearchBar extends StatelessWidget {
  const ContactsSearchBar({
    super.key,
    required this.query,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });
  final String query;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: 'Search by name or phone',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: onClear,
                  icon: const Icon(Icons.close),
                ),
        ),
      ),
    ),
  );
}
