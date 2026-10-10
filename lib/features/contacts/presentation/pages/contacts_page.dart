import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/contacts_cubit.dart';
import '../cubit/contacts_state.dart';
import '../widgets/contact_tile.dart';
import '../widgets/contacts_error_banner.dart';
import '../widgets/contacts_header.dart';
import '../widgets/contacts_placeholder.dart';
import '../widgets/contacts_search_bar.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
  }

  void _maybeLoadMore() {
    if (mounted && _scroll.hasClients && _scroll.position.extentAfter < 240) {
      context.read<ContactsCubit>().loadNextPage();
    }
  }

  void _clearSearch() {
    _search.clear();
    if (_scroll.hasClients) _scroll.jumpTo(0);
    context.read<ContactsCubit>().onSearchQueryChanged('');
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: BlocConsumer<ContactsCubit, ContactsState>(
            listener: (context, state) {
              // Fill a tall viewport even when there is not enough content to scroll.
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _maybeLoadMore(),
              );
            },
            builder: (context, state) => RefreshIndicator(
              onRefresh: context.read<ContactsCubit>().refreshContacts,
              child: NotificationListener<ScrollMetricsNotification>(
                onNotification: (_) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _maybeLoadMore(),
                  );
                  return false;
                },
                child: CustomScrollView(
                  key: const PageStorageKey('contacts-list'),
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    const SliverToBoxAdapter(child: ContactsHeader()),
                    PinnedHeaderSliver(
                      child: ContactsSearchBar(
                        query: state.query,
                        controller: _search,
                        onChanged: context
                            .read<ContactsCubit>()
                            .onSearchQueryChanged,
                        onClear: _clearSearch,
                      ),
                    ),
                    if (state.error != null && state.contacts.isNotEmpty)
                      SliverToBoxAdapter(
                        child: ContactsErrorBanner(
                          message: state.error!,
                          onRetry: context
                              .read<ContactsCubit>()
                              .refreshContacts,
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      sliver: SliverMainAxisGroup(
                        slivers: _slivers(context, state),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  List<Widget> _slivers(BuildContext context, ContactsState state) {
    if (state.status == ContactsStatus.initial ||
        state.status == ContactsStatus.loading) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    semanticsLabel: 'Loading contacts',
                  ),
                ),
                SizedBox(height: 16),
                Text('Finding your people…'),
              ],
            ),
          ),
        ),
      ];
    }
    if (state.status == ContactsStatus.failure) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ContactsPlaceholder(
            icon: Icons.cloud_off_outlined,
            title: 'Couldn’t load contacts',
            message: state.error!,
            action: FilledButton.icon(
              onPressed: context.read<ContactsCubit>().retryInitialLoad,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ),
        ),
      ];
    }
    if (state.contacts.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ContactsPlaceholder(
            icon: Icons.person_search_outlined,
            title: 'No contacts found',
            message: state.query.trim().isEmpty
                ? 'Your directory is empty. Pull down to refresh.'
                : 'Try a different name or phone number.',
            action: state.query.trim().isEmpty
                ? null
                : OutlinedButton(
                    onPressed: _clearSearch,
                    child: const Text('Clear search'),
                  ),
          ),
        ),
      ];
    }
    return [
      SliverList.separated(
        itemCount: state.contacts.length,
        itemBuilder: (_, index) => ContactTile(
          key: ValueKey(state.contacts[index].id),
          contact: state.contacts[index],
        ),
        separatorBuilder: (_, index) => const Divider(indent: 68),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: state.isLoadingMore
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      semanticsLabel: 'Loading more contacts',
                    ),
                  )
                : state.paginationError != null
                ? Column(
                    children: [
                      Text(state.paginationError!, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () =>
                            context.read<ContactsCubit>().retryNextPage(),
                        child: const Text('Retry loading more'),
                      ),
                    ],
                  )
                : !state.hasMore
                ? Text(
                    'You’re all caught up',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    ];
  }
}
