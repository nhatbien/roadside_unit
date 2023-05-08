import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../data/model/order/order_model.dart';

class MyOrderHistoryItemWidget extends StatelessWidget {
  final OrderModel order;

  final Function() onTap;
  final bool statusFontSize;

  const MyOrderHistoryItemWidget(
      {super.key,
      required this.order,
      required this.onTap,
      required this.statusFontSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
              DateFormat('HH:mm').format(
                  DateTime.parse(order.updatedAt ?? DateTime.now().toString())
                      .toLocal()),
              style: Theme.of(context).textTheme.bodyMedium!.merge(TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Theme.of(context).hintColor,
                  ))),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ExpansionTile(
              collapsedIconColor: Theme.of(context).colorScheme.secondary,
              title: GestureDetector(
                onTap: onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInfPayMentAndPriority(context),
                    buildTypeAndStatusAndTotalPrice(context),
                  ],
                ),
              ),
              children: [
                buildPickUpAndDestinationLocationVillBike(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInfPayMentAndPriority(context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Text(order.id!.toString(),
          style: Theme.of(context).textTheme.bodyMedium!.merge(TextStyle(
                fontSize: 15,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).hintColor,
              ))),
    );
  }

  Widget buildTypeAndStatusAndTotalPrice(context) {
    return ListTile(
      leading: Icon(
        order.status == 4 ? Icons.check : Icons.close,
        color: order.status == 4 ? Colors.green : Colors.red,
        size: 30,
      ),
      title: Column(
        children: [
          Text(order.status == 4 ? "Thành công" : "Thất bại",
              style: Theme.of(context).textTheme.bodyMedium!.merge(TextStyle(
                  fontSize: 15,
                  color: order.status == 4 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold))),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Row(
              children: [
                Text("Khách hàng : ",
                    style: Theme.of(context).textTheme.bodyMedium!.merge(
                        const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))),
                Text(order.user?.fullName ?? "Không tên",
                    style: Theme.of(context).textTheme.bodyMedium!.merge(
                        TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold))),
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.circle,
                  size: 7,
                  color: Theme.of(context).focusColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text("Miễn phí",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall!.merge(
                          TextStyle(
                              fontSize: statusFontSize == true ? 18 : 15,
                              color: Colors.green,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPickUpAndDestinationLocationVillBike(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBar.builder(
              initialRating: order.stats ?? 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                /* setState(() {
                  ratingStats = rating;
                }); */
              },
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.secondary,
              size: 15,
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              child: Text(order.address ?? "",
                  style: Theme.of(context).textTheme.bodyMedium!.merge(
                      TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).hintColor))),
            ),
          ],
        ),
      ]),
    );
  }
}
