part of '../home_page.dart';

class OrderButtonChangeStatus extends StatelessWidget {
  final bool? buttonHaftSize;
  final String? textTitle;
  final String? textContent;
  final Function? onPress;
  final OrderModel? con;
  const OrderButtonChangeStatus(
      {Key? key,
      this.buttonHaftSize,
      this.textContent,
      this.textTitle,
      this.onPress,
      this.con})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonHaftSize!
          ? MediaQuery.of(context).size.width / 2.2
          : MediaQuery.of(context).size.width - 40,
      // ignore: deprecated_member_use
      child: MaterialButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    textTitle ?? "",
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.9),
                        fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        textContent ?? "",
                        style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog

                    ButtonTheme(
                        minWidth: 20,
                        child: // ignore: deprecated_member_use
                            MaterialButton(
                                elevation: 2,
                                height: 30,
                                onPressed: onPress as void Function()?,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2),
                                    ),
                                    child: Text("Xác nhận",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.9),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))))),
                    ButtonTheme(
                        minWidth: 0,
                        child: // ignore: deprecated_member_use
                            MaterialButton(
                          child: Text('Hủy',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )),
                  ],
                );
              });
        },
        padding: const EdgeInsets.symmetric(vertical: 14),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.green.withOpacity(0.9)
            : Colors.green.withOpacity(0.9),
        shape: const StadiumBorder(),
        child: Text(
          textTitle?.toUpperCase() ?? "",
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Theme.of(context).primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5),
        ),
      ),
    );
  }
}
