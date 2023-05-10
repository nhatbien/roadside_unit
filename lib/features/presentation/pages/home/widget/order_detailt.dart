part of "../home_page.dart";

class OrderDetail extends StatefulWidget {
  final int orderId;
  const OrderDetail({super.key, required this.orderId});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  void initState() {
    context.read<OrderBloc>().add(GetOrder(widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey
              : Colors.green,
          elevation: 0,
          centerTitle: true,
          title: const Text("Chi tiết đơn hàng"),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey
            : Colors.green,
        body: Stack(children: [
          _buildBody(),
        ]));
  }

  Widget _buildBody() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state.status == OrderStatusBloc.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == OrderStatusBloc.success) {
          return Stack(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildPeriodEdit("Xe hơi"),
                  const SizedBox(height: 18),
                  _buildBreeding(state.order?.user ?? User()),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildAddress(state.order!),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            BottomOrderWidget(
              order: state.order!,
            )
          ]);
        } else if (state.status == OrderStatusBloc.failure) {
          return const Center(
            child: Text(""),
          );
        } else {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
      },
    );
  }

  Widget _buildPeriodEdit(String description) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 8),
            blurRadius: 23,
          )
        ],
      ),
      child: Text(
        " Loại xe:  $description",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildBreeding(User user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 8),
            blurRadius: 23,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(child: _Label('Tên')),
              Expanded(
                flex: 3,
                child: Text(user.fullName ?? "",
                    style: const TextStyle(height: 0.8, fontSize: 18)),
              )
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Expanded(child: _Label('SĐT')),
              Expanded(
                flex: 2,
                child: Text(user.phone?.replaceFirst('+84', '0') ?? "",
                    style: const TextStyle(height: 0.8, fontSize: 18)),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse("tel:${user.phone}"));
                  },
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 35,
                  ),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(OrderModel order) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 8),
            blurRadius: 23,
          )
        ],
      ),
      child: ListTile(
        minLeadingWidth: 0,
        dense: true,
        leading: const SizedBox(
          height: 30,
          width: 30,
          child: Icon(
            Icons.location_on_outlined,
            size: 15,
          ),
        ),
        title: Text(order.address ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(
                fontSize: 18,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).hintColor))),
        trailing: IconButton(
          onPressed: (() => {
                openMapsSheetCustomer(order),
              }),
          icon: const Icon(
            Icons.directions,
            size: 30,
          ),
          color: Colors.green,
        ),
      ),
    );
  }

  void openMapsSheetCustomer(OrderModel order) async {
    double destinationLatitude;
    double destinationLongitude;
    double originLatitude;
    double originLongitude;
    String destinationTitle;
    String originTitle;
    try {
      destinationLatitude = order.lat ?? 0;
      destinationLongitude = order.lng ?? 0;
      destinationTitle = order.address ?? '';
      originLatitude =
          context.read<AuthBloc>().state.currentLocation?.latitude ?? 0;
      originLongitude =
          context.read<AuthBloc>().state.currentLocation?.longitude ?? 0;
      originTitle = "vị trí của bạn";
      DirectionsMode directionsMode = DirectionsMode.driving;

      final availableMaps = await MapLauncher.installedMaps;

      // ignore: use_build_context_synchronously
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 5, bottom: 10, left: 10, right: 10),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    availableMaps.length,
                    (index) => ListTile(
                        onTap: () {
                          availableMaps[index].showDirections(
                            destination: Coords(
                              destinationLatitude,
                              destinationLongitude,
                            ),
                            destinationTitle: destinationTitle,
                            origin: Coords(originLatitude, originLongitude),
                            originTitle: originTitle,
                            directionsMode: directionsMode,
                          );
                        },
                        title: Shimmer.fromColors(
                            baseColor: Theme.of(context).hintColor,
                            highlightColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                            period: const Duration(milliseconds: 1200),
                            child: Text(
                                '\t\t\tLỘ TRÌNH\n\t\t\t(${availableMaps[index].mapName})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ))),
                        leading: Image.asset(
                          'assets/img/img/map.png',
                          width: 70,
                          height: 70,
                        )),
                  )),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }
}

class _Label extends Text {
  _Label(String text)
      : super(
          text,
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
            height: 0.8,
          ),
        );
}
