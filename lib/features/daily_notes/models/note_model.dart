import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String date;
  final String content;

  const Note({
    required this.id,
    required this.date,
    required this.content,
  });

  @override
  List<Object> get props => [id, date, content];
}