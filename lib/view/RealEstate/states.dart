import 'package:rct/view/RealEstate/modelget.dart';

abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataSuccess extends DataState {
  final List<Modelget> data;

  DataSuccess(
    this.data,
  );
}

class FavouriteSuccess extends DataState {
  final List<Modelget> data;

  FavouriteSuccess(this.data);
}

class DataError extends DataState {
  final String message;

  DataError(
    this.message,
  );

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}

class SearchSuccss extends DataState {}

class FilterSuccessState extends DataState {
  final List<Modelget> data;

  FilterSuccessState(this.data);
}

class FilterFailedState extends DataState {
  final String message;

  FilterFailedState(this.message);

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}

class FilterloadingssState extends DataState {}

class SearchProductsEmptyState extends DataState {}

class FilterCategorySuccessState extends DataState {
  final List<Modelget> data;

  FilterCategorySuccessState(this.data);
}
