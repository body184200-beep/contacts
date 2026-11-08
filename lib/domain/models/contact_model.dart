const String tableContacts = 'tbl_contacts';
const String columnId = 'id';
const String columnName = 'name';
const String columnEmail = 'email';
const String columnMobile = 'mobile';
const String columnAddress = 'address';
const String columnCompany = 'company';
const String columnWebsite = 'website';
const String columnDesignation = 'designation';
const String columnImage = 'image';
const String columnIsFavorite = 'is_favorite';

class ContactModel {
  int id;
  String name;
  String email;
  String mobile;
  String address;
  String company;
  String website;
  String designation;
  String image;
  bool isFavorite = false;

  ContactModel({
    this.id = -1,
    required this.name,
    required this.mobile,
    this.email = '',
    this.address = '',
    this.company = '',
    this.website = '',
    this.designation = '',
    this.image = '',
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      columnId: id,
      columnName: name,
      columnEmail: email,
      columnMobile: mobile,
      columnAddress: address,
      columnCompany: company,
      columnWebsite: website,
      columnDesignation: designation,
      columnImage: image,
      columnIsFavorite: isFavorite ? 1 : 0,
    };

    if (id > 0) {
      return {columnId: id};
    }
    return map;
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
    name: map[columnName],
    mobile: map[columnMobile],
    email: map[columnEmail],
    address: map[columnAddress],
    company: map[columnCompany],
    website: map[columnWebsite],
    designation: map[columnDesignation],
    image: map[columnImage],
    isFavorite: map[columnIsFavorite] == 1 ? true : false,
  );
}
