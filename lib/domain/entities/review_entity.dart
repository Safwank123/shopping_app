import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String user;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewEntity({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  List<Object?> get props => [id];
}