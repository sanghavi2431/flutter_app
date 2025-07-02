import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/login_flow.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/order_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_collections.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/review.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/wishlist.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/checkout.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/favorite.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/login_reg_flow.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/order_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/product.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/woloo_points_service.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/hygine_services/view/address_notifier.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';

import 'b2b_store_event.dart';
import 'b2b_store_state.dart';

class B2bStoreBloc extends Bloc<B2BStoreEvent, B2BStoreState> {
  final box = GetStorage();
  List<Map<String, String>> favIds = [];
  final LoginFlowService loginFlowService =
      LoginFlowService(dio: GetIt.instance());

  final ProductService _productService = ProductService(dio: GetIt.instance());
  final AddressService _addresstService = AddressService(dio: GetIt.instance());
  final CartApiService _cartService = CartApiService(dio: GetIt.instance());
  final CheckoutApiService _checkoutApiService =
      CheckoutApiService(dio: GetIt.instance());
  final OrderDetailsService _orderDetailsService =
      OrderDetailsService(dio: GetIt.instance());
  final FavoriteService _favoriteService =
      FavoriteService(dio: GetIt.instance());
  final WolooPointsService _wolooPointsService =
      WolooPointsService(dio: GetIt.instance());

  var requestId = '';
  late int roleId;
  late int janitorId;

  B2bStoreBloc() : super(B2BStoreInitial()) {
    on<StoreCustomersReq>(_emailPassRegister);
    on<StoreCustomerLoginReq>(_emailPassLogin);
    on<AddressReq>(_createAddress);
    on<GetAddress>(_getAddress);
    on<UpdateAddressReq>(_updateAddress);
    on<GetCartData>(_getCart);
    on<AddToCart>(_addToCart);
    on<ProceedToShip>(_proceedToSheep);
    on<ApplyWolooPointsEvent>(_applyWolooPoints);
    on<RemoveWolooPointsEvent>(_removeWolooPoints);
    on<Payment>(_proceedToCheckOut);
    on<AddRemoveItemReq>(_addRemoveItems);
    on<PlaceOrder>(_placeOrder);
    on<DeleteItemReq>(_deleteItem);

    on<OrderDetailsEvent>(_getOrderDetails);
    on<SelectAddress>(_selectAddress);
    on<WishlistEvent>(_getWishlist);
    on<AddToWishList>(_addWishlist);
    on<ReviewEvent>(_addReview);
    on<DeleteAddress>(_deleteAddress);
    on<RemoveWishList>(_removeFromWishlist);
    on<GetOrderReview>(getProductReviews);
    on<Refresh>(_refresh);
    on<RestockSubscriptionsEvent>(restockSubscriptions);
    on<ApplyPromoEvent>(_applyPromoCode);
    on<RemovePromoCodeEvent>(_removePromoCode);
    on<SearchProductEvent>(_searchQuery);
    on<GetProductCategoriesEvent>(_getProductCategories);
    on<GetProductsByCategoryEvent>(_getProductsByCategory);
  }

  FutureOr<void> _emailPassRegister(
    StoreCustomersReq event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const B2BStoreLoading(message: "Loading data..."));
      var response = StoreCustomersRes();
      await loginFlowService
          .emailPassRegister(email: event.email, pass: event.pass)
          .then((v) async {
        box.write('email_pass_register_jwt', v);
        response =
            await loginFlowService.createCustomer(email: event.email, token: v);
        box.write('store_customers_id', response.customer!.id);
      });
      debugPrint("requestId $response");
      print(response);
      await loginFlowService
          .loginCustomer(
        email: event.email,
        pass: event.pass,
      )
          .then((loginToken) async {
        await _favoriteService.createFavorites(token: loginToken);
        final regionResponse =
            await _productService.getRegion(token: loginToken);
        box.write('region_id', regionResponse.regions![0].id);
        await _productService
            .createCart(
                token: loginToken,
                regionId: regionResponse.regions![0].id.toString())
            .then((cartData) {
          box.write('cart_id', cartData.cart.id);
        });
      });

