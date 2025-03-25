import '../../data/models/contact_model.dart';
import 'contact_event.dart';

abstract class ContactEvent {}

class LoadContacts extends ContactEvent {}

class AddContact extends ContactEvent {
  final ContactModel contact;
  AddContact(this.contact);
}

class UpdateContact extends ContactEvent {
  final ContactModel contact;
  UpdateContact(this.contact);
}

class DeleteContact extends ContactEvent {
  final String id;
  DeleteContact(this.id);
}

class ToggleFavoriteContact extends ContactEvent {
  final String id;
  ToggleFavoriteContact(this.id);
}
