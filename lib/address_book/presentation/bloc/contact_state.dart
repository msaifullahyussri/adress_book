import '../../data/models/contact_model.dart';

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<ContactModel> contacts;
  ContactLoaded(this.contacts);
}

class ContactError extends ContactState {
  final String message;
  ContactError(this.message);
}



