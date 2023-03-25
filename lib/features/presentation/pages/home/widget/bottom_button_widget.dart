import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../data/model/order/order_model.dart';
import '../../../blocs/order/order_bloc.dart';
import '../home_page.dart';
import 'order_icon_status_widget.dart';

class BottomOrderWidget extends StatelessWidget {
  final OrderModel order;
  const BottomOrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 10,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 5.0)
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            order.status == 1 || order.status == 2
                ? const ButtonCancelWidget()
                : const SizedBox(),
            order.status == 1 || order.status == 2
                ? const SizedBox(width: 5.0)
                : const SizedBox(),
            order.status == 1
                ? OrderButtonChangeStatus(
                    buttonHaftSize: true,
                    textTitle: "Đã xác nhận",
                    onPress: () {
                      context.read<OrderBloc>().add(PutDeliveredEvent(
                          orderId: order.id ?? 0, orderStatusId: 2));

                      Navigator.of(context).pop();
                    })
                : order.status == 2
                    ? OrderButtonChangeStatus(
                        buttonHaftSize: true,
                        textTitle: "Xác nhận đang đến",
                        textContent:
                            "Vui lòng xác nhận nếu bạn chuẩn bị cứu hộ cho khách",
                        onPress: () {
                          context.read<OrderBloc>().add(PutDeliveredEvent(
                              orderId: order.id ?? 0, orderStatusId: 3));
                          Navigator.of(context).pop();
                        })
                    : order.status == 3
                        ? OrderButtonChangeStatus(
                            buttonHaftSize: false,
                            textTitle: "Xác nhận đã hoàn thành cứu hộ",
                            textContent:
                                "Vui lòng xác nhận nếu bạn hoàn thành cứu hộ",
                            onPress: () {
                              context.read<OrderBloc>().add(PutDeliveredEvent(
                                  orderId: order.id ?? 0, orderStatusId: 4));
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(
                                msg: 'Đơn hàng ${order.id} đã hoàn tất',
                                backgroundColor: Colors.red,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                              );
                            })
                        : order.status == 4
                            ? GestureDetector(
                                onTap: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const OrderIconStatusOrder(
                                    text: 'Đơn hàng đã hoàn tất',
                                    icon: Icons.check_circle_outline,
                                    color: Colors.green),
                              )
                            : order.status == 5
                                ? MaterialButton(
                                    onPressed: () {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const OrderIconStatusOrder(
                                        text: 'Đơn hàng đã hủy',
                                        icon: Icons.check_circle_outline,
                                        color: Colors.red),
                                  )
                                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
