import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';

part 'orders_list_state.dart';

class OrdersListCubit extends Cubit<OrdersListState> {
  OrdersListCubit() : super(OrdersListInitial());
  final Crud _crud = Crud();
  Future fetchOrderList() async {
    emit(OrdersListLoading());
    try {
      final orders = await _crud.getRequest(linkOrders);
      print(orders);
      emit(OrdersListSuccess(orders["data"]));
    } catch (e) {
      emit(OrdersListFailure(e.toString()));
      print(e.toString());
    }
  }
}
