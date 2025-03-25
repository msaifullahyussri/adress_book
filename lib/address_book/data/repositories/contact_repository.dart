import '../../core/database.dart';
import '../models/contact_model.dart';

class ContactRepository {
  final dbHelper = DatabaseHelper.instance;

  // Fetch semua contacts dari database
  Future<List<ContactModel>> fetchContacts() async {
    final contacts = await dbHelper.getContacts();
    return contacts.map((json) => ContactModel.fromJson(json)).toList();
  }

  // Add contact ke database
  Future<void> addContact(ContactModel contact) async {
    await dbHelper.insertContact(contact.toJson());
  }

  // Update contact dalam database
  Future<void> updateContact(ContactModel contact) async {
    await dbHelper.updateContact(contact.toJson());
  }

  // Delete contact berdasarkan id
  Future<void> deleteContact(String id) async {
    await dbHelper.deleteContact(id);
  }

  // Update favourite status
  Future<void> toggleFavorite(String id) async {
    final db = await dbHelper.database;
    final contactData = await db.query('contacts', where: 'id = ?', whereArgs: [id]);
    if (contactData.isNotEmpty) {
      final currentFavorite = contactData.first['isFavorite'] as int;
      final newFavoriteStatus = currentFavorite == 1 ? 0 : 1;
      await db.update(
        'contacts',
        {'isFavorite': newFavoriteStatus},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

}
