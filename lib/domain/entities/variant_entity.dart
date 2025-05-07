import 'package:equatable/equatable.dart';

class VariantEntity extends Equatable {
  final String id;
  final String name;
  final double priceDelta;

  const VariantEntity({
    required this.id,
    required this.name,
    required this.priceDelta,
  });

  @override
  List<Object?> get props => [id];
}