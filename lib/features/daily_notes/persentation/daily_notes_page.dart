import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/daily_notes/persentation/add_edit_note_page.dart';
import 'package:mintrix/widgets/notes_card.dart';
import '../bloc/daily_notes_bloc.dart';
import '../models/note_model.dart';

class DailyNotesPage extends StatelessWidget {
  const DailyNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DailyNotesBloc()..add(LoadDailyNotes()),
      child: const _DailyNotesView(),
    );
  }
}

class _DailyNotesView extends StatelessWidget {
  const _DailyNotesView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DailyNotesBloc, DailyNotesState>(
      listener: (context, state) {
        if (state is DailyNotesLoaded) {
          // setelah menambah/menghapus, halaman otomatis refresh
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF5F8FF),
        appBar: AppBar(
          backgroundColor: const Color(0xffF5F8FF),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Catatan Harian',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<DailyNotesBloc, DailyNotesState>(
                  builder: (context, state) {
                    if (state is DailyNotesLoading ||
                        state is DailyNotesInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DailyNotesLoaded) {
                      return _buildNotesGrid(context, state.notes);
                    } else if (state is DailyNotesError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return const Center(child: Text("Something went wrong!"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari catatan...',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        // opsional: logika search
      },
    );
  }

  Widget _buildNotesGrid(BuildContext context, List<Note> notes) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: notes.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildAddNoteCard(context);
        }
        final note = notes[index - 1];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<DailyNotesBloc>(context),
                  child: AddEditNotePage(note: note),
                ),
              ),
            );
          },
          child: NoteCard(date: note.date, content: note.content),
        );
      },
    );
  }

  Widget _buildAddNoteCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<DailyNotesBloc>(context),
              child: const AddEditNotePage(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: const DecorationImage(
            image: AssetImage('assets/images/notes_card.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 48,
            color: Color.fromARGB(255, 20, 205, 238),
          ),
        ),
      ),
    );
  }
}
