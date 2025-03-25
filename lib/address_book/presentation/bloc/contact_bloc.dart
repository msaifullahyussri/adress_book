import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';
import '../../data/repositories/contact_repository.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository repository;

  ContactBloc(this.repository) : super(ContactInitial()) {
    // LOAD CONTACTS
    on<LoadContacts>((event, emit) async {
      emit(ContactLoading());
      try {
        final contacts = await repository.fetchContacts();
        emit(ContactLoaded(contacts));
      } catch (e) {
        emit(ContactError(e.toString()));
      }
    });

    // ADD CONTACT
    on<AddContact>((event, emit) async {
      emit(ContactLoading());
      try {
        await repository.addContact(event.contact);
        final contacts = await repository.fetchContacts();
        emit(ContactLoaded(contacts));
      } catch (e) {
        emit(ContactError(e.toString()));
      }
    });

    // UPDATE CONTACT
    on<UpdateContact>((event, emit) async {
      emit(ContactLoading());
      try {
        await repository.updateContact(event.contact);
        final contacts = await repository.fetchContacts();
        emit(ContactLoaded(contacts));
      } catch (e) {
        emit(ContactError(e.toString()));
      }
    });

    // DELETE CONTACT
    on<DeleteContact>((event, emit) async {
      emit(ContactLoading());
      try {
        await repository.deleteContact(event.id);
        final contacts = await repository.fetchContacts();
        emit(ContactLoaded(contacts));
      } catch (e) {
        emit(ContactError(e.toString()));
      }
    });

    // TOGGLE FAVORITE
    on<ToggleFavoriteContact>((event, emit) async {
      await repository.toggleFavorite(event.id);
      final contacts = await repository.fetchContacts();
      emit(ContactLoaded(contacts));
    });

  }
}
