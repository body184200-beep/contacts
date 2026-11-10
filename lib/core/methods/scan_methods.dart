import '../utils/constants.dart';

void getProertyValue(
  String value,
  String property,
  Function(String, String) onChanged,
) {
  switch (property) {
    case ContactProperties.name:
    case ContactProperties.email:
    case ContactProperties.mobile:
    case ContactProperties.address:
    case ContactProperties.website:
    case ContactProperties.company:
    case ContactProperties.designation:
      onChanged(property, value);
      break;
  }
}
