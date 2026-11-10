import 'package:flutter/material.dart';

import '../helper/data_base.dart';
import '../models/contact_model.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> _contacts = [];
  List<ContactModel> _allContacts = [];

  final DataBase _dataBase = DataBase();

  List<ContactModel> get contacts => _contacts;

  void addContact(ContactModel contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void removeContact(ContactModel contact) {
    _contacts.remove(contact);
    notifyListeners();
  }

  void updateContact(ContactModel contact) {
    final index = _contacts.indexWhere((element) => element.id == contact.id);

    if (index != -1) {
      _contacts[index] = contact;
      notifyListeners();
    }
  }

  Future<void> loadContacts() async {
    _allContacts = await _dataBase.getAllContacts();
    _contacts = List.from(_allContacts);
    notifyListeners();
  }

  Future<void> saveContact(ContactModel contact) async {
    if (contact.id == -1) {
      contact.id = await _dataBase.insert(contact);
    } else {
      await _dataBase.update(contact);
    }

    await loadContacts();
  }

  void toggleFavorite(ContactModel contact) {
    final index = _allContacts.indexWhere(
      (element) => element.id == contact.id,
    );

    if (index != -1) {
      _allContacts[index].isFavorite = !_allContacts[index].isFavorite;

      _contacts = List.from(_allContacts);
      notifyListeners();
    }
  }

  void sortContacts(bool isAscending) {
    _contacts.sort((a, b) {
      if (isAscending) {
        return a.name.compareTo(b.name);
      } else {
        return b.name.compareTo(a.name);
      }
    });

    notifyListeners();
  }

  Future<ContactModel?> getContactById(int id) async {
    return await _dataBase.getContactById(id);
  }

  void searchContacts(String query) {
    if (query.isEmpty) {
      loadContacts();
      return;
    }

    final filteredContacts = _contacts.where((contact) {
      return contact.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    _contacts = filteredContacts;
    notifyListeners();
  }

  void loadFavorites() {
    _contacts = _allContacts.where((contact) => contact.isFavorite).toList();

    notifyListeners();
  }
}