      // _favoriteService.createFavorites(token: token);
      // emit(B2BStoreSuccess());
    } catch (e) {
      emit(B2BStoreError(error: e.toString()));
      debugPrint("Error in IOT service: $e");
    }
  }

  FutureOr<void> _emailPassLogin(
    StoreCustomerLoginReq event,
    Emitter<B2BStoreState> emit,
  ) async {
    // try {
    ProductCategory categories = ProductCategory();
    TopBrands topBrands = TopBrands();
    ProductCollections productCollections = ProductCollections();
    CartModel? cartModel;
    Wishlist? fav;
    emit(const B2BStoreLoading(message: "Loading data..."));

    // Login and get token\

    if (event.isfromlogin!) {
      final loginToken = await loginFlowService.loginCustomer(
        email: event.email ?? '',
        pass: event.pass ?? '',
      );
      box.write('login_jwt', loginToken);
    } else {
      final loginToken = await loginFlowService.loginCustomer(
        email: event.email ?? '',
        pass: event.pass ?? '',
      );
      box.write('login_jwt', loginToken);

      // Get region
      final regionResponse = await _productService.getRegion(token: loginToken);

      final cartId = box.read('cart_id');
      box.write('region_id', regionResponse.regions![0].id);
      // if (cartId == null) {
      await _productService
          .createCart(
              token: loginToken,
              regionId: regionResponse.regions![0].id.toString())
          .then((cartData) {
        box.write('cart_id', cartData.cart.id);
      });
      // }

      // //logger.w("Token: ${box.read('login_jwt')}");
      // //logger.w("Cart Id: ${box.read('cart_id')}");
      cartModel = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));

      // Fetch all required data
      categories =
          await _productService.getProductCategories(token: loginToken);
      topBrands = await _productService.getTopBrands(token: loginToken);
      productCollections =
          await _productService.getProductCollections(token: loginToken);

      fav = await _favoriteService.getFavorites(token: loginToken);

      favIds = getCommonProductIds(fav, productCollections);
    }

    final address = box.read('address');
    // Debug prints
    selectedAddress.value =
        address != null ? Addresses.fromJson(jsonDecode(address)) : Addresses();
    // Emit success state
    if (emit.isDone) return;
    emit(B2BStoreSuccess(B2BStoreHomePage(
        productCategory: categories,
        topBrands: topBrands,
        productCollections: productCollections,
        cartData: cartModel!,
        fav: fav!)));
    // } catch (e) {
    //   if (emit.isDone) return;
    //   emit(B2BStoreError(error: e.toString()));
    //   //logger.w("Login service: $e");
    //   debugPrint("Error in IOT service: $e");
    // }
  }

  FutureOr<void> _refresh(
    Refresh event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      ProductCategory categories = ProductCategory();
      TopBrands topBrands = TopBrands();
      ProductCollections productCollections = ProductCollections();

      emit(const B2BStoreLoading(message: "Loading data..."));

      // // Login and get token
      // final loginToken = await loginFlowService.loginCustomer(
      //   email: event.email,
      //   pass: event.pass,
      // );
      final loginToken = box.read('login_jwt');

      // Get region
      final regionResponse = await _productService.getRegion(token: loginToken);
      box.write('region_id', regionResponse.regions![0].id);

      CartModel cartModel = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));

      // Fetch all required data
      categories =
          await _productService.getProductCategories(token: loginToken);
      topBrands = await _productService.getTopBrands(token: loginToken);
      if (event.id != null) {
        productCollections = await _productService.getProductCollectionsById(
            slug: event.slug, token: loginToken, id: event.id!);
      } else {
        productCollections =
            await _productService.getProductCollections(token: loginToken);
      }

      final fav = await _favoriteService.getFavorites(token: loginToken);

      favIds = getCommonProductIds(fav, productCollections);

      // Emit success state
      if (emit.isDone) return;
      emit(B2BStoreSuccess(B2BStoreHomePage(
          productCategory: categories,
          topBrands: topBrands,
          productCollections: productCollections,
          cartData: cartModel,
          fav: fav)));
    } catch (e) {
      if (emit.isDone) return;
      emit(B2BStoreError(error: e.toString()));
      //logger.e("Error in IOT service: $e");
    }
  }

  FutureOr<void> _createAddress(
    AddressReq event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const B2BStoreLoading(message: "Loading data..."));
      AddAddressResBody response = await _addresstService.addAddress(
          body: AddAddressReqBody(
            first_name: event.first_name,
            last_name: event.last_name,
            address_1: event.address_1,
            city: event.city,
            phone_number: event.phone_number,
            postal_code: event.pincode,
            province: event.province,
            address_name: event.address_name,
          ),
          token: box.read('login_jwt'));

      debugPrint("requestId $response");
      print(response);
      // emit(B2BStoreSuccess());
      emit(AddAddressSuccess(addAddressResBody: response));
    } catch (e) {
      emit(B2BStoreError(error: e.toString()));
      debugPrint("Error in IOT service: $e");
    }
  }

  FutureOr<void> _updateAddress(
    UpdateAddressReq event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const B2BStoreLoading(message: "Loading data..."));
      AddAddressResBody response = await _addresstService.updateAddress(
          body: event.addressReqBody,
          token: box.read('login_jwt'),
          addressId: event.addressId);

      debugPrint("requestId $response");
      print(response);
      // emit(B2BStoreSuccess());
      emit(AddAddressSuccess(addAddressResBody: response));
    } catch (e) {
      emit(B2BStoreError(error: e.toString()));
      debugPrint("Error in IOT service: $e");
    }
  }

  FutureOr<void> _getAddress(
    GetAddress event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const B2BStoreLoading(message: "Loading data..."));
      AddressesData response =
          await _addresstService.getAllAddress(token: box.read('login_jwt'));

      debugPrint("requestId $response");
      print(response);
      // emit(B2BStoreSuccess());
      emit(GetAddressSuccess(addressesData: response));
    } catch (e) {
      emit(B2BStoreError(error: e.toString()));
      debugPrint("Error in IOT service: $e");
    }
  }

  FutureOr<void> _deleteAddress(
      DeleteAddress event, Emitter<B2BStoreState> emit) async {
    emit(const PostAddressLoading(message: "Loading...."));
    try {
      final val = await _addresstService.deleteAddress(
          addressId: event.addressId, token: box.read('login_jwt'));

      AddressesData response =
          await _addresstService.getAllAddress(token: box.read('login_jwt'));

      debugPrint("requestId $response");
      // print(response);
      // emit(B2BStoreSuccess());
      emit(GetAddressSuccess(addressesData: response));
    } catch (e) {
      //logger.e("Address Delete Bloc Issue: $e");
    }
  }

  FutureOr<void> _selectAddress(
      SelectAddress event, Emitter<B2BStoreState> emit) async {
    emit(const PostAddressLoading(message: "Loading...."));
    try {
      await _addresstService.selectAddress(
          cartId: box.read('cart_id'),
          shippingAddress: event.addresses,
          token: box.read('login_jwt'));
      emit(const PostAddressSuccess());
    } catch (e) {
      //logger.w("Error in Select Address: $e");
    }
  }

  List<Map<String, String>> getCommonProductIds(
      Wishlist wishlist, ProductCollections productCollections) {
    List<Map<String, String>> wishlistProductIds = wishlist.wishlist?.items
            ?.map((item) => <String, String>{
                  item.productVariant?.productId ?? '': item.id ?? ''
                })
            .toList() ??
        [];
    List<String> collectionProductIds = productCollections.products
        .map((product) => product.id)
        .whereType<String>()
        .toList();

    return wishlistProductIds
        .where((id) => collectionProductIds.contains(id.entries.first.key))
        .toList();
  }

  FutureOr<void> _getCart(
    GetCartData event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const CartLoading(message: "Loading data..."));

      // Get cart data
      CartModel response = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));

      // Get Woloo points in parallel
      int wolooPoints = 0;

      final wolooResponse = await _wolooPointsService.getWolooPoints();

      wolooPoints = wolooResponse.results.totalCoins.totalCoins;

      final productCollections = await _productService.getProductCollections(
          token: box.read('login_jwt'));

      emit(CartSuccess(
          cartData: response,
          productCollection: productCollections,
          wolooPoints: wolooPoints));
    } catch (e) {
      emit(CartError(error: e.toString()));
      debugPrint("Error in GetCart service: $e");
    }
  }

  FutureOr<void> _addRemoveItems(
    AddRemoveItemReq event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const CartLoading(message: "Loading data..."));
      CartModel response;
      if (event.count == 0) {
        await _cartService.deleteItem(
            itemId: event.itemId,
            token: box.read('login_jwt'),
            cartId: box.read('cart_id'));
        response = await _cartService.getAllCartData(
            token: box.read('login_jwt'), cartId: box.read('cart_id'));
      } else {
        response = await _cartService.addOrRemoveItem(
            itemId: event.itemId,
            count: event.count,
            token: box.read('login_jwt'),
            cartId: box.read('cart_id'));
      }

      int wolooPoints = 0;

      final wolooResponse = await _wolooPointsService.getWolooPoints();

      wolooPoints = wolooResponse.results.totalCoins.totalCoins;

      emit(CartSuccess(cartData: response, wolooPoints: wolooPoints));
    } catch (e) {
      emit(CartError(error: e.toString()));
      //logger.w("Error in bloc: $e");
      rethrow;
    }
  }

  FutureOr<void> _addToCart(
    AddToCart event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const B2BStoreLoading(message: "Loading data..."));
      emit(const CartLoading(message: "Loading data..."));
      AddToCartResponse res = await _cartService.addToCart(
        token: box.read('login_jwt'),
        cart_id: box.read('cart_id'),
        variant_id: event.variant_id,
        quantity: event.quantity,
      );

      // debugPrint("requestId $response");
      // print("Response Id: $response");
      CartModel response = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));

      debugPrint("requestId $response");
      print(response);

      int wolooPoints = 0;

      final wolooResponse = await _wolooPointsService.getWolooPoints();

      wolooPoints = wolooResponse.results.totalCoins.totalCoins;

      emit(CartSuccess(cartData: response, wolooPoints: wolooPoints));
      // emit(AddToCartSuccess(cartData: response));
    } catch (e) {
      emit(B2BStoreError(error: e.toString()));
      debugPrint("Error in ATC service: $e");
    }
  }

  FutureOr<void> _proceedToSheep(
    ProceedToShip event,
    Emitter<B2BStoreState> emit,
  ) async {
    emit(const CartLoading(message: "Proceed to cart"));
    try {
      //call on checkout button click then add delivery total at cart bottom sheet

      final shippingOptions = await _checkoutApiService.shippingOptions(
        cart_id: box.read('cart_id'),
        token: box.read('login_jwt'),
      );

      // final shippingOptionsCalculate =
      //     await _checkoutApiService.shippingOptionsCalculate(
      //   shipping_option: shippingOptions.shippingOptions!.first.id,
      //   token: box.read('login_jwt'),
      //   cart_id: box.read('cart_id'),
      // );

      final shippingMethods = await _checkoutApiService.shippingMethods(
          shipping_option:
              // shippingOptions.shippingOptions!.first.id,
              shippingOptions.shippingOptions!
                  .map<Map<String, dynamic>>((option) => {'id': option.id})
                  .toList(),
          token: box.read('login_jwt'),
          cart_id: box.read('cart_id'));

      emit(ReadyToShip(
        shippingDetails: shippingMethods,
      ) //completeVendor.orderSet.orders[0].items[0].total)
          );
    } catch (e) {
      emit(CartError(error: e.toString()));
    }
  }

  FutureOr<void> _proceedToCheckOut(
    Payment event,
    Emitter<B2BStoreState> emit,
  ) async {
    emit(const CartLoading(message: "Proceed to cart"));
    try {
      //call on checkout button click then add delivery total at cart bottom sheet
      {
        final shippingOptions = await _checkoutApiService.shippingOptions(
          cart_id: box.read('cart_id'),
          token: box.read('login_jwt'),
        );

        // final shippingOptionsCalculate =
        //     await _checkoutApiService.shippingOptionsCalculate(
        //   shipping_option: shippingOptions.shippingOptions!.first.id,
        //   token: box.read('login_jwt'),
        //   cart_id: box.read('cart_id'),
        // );

        final shippingMethods = await _checkoutApiService.shippingMethods(
            // TODO:
            /*
                    
                    curl --location -g '{{base-url}}/store/carts/{{cart-id}}/add-shipping-methods' \
            --header 'Content-Type: application/json' \
            --header 'x-publishable-api-key: {{publishable-api-key}}' \
            --header 'Authorization: Bearer {{customer-token}}' \
            --data '// Staging
            {
                "options": [
                    {
                        "id": "so_01JV4P2DWP2QJD9QCZSDJ0RPJN"
                    },
                    {
                        "id": "so_01JV4RA9FFC3203JWJN0RAB53J"
                    }
                ]
            }'



        */
            shipping_option:
                // shippingOptions.shippingOptions!.first.id,
                shippingOptions.shippingOptions!
                    .map<Map<String, dynamic>>((option) => {'id': option.id})
                    .toList(),
            token: box.read('login_jwt'),
            cart_id: box.read('cart_id'));
      }
      final paymentProviders = await _checkoutApiService.paymentProviders(
          token: box.read('login_jwt'), region_id: box.read('region_id'));

      final paymentCollections = await _checkoutApiService.paymentCollections(
          token: box.read('login_jwt'), cart_id: box.read('cart_id'));

      final paymentSessions = await _checkoutApiService.paymentSessions(
          token: box.read('login_jwt'),
          pay_col: paymentCollections, //.paymentCollection?.id,
          provider_id: paymentProviders.paymentProviders[0].id);

      // final completeVendor = await _checkoutApiService.completeVendor(
      //     token: box.read('login_jwt'), cart_id: box.read('cart_id'));

      final orderId =
          paymentSessions.paymentCollection?.paymentSessions?[0].data?.id ??
              "0";

      // final placeOrder = await _checkoutApiService.placeOrder(
      //     token: box.read('login_jwt'), order_id: orderId);

      // emit(CartSuccess(cartData: CartModel()));
      emit(LetsTryState(
        orderId: orderId,
        totalPrice:
            paymentSessions.paymentCollection?.paymentSessions?[0].amount ?? 0,
      ) //completeVendor.orderSet.orders[0].items[0].total)
          );
    } catch (e) {
      emit(CartError(error: e.toString()));
    }
  }

  FutureOr<void> _placeOrder(
    PlaceOrder event,
    Emitter<B2BStoreState> emit,
  ) async {
    emit(const CartLoading(message: "Proceed to cart"));
    try {
      // final placeOrder = await _checkoutApiService.placeOrder(
      final cart_id = box.read('cart_id');
      //     token: box.read('login_jwt'),
      //     order_id: event.order_id);
      final completeVendor = await _checkoutApiService.completeVendor(
          token: box.read('login_jwt'), cart_id: cart_id);
      await _productService
          .createCart(
              token: box.read('login_jwt'), regionId: box.read('region_id'))
          .then((cartData) {
        box.write('cart_id', cartData.cart.id);
      });

//TODO:implement{curl -X POST -H "user-agent: Android/22110/10" -H "x-woloo-token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NjMxNjAsImlhdCI6MTc1MDk0MzI2NywibmJmIjoxNzUwOTQzMjY3LCJleHAiOjE3NTg3MTkyNjcsImlzcyI6Imh0dHBzOi8vd29sb28udmVyaWZpbm93LmNvbS9hcGkvdjEvbG9naW4iLCJzdWIiOiI2MzE2MCIsImp0aSI6IkFCQ0RFRkdISUpLIn0.GMP72gC_qLaBc39i-Nelv8bI3-iLKfE7FlrTu2RULTw" --data $'{"coins":10,"orderid":"ordset_01JYP5PDX9FZK1AT8R88WHJ9VD","type":"points"}' https://staging-api.woloo.in/api/blog/ecomCoinUpdate}

      // Check if Woloo coins were applied in the cart
      final bool isWolooPointsApplied =
          box.read(cart_id + "wolooPoints"); //; ?? false;
      if (isWolooPointsApplied) {
        try {
          // Get coins to redeem (max 10 or available)
          final wolooPointsResponse =
              await _wolooPointsService.getWolooPoints();
          int coins = wolooPointsResponse.results.totalCoins.totalCoins;
          if (coins > 10) coins = 10;
          // Get orderId from event or paymentSessions (already set above)
          final String orderId = event.order_id ?? "";
          // if (orderId.isNotEmpty ) {
          await _wolooPointsService.ecomCoinUpdate(
            coins: coins,
            orderId: orderId,
            type: 'points',
            // wolooToken: wolooToken,
          );
          // }
        } catch (e) {
          debugPrint('Error calling ecomCoinUpdate: $e');
        }
      }

      emit(PaymentSuccess(completeVendor: completeVendor));
    } catch (e) {
      await _productService
          .createCart(
              token: box.read('login_jwt'), regionId: box.read('region_id'))
          .then((cartData) {
        box.write('cart_id', cartData.cart.id);
      });
      emit(CartError(error: e.toString()));
    }
  }

  FutureOr<void> _deleteItem(
      DeleteItemReq event, Emitter<B2BStoreState> emit) async {
    emit(const CartLoading(message: "Proceed to cart"));
    try {
      await _cartService.deleteItem(
          itemId: event.itemId,
          token: box.read('login_jwt'),
          cartId: box.read('cart_id'));
      // //logger.w(response);
      CartModel response = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));

      int wolooPoints = 0;

      final wolooResponse = await _wolooPointsService.getWolooPoints();

      wolooPoints = wolooResponse.results.totalCoins.totalCoins;

      emit(CartSuccess(cartData: response, wolooPoints: wolooPoints));
    } catch (e) {
      //logger.e("Error in delete Item Bloc: $e");
      emit(CartError(error: e.toString()));
    }
  }

  FutureOr<void> _getOrderDetails(
    OrderDetailsEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    emit(const OrderDetailsLoading(message: 'Loading order details...'));
    try {
      OrderDetails orderDetails = await _orderDetailsService.getOrderDetails(
          token: box.read('login_jwt'));
      emit(OrderDetailsSuccess(orderDetailsData: orderDetails));
    } catch (e) {
      debugPrint("Error in getOrderDetails service: $e");
      emit(OrderDetailsError(error: e.toString()));
    }
  }

  FutureOr<void> _getWishlist(
    WishlistEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    emit(const WishlistLoading(message: 'Loading wishlist...'));
    try {
      Wishlist wishlist =
          await _favoriteService.getFavorites(token: box.read('login_jwt'));
      final productCollections = await _productService.getProductCollections(
          token: box.read('login_jwt'));
      favIds = getCommonProductIds(wishlist, productCollections);
      CartModel cartModel = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));

      emit(WishlistSuccess(
          wishlistData: wishlist,
          cartModel: cartModel,
          productCollections: productCollections));
    } catch (e) {
      debugPrint("Error in getFavorites service: $e");
      emit(WishlistError(error: e.toString()));
    }
  }

  FutureOr<void> _addWishlist(
    AddToWishList event,
    Emitter<B2BStoreState> emit,
  ) async {
    emit(const WishlistLoading(message: 'Loading wishlist...'));
    try {
      final wishlist = await _favoriteService.addToWishList(
          token: box.read('login_jwt'), variantId: event.variantId);
      final productCollections = await _productService.getProductCollections(
          token: box.read('login_jwt'));
      favIds = getCommonProductIds(wishlist, productCollections);
      CartModel cartModel = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));
      emit(WishlistSuccess(
          wishlistData: wishlist,
          cartModel: cartModel,
          productCollections: productCollections));
    } catch (e) {
      debugPrint("Error in getFavorites service: $e");
      emit(WishlistError(error: e.toString()));
    }
  }

  FutureOr<void> _removeFromWishlist(
      RemoveWishList event, Emitter<B2BStoreState> emit) async {
    emit(const WishlistLoading(message: 'Loading wishlist...'));
    try {
      Wishlist wishlist = await _favoriteService.removeItemFromWishlist(
          box.read('login_jwt'), event.itemId);
      final productCollections = await _productService.getProductCollections(
          token: box.read('login_jwt'));
      favIds = getCommonProductIds(wishlist, productCollections);
      CartModel cartModel = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));
      emit(WishlistSuccess(
          wishlistData: wishlist,
          cartModel: cartModel,
          productCollections: productCollections));
    } catch (e) {
      debugPrint("Error in getFavorites service: $e");
      emit(WishlistError(error: e.toString()));
    }
  }

  FutureOr<void> _addReview(
    ReviewEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    emit(const WishlistLoading(message: 'Loading wishlist...'));
    try {
      Review review = await _favoriteService.addReview(
          token: box.read('login_jwt'),
          product_id: event.product_id,
          rating: event.rating,
          comment: event.comment,
          line_item_id: event.line_item_id);
      // emit(WishlistSuccess(wishlistData: wishlist));
    } catch (e) {
      debugPrint("Error in getFavorites service: $e");
      // emit(WishlistError(error: e.toString()));
    }
  }

  FutureOr<void> getProductReviews(
    GetOrderReview getOrderReview,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const ReviewLoading(message: 'Loading product reviews...'));
      final response = await _orderDetailsService.getOrderReviews(
          token: box.read('login_jwt'), productId: getOrderReview.productId);
      final productCollections = await _productService.getProductCollections(
          token: box.read('login_jwt'));
      // //logger.w(response);
      emit(CustomerReviewSuccess(
          customerReview: response, productCollection: productCollections));
    } catch (e) {
      //logger.e("Error in getProductReviews: $e");
    }
  }

  FutureOr<void> restockSubscriptions(
    RestockSubscriptionsEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    GlobalStorage globalStorage = GetIt.instance();
    try {
      emit(const RestockSubscriptionsLoading(
          message: 'Restocking subscriptions...'));
      final response = await _productService.restockSubscriptions(
        token: box.read('login_jwt'),
        variantId: event.variantId,
        phoneNumber: globalStorage.getClientMobileNo(),
      );
      emit(RestockSubscriptionsSuccess(
        restockSubscriptions: response,
      ));
      //logger.w("Restock Subscriptions Response: $response");
    } catch (e) {
      emit(RestockSubscriptionsError(error: e.toString()));
      //logger.e("Error in restockSubscriptions: $e");
    }
  }

  FutureOr<void> _applyPromoCode(
    ApplyPromoEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const CartLoadingForPromo(message: "Applying promo code..."));

      // Validate promo code format if needed
      if (event.promoCode.trim().isEmpty) {
        emit(const PromoApplyError(error: "Please enter a valid promo code"));
        return;
      }

      // Call API to apply promo code
      final response = await _cartService.applyPromoCode(
        token: box.read('login_jwt'),
        cartId: box.read('cart_id'),
        promoCode: event.promoCode,
      );

      emit(PromoCodeSuccess(
          cartData: response, message: "Promo code applied successfully!"));
    } catch (e) {
      // Handle specific error cases
      final errorMessage =
          e is Exception ? e.toString() : "Failed to apply promo code";
      emit(PromoApplyError(error: errorMessage.replaceAll('Exception: ', '')));
      //logger.e("Error in applying promo code: $e");
    }
  }

  FutureOr<void> _removePromoCode(
    RemovePromoCodeEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const CartLoadingForPromo(message: "Removing promo code..."));

      // Call API to remove promo code
      final response = await _cartService.removePromoCode(
        token: box.read('login_jwt'),
        cartId: box.read('cart_id'),
        promoCode: event.promoCode,
      );

      emit(PromoCodeSuccess(
          cartData: response, message: "Promo code removed successfully!"));
    } catch (e) {
      // Handle specific error cases
      final errorMessage =
          e is Exception ? e.toString() : "Failed to remove promo code";
      emit(CartError(error: errorMessage.replaceAll('Exception: ', '')));
      //logger.e("Error in removing promo code: $e");
    }
  }

  FutureOr<void> _applyWolooPoints(
    ApplyWolooPointsEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const CartLoading(message: "Applying Woloo points..."));

      // Validate if user has points to apply
      final currentPoints = await _wolooPointsService.getWolooPoints();
      if (!currentPoints.success) {
        throw Exception('Failed to verify points balance');
      }
      if (currentPoints.results.totalCoins.totalCoins <= 0) {
        throw Exception('No points available to redeem');
      }

      // Apply points to cart
      final response = await _wolooPointsService.applyWolooPoints(
        token: box.read('login_jwt'),
        cartId: box.read('cart_id'),
      );

      // Get updated points balance after applying
      final wolooPointsResponse = await _wolooPointsService.getWolooPoints();
      // if (!wolooPointsResponse.success) {
      //   //logger.w('Failed to get updated points balance after applying points');
      // }

      emit(CartSuccess(
          cartData: response,
          wolooPoints: wolooPointsResponse.results.points,
          message: "Woloo points applied successfully!"));
    } catch (e) {
      final errorMsg = e is Exception
          ? e.toString().replaceAll('Exception: ', '')
          : 'Failed to apply Woloo points. Please try again.';
      emit(CartError(error: errorMsg));
      //logger.e("Error applying Woloo points: $e");
    }
  }

  FutureOr<void> _removeWolooPoints(
    RemoveWolooPointsEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const CartLoading(message: "Removing Woloo points..."));

      // Remove points from cart
      final response = await _wolooPointsService.removeWolooPoints(
        token: box.read('login_jwt'),
        cartId: box.read('cart_id'),
      );

      // Get updated points balance after removal
      final wolooPointsResponse = await _wolooPointsService.getWolooPoints();
      // if (!wolooPointsResponse.success) {
      //   //logger.w('Failed to get updated points balance after removing points');
      // }

      final currentPoints = await _wolooPointsService.getWolooPoints();

      emit(CartSuccess(
          cartData: response,
          wolooPoints: currentPoints.results.totalCoins.totalCoins,
          message: "Woloo points removed successfully!"));
    } catch (e) {
      final errorMsg = e is Exception
          ? e.toString().replaceAll('Exception: ', '')
          : 'Failed to remove Woloo points. Please try again.';
      emit(CartError(error: errorMsg));
      //logger.e("Error removing Woloo points: $e");
    }
  }

  FutureOr<void> _searchQuery(
    SearchProductEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const B2BStoreLoading(message: "Searching products..."));
      final response = await _productService.searchProducts(
        token: box.read('login_jwt'),
        regionId: box.read('region_id'),
        query: event.query,
      );
      emit(SearchProductSuccess(products: response.products));
    } catch (e) {
      emit(B2BStoreError(error: e.toString()));
      debugPrint("Error in search query service: $e");
    }
  }

  FutureOr<void> _getProductCategories(
    GetProductCategoriesEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const ProductCategoriesLoading(
          message: "Loading product categories..."));
      final response = await _productService.getProductCategories(
        token: box.read('login_jwt'),
      );
      emit(ProductCategoriesSuccess(productCategories: response));
    } catch (e) {
      emit(ProductCategoriesError(error: e.toString()));
      debugPrint("Error in get product categories service: $e");
    }
  }

  FutureOr<void> _getProductsByCategory(
    GetProductsByCategoryEvent event,
    Emitter<B2BStoreState> emit,
  ) async {
    try {
      emit(const ProductsByCategoryLoading(
          message: "Loading products by category..."));
      final response = await _productService.getProductsByCategoryId(
        token: box.read('login_jwt'),
        categoryId: event.categoryId,
      );
      emit(ProductsByCategorySuccess(products: response));
    } catch (e) {
      emit(ProductsByCategoryError(error: e.toString()));
      debugPrint("Error in get products by category service: $e");
    }
  }
}

class B2BStoreHomePage {
  ProductCategory productCategory;
  TopBrands topBrands;
  ProductCollections productCollections;
  CartModel cartData;
  Wishlist fav;
  B2BStoreHomePage(
      {required this.productCategory,
      required this.topBrands,
      required this.productCollections,
      required this.cartData,
      required this.fav});
}
