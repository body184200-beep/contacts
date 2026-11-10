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

  Future<void> removeContact(ContactModel contact) async {
    if (contact.id > 0) {
      await _dataBase.delete(contact.id);
    }
    _allContacts.removeWhere((element) => element.id == contact.id);
    _contacts.removeWhere((element) => element.id == contact.id);
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
    if (contact.id <= 0) {
      contact.id = await _dataBase.insert(contact);
    } else {
      await _dataBase.update(contact);
    }

    await loadContacts();
  }

  Future<void> toggleFavorite(ContactModel contact) async {
    contact.isFavorite = !contact.isFavorite;

    if (contact.id > 0) {
      await _dataBase.update(contact);
    }

    final index = _allContacts.indexWhere((element) => element.id == contact.id);
    if (index != -1) {
      _allContacts[index] = contact;
    }

    final contactIndex = _contacts.indexWhere((element) => element.id == contact.id);
    if (contactIndex != -1) {
      _contacts[contactIndex] = contact;
    }

    notifyListeners();
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
    if (query.trim().isEmpty) {
      _contacts = List.from(_allContacts);
      notifyListeners();
      return;
    }

    final filteredContacts = _allContacts.where((contact) {
      return contact.name.toLowerCase().contains(query.toLowerCase()) ||
          contact.mobile.contains(query);
    }).toList();

    _contacts = filteredContacts;
    notifyListeners();
  }

  void loadFavorites() {
    _contacts = _allContacts.where((contact) => contact.isFavorite).toList();
    notifyListeners();
  }
}
