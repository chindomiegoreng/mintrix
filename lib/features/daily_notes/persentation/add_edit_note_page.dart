import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:mintrix/widgets/success_toast.dart';
import '../bloc/daily_notes_bloc.dart';
import '../models/note_model.dart';
import 'package:mintrix/widgets/buttons.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late final TextEditingController _contentController;
  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan tidak boleh kosong!')),
      );
      return;
    }
    if (isEditing) {
      final updatedNote = Note(
        id: widget.note!.id,
        date: widget.note!.date,
        content: _contentController.text,
      );
      context.read<DailyNotesBloc>().add(UpdateDailyNote(updatedNote));
    } else {
      final newNote = Note(
        id: Random().nextInt(100000).toString(),
        date: DateFormat('dd/MM').format(DateTime.now()),
        content: _contentController.text,
      );
      context.read<DailyNotesBloc>().add(AddDailyNote(newNote));
      final overlay = Overlay.of(context);
      final entry = OverlayEntry(
        builder: (context) => Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: SuccessToast(
                message: 'Yeaayy, kamu udah tambah catatan hari ini!',
              ),
            ),
          ),
        ),
      );

      overlay.insert(entry);
      Future.delayed(const Duration(seconds: 3), () => entry.remove());
    }

    Navigator.pop(context);
  }

  void _onDelete() {
    if (isEditing) {
      context.read<DailyNotesBloc>().add(DeleteDailyNote(widget.note!.id));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil dihapus!'),
          backgroundColor: Colors.redAccent,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F8FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'Edit Catatan' : 'Catatan Baru',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _onSave,
            icon: const Icon(Icons.save_outlined, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tuliskan Pengalamanmu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                autofocus: true,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Tuliskan pengalamanmu...',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CustomFilledButton(
                  title: 'Hapus Catatan',
                  height: 50,
                  withShadow: false,
                  onPressed: _onDelete,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
