import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/widgets/success_toast.dart';
import '../bloc/daily_notes_bloc.dart';
import '../../../core/models/note_model.dart';
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
  bool _isLoading = false;

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

  void _onSave() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan tidak boleh kosong!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    if (isEditing) {
      final updatedNote = widget.note!.copyWith(
        content: _contentController.text.trim(),
      );
      context.read<DailyNotesBloc>().add(UpdateDailyNote(updatedNote));
    } else {
      // ✅ Buat note baru (id akan di-generate di backend)
      final newNote = Note(
        id: '', // ID akan di-set dari response API
        content: _contentController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      context.read<DailyNotesBloc>().add(AddDailyNote(newNote));
      
      // ✅ Show success toast
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
                message: 'Yeaayy, kamu udah tambah catatan hari ini! +5 XP',
              ),
            ),
          ),
        ),
      );

      overlay.insert(entry);
      Future.delayed(const Duration(seconds: 3), () => entry.remove());
    }

    // ✅ Tunggu sebentar sebelum pop
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _onDelete() async {
    if (!isEditing) return;

    // ✅ Confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Apakah kamu yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      context.read<DailyNotesBloc>().add(DeleteDailyNote(widget.note!.id));

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan berhasil dihapus!'),
            backgroundColor: Colors.redAccent,
          ),
        );
        Navigator.pop(context);
      }
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
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              onPressed: _onSave,
              icon: const Icon(Icons.save_outlined, color: Colors.black),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tuliskan Pengalamanmu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                autofocus: !isEditing,
                maxLines: null,
                expands: true,
                enabled: !_isLoading,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Tuliskan pengalamanmu...',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                child: CustomFilledButton(
                  title: _isLoading ? 'Menghapus...' : 'Hapus Catatan',
                  withShadow: false,
                  onPressed: _isLoading ? null : _onDelete,
                ),
              ),
          ],
        ),
      ),
    );
  }
}