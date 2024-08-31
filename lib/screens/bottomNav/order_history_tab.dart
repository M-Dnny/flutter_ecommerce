import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/order_model.dart';
import 'package:flutter_ecommerce/utils/contants.dart';
import 'package:flutter_ecommerce/utils/widgets/order_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderHistoryTab extends ConsumerStatefulWidget {
  const OrderHistoryTab({super.key});

  @override
  ConsumerState createState() => _OrderHistoryTabState();
}

class _OrderHistoryTabState extends ConsumerState<OrderHistoryTab> {
  List orderList =
      myOrderList.where((element) => element['status'] == 2).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: orderList.map(
          (e) {
            final order = OrderModel.fromJson(e);
            final orderStatus = order.status == 0
                ? "In Progress"
                : order.status == 1
                    ? "On the way"
                    : "Delivered";

            final orderStatusColor = order.status == 0
                ? Theme.of(context).primaryColor
                : order.status == 1
                    ? Colors.deepOrange
                    : Colors.green;

            return OrderCard(
                order: order,
                orderStatus: orderStatus,
                orderStatusColor: orderStatusColor);
          },
        ).toList(),
      ),
    );
  }
}
