part of "../home_page.dart";

class OrderPendingWidget extends StatelessWidget {
  const OrderPendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (_, state) {
        return _buildTicket(state.orderPending);
      },
    );
  }

  Widget _buildTicket(
    List<OrderModel> tickets,
  ) {
    return ListView(
      children: [
        // Items
        ...List<Widget>.from(
          tickets.map(
            (e) => Builder(
              builder: (context) => OrderPage(
                iconColor: const Color.fromARGB(247, 64, 5, 75),
                order: e,
                onOrdersPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => OrderDetail(
                            orderId: e.id ?? 0,
                          ),
                        ),
                      )
                      .then((value) =>
                          context.read<HomeBloc>().add(GetOrderPending()));
                },
                //onPrintPressed: (e) => _onPrintPressed(context, e),
              ),
            ),
          ),
        ),

        // add Loading (circular progress indicator at the end),
        // if there are more items to be loaded
        if (tickets.isEmpty) ...[
          const SizedBox(),
        ] else ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: CupertinoActivityIndicator(),
          ),
        ]
      ],
    );
  }
}
