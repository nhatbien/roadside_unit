part of "../home_page.dart";

class ButtonCancelWidget extends StatelessWidget {
  const ButtonCancelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.2,
      child: MaterialButton(
        onPressed: () {
          cancelReasonTable(context);
        },
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        color: Colors.red,
        shape: const StadiumBorder(),
        child: Text(
          'HỦY ĐƠN',
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Theme.of(context).primaryColor,
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

void cancelReasonTable(
  BuildContext context,
) {
  String? character;

  List<String> reasonString = [
    'Không liên hệ được với Khách ( Gọi > 5 lần)',
    'Đường không đi được',
    'KHÁC',
  ];
  final textController = TextEditingController();

  showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0.0),
            title: Center(
                child: Text(
              'Lý do',
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: List.generate(
                        reasonString.length,
                        // ignore: deprecated_member_use
                        (index) => MaterialButton(
                              onPressed: () {
                                setState(() {
                                  character = reasonString[index];
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    fillColor: MaterialStateProperty.all(
                                        Theme.of(context).hintColor),
                                    value: reasonString[index],
                                    groupValue: character,
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        character = value;
                                      });
                                    },
                                  ),
                                  Flexible(
                                    child: Text(reasonString[index],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ),
                                ],
                              ),
                            )),
                  ),
                  character == 'KHÁC'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 25,
                            controller: textController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Lý do khác...',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 12.5)),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              // ignore: deprecated_member_use
              ButtonTheme(
                  minWidth: 20,
                  child: MaterialButton(
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                          color: Theme.of(context).hintColor.withOpacity(1),
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
              // ignore: deprecated_member_use
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  return MaterialButton(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'GỬI',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold),
                        )),
                    onPressed: () {
                      if (character == null) {
                        Fluttertoast.showToast(
                          msg: 'Vui lòng chọn lý do',
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                        );
                      } else if (character == 'KHÁC' &&
                          textController.text == '') {
                        Fluttertoast.showToast(
                          msg: 'Vui lòng điền lý do',
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                        );
                      } else {
                        context.read<OrderBloc>().add(PutDeliveredCancelEvent(
                            orderId: state.order?.id ?? 0,
                            orderStatusId: 6,
                            reason: character ?? ""));
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                          msg: 'Đơn hàng ${state.order?.id} đã hủy',
                          backgroundColor: Colors.red,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                        );
                      }
                    },
                  );
                },
              )
            ],
          );
        });
      });
}
