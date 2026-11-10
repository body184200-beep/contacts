import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../domain/data/provider/contact_provider.dart';

void fetchContacts(int index, BuildContext context) {
  final provider = Provider.of<ContactProvider>(context, listen: false);

  switch (index) {
    case 0:
      provider.loadContacts();
      break;

    case 1:
      provider.loadFavorites();
      break;
  }
}
