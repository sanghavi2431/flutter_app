import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:woloo_smart_hygiene/model/cart.dart';
// import 'package:woloo_smart_hygiene/widgets/boxes/cart_item.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';

import '../core/local/global_storage.dart';
import '../utils/app_textstyle.dart';
import 'bloc/b2b_store_bloc.dart';
import 'bloc/b2b_store_event.dart';

// import 'models/inventrory_error_model.dart';

class InventoryCheckoutBottomSheet extends StatelessWidget {
  // InventoryErrorModel ? inventoryErrorModel;
  List<Item> filteredCartItems;
  B2bStoreBloc? b2bStoreBloc;


  InventoryCheckoutBottomSheet(
      {required this.filteredCartItems, required this.b2bStoreBloc});
  // final List<Item> items = [
  //   Item(
  //     productTitle: "Feather Toilet Seat",
  //     variantTitle: "Size : M",
  //     quantity: 12,
  //     thumbnail: "assets/feather_img.png",
  //   ),
  //   // Add more items here
  // ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        //  color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(80.0),
          topRight: Radius.circular(80.0),
        ),
    
        color: Colors.white,
        // borderRadius:
        // BorderRadius.vertical(top: Radius.circular(20)), // top_corner_dialog_bg
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top indicator
          Container(
            width: 50,
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          

          // Header with image and text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   GestureDetector(
                              onTap: () {
                                 Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back_sharp)),
                              const SizedBox(
                                width: 20,
                              ),
                 
                Image.asset("assets/images/out_of_stock_img.jpeg",
                    width: 45, height: 45),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Oops! Just Missed It",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                     
                      ),
                      Text(
                        "Looks like this product sold out.\nDon’t worry: we’ll notify you when it’s restocked.",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // List of items (RecyclerView)
          ListView.builder(
            itemCount: filteredCartItems!.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // final item = items[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                            filteredCartItems![index].thumbnail!,
                            width: 52,
                            height: 52),
                       
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(filteredCartItems![index].productTitle ?? "",

                                // item.productTitle!,
                            Text(filteredCartItems![index].productTitle ?? "",

                                // item.productTitle!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const Divider(height: 6, color: Colors.grey),
                            Text(filteredCartItems![index].variantTitle!),
                            Text(filteredCartItems![index].quantity.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(filteredCartItems![index].quantity.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // const Icon(Icons.delete, size: 18),
                            // const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {

                                GlobalStorage globalStorage = GetIt.instance();
                                // Notify logic here
                                b2bStoreBloc!.add(
                                  RestockSubscriptionsEvent(
                                      phoneNumber:
                                          globalStorage.getClientMobileNo(),
                                      variantId:
                                          filteredCartItems![index].variantId!),
                                );

                              },
                              child:
                               Image.asset("assets/images/notify_icon_new.gif",
                                width: 50,
                                height: 50,
                               ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
