import 'package:flutter/material.dart';
import 'package:roadside_unit/features/data/model/order/order_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class OrderPage extends StatelessWidget {
  final OrderModel order;
  final bool isRemovable;
  final IconData? icon;
  final Color? iconColor;
  final void Function(OrderModel order)? onRemove;
  final void Function() onOrdersPressed;

  const OrderPage({
    Key? key,
    required this.order,
    required this.onOrdersPressed,
    this.isRemovable = false,
    this.onRemove,
    this.icon,
    this.iconColor,
/*     this.onPrintPressed,
 */
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsetsDirectional.only(
            start: 14, end: 14, bottom: 5, top: 5),
        height: MediaQuery.of(context).size.width / 3,
        child: Row(
          children: [
            _buildImage(context),
            _buildTitleAndDescription(),
            /*           _buildRemovableArea(),
         */
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 14),
      child: ClipRRect(
        child: InkWell(
          splashColor: Colors.red,
          onTap: () => _onOrdersPressed(context),
          child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: double.maxFinite,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Icon(
                    Icons.car_crash,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Expanded(
      child: InkWell(
        onTap: _onTapOrder,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                order.user?.fullName ?? "",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Butler',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),

              // Description
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    order.address ?? "",
                    maxLines: 2,
                  ),
                ),
              ),
              // Datetim  e
              Row(
                children: [
                  const Icon(Icons.timeline_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd-MM-yyyy  kk:mm')
                        .format(DateTime.parse(order.createdAt!)),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemovableArea() {
    if (isRemovable) {
      return GestureDetector(
        onTap: _onRemove,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.delete, color: Colors.red),
        ),
      );
    }
    return Container();
  }

  void _onTapOrder() {
    if (onOrdersPressed != null) {
      onOrdersPressed();
    }
  }

  void _onOrdersPressed(BuildContext context) {
    onOrdersPressed();

    /* showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Thông báo"),
            content: const Text("Bạn muốn nhận đơn cứu hộ này ?"),
            actions: <Widget>[
              MaterialButton(
                child: Text(
                  "Đồng ý",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();

                  onOrdersPressed();
                },
              ),
              MaterialButton(
                child: Text(
                  "hủy",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }); */
  }

  void _onRemove() {
    if (onRemove != null) {
      onRemove!(order);
    }
  }
}
