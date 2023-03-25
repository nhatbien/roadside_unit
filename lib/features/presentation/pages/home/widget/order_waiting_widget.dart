part of "../home_page.dart";

class OrderWaitingWidget extends StatelessWidget {
  const OrderWaitingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous.count != current.count,
      builder: (_, state) {
        return _buildTicket(state.orderWaiting);
      },
    );
  }

  Widget _buildTicket(
    List<OrderModel> tickets,
  ) {
    print("so luong don cho ${tickets.length}");
    return ListView(
      children: [
        // Items
        ...List<Widget>.from(
          tickets.map(
            (e) => Builder(
              builder: (context) => OrdersWidget(
                iconColor: const Color.fromARGB(247, 64, 5, 75),
                order: e,
                onOrdersPressed: () => _onPrintPressed(context, e.id ?? 0),
              ),
            ),
          ),
        ),

        // add Loading (circular progress indicator at the end),
        // if there are more items to be loaded
        /*    if (tickets.isEmpty) ...[
          const SizedBox(),
        ] else ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: CupertinoActivityIndicator(),
          ),
        ] */
      ],
    );
  }

  Future<void> _onPrintPressed(BuildContext context, int orderId) async {
    context.read<HomeBloc>().add(SelectOrder(orderId));
  }
}
