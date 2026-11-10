import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/empty_state_view.dart';
import '../../../../domain/data/provider/contact_provider.dart';
import '../../logic/home_controller.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/contact_card.dart';
import '../widgets/fliatong_action_bottoms.dart';
import '../widgets/home_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _controller;
  final TextEditingController _searchController = TextEditingController();

  int _selectedTabIndex = 0;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
      _searchController.clear();
    });
    _controller.onTabChanged(index);
  }

  void _onToggleSort() {
    setState(() {
      _isAscending = !_isAscending;
    });
    _controller.onToggleSort(_isAscending);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedTabIndex == 0 ? 'Contacts' : 'Favorites'),
        actions: [
          IconButton(
            tooltip: _isAscending ? 'Sort Z to A' : 'Sort A to Z',
            icon: Icon(_isAscending ? Icons.sort_by_alpha : Icons.sort),
            onPressed: _onToggleSort,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionBottoms(
        onPressed: _controller.showAddContactOptions,
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _onTabChanged,
      ),
      body: Column(
        children: [
          HomeSearchBar(
            controller: _searchController,
            onChanged: _controller.onSearch,
            onClear: () {
              _searchController.clear();
              _controller.onSearch('');
              setState(() {});
            },
          ),
          Expanded(
            child: Consumer<ContactProvider>(
              builder: (context, provider, child) {
                final contacts = provider.contacts;

                if (contacts.isEmpty) {
                  if (_searchController.text.isNotEmpty) {
                    return const EmptyStateView(
                      icon: Icons.search_off_rounded,
                      title: 'No Matching Contacts',
                      message: 'Try searching with a different name or number.',
                    );
                  }

                  if (_selectedTabIndex == 1) {
                    return const EmptyStateView(
                      icon: Icons.favorite_border_rounded,
                      title: 'No Favorites Yet',
                      message: 'Tap the heart icon on any contact to add them to your favorites.',
                    );
                  }

                  return EmptyStateView(
                    icon: Icons.person_add_outlined,
                    title: 'No Contacts Found',
                    message: 'Get started by scanning a business card or adding contacts manually.',
                    buttonText: 'Add First Contact',
                    onButtonPressed: _controller.showAddContactOptions,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 6, bottom: 80),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];

                    return ContactCard(
                      contact: contact,
                      onTap: () => _controller.openContactDetails(contact.id),
                      onToggleFavorite: () => _controller.onToggleFavorite(contact),
                      onDismissed: () => _controller.onDeleteContact(contact),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
