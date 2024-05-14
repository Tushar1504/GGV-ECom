import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/data_sources/remote/sqlite.dart';
import '../../../data/models/cart_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final DataBaseHelper _dataBaseHelper;

  CartBloc({required DataBaseHelper dataBaseHelper})
      : _dataBaseHelper = dataBaseHelper,
        super(CartInitial()) {
    on<FetchCartItemEvent>((event, emit) async {
      emit(CartScreenLoadingState());
      try {
        final items = await _dataBaseHelper.getCartItem();
        print('Fetched Items: $items');
        emit(CartScreenLoadedState(cartItems: items));
      } catch (e) {
        emit(CartErrorState("Failed to load products!!!"));
        print('Error fetching Items: $e');
      }
    });

    on<CartItemUpdateEvent>((event, emit) async {
      emit(CartScreenLoadingState());
      try {
        final id = await _dataBaseHelper.updateCartItem(event.id, event.product, event.description, event.amount);
        final items = await _dataBaseHelper.getCartItem();
        emit(CartItemUpdateState(id));
        print('Updated $id');
        emit(CartScreenLoadedState(cartItems: items));
        print('Updated $items');
      } catch (e) {
        emit(CartErrorState('Failed to Update the items!!!'));
      }
    });

    on<CartItemDeleteEvent>((event, emit) async {
      emit(CartScreenLoadingState());
      try {
        await _dataBaseHelper.deleteCartItem(event.id);
        final items = await _dataBaseHelper.getCartItem();
        emit(CartItemDeleteState(event.id));
        emit(CartScreenLoadedState(cartItems: items));
      } catch (e) {
        emit(CartErrorState("Failed to Deleted Item!!!"));
      }
    });

    on<AddCartItemEvent>((event, emit) async {
      emit(CartScreenLoadingState());
      try {
        final id = await _dataBaseHelper.createCartItem(event.items);
        print('Added Items: $id');
        final items = await _dataBaseHelper.getCartItem();
        emit(CartItemAddedState(id));
        emit(CartScreenLoadedState(cartItems: items));
      } catch (e) {
        emit(CartErrorState("Something went wrong failed to add items!"));
      }
    });

    on<CartItemAddedOnClickedEvent>((event, emit) async {
      emit(CartScreenLoadingState());
      try {
        final id = await _dataBaseHelper.addToCart(event.clickedItem);
        emit(CartItemAddedOnClickedState(id));
      } catch (e) {
        emit(CartErrorState("Failed to add item!!!"));
      }
    });

    on<CartItemSearchEvent>((event, emit) async {
      emit(SearchLoadingState());
      try {
        final items = await _dataBaseHelper.searchCartItem(event.keywords);
        emit(CartScreenLoadedState(cartItems: items));
      } catch (e) {
        emit(CartErrorState("Failed to perform search"));
      }
    });
  }
}