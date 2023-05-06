import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roadside_unit/features/data/model/order/order_model.dart';
import 'package:roadside_unit/features/presentation/blocs/auth/auth_bloc.dart';
import 'package:roadside_unit/features/presentation/blocs/home/home_bloc.dart';
import 'package:roadside_unit/features/presentation/blocs/order/order_bloc.dart';
import 'package:roadside_unit/features/presentation/pages/drawer/drawer_page.dart';
import 'package:roadside_unit/features/presentation/pages/home/widget/bottom_button_widget.dart';
import 'package:roadside_unit/features/presentation/pages/home/widget/order_page.dart';
import 'package:roadside_unit/features/presentation/pages/home/widget/order_widget.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';
part 'widget/order_pending_widget.dart';
part 'widget/order_waiting_widget.dart';
part 'widget/order_detailt.dart';
part 'widget/button_cancel_widget.dart';
part 'widget/button_change_status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    context.read<HomeBloc>().add(GetOrderPending());
    context.read<AuthBloc>().add(LocationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        drawer: const DrawerPage(),
        key: _key,
        appBar: buildAppBar(),
        body: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey
                  : Colors.green,
              appBar: TabBar(
                indicatorColor: Colors.black,
                indicator: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                ),
                labelColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary, //chu
                unselectedLabelColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white, //chu
                tabs: [
                  Tab(
                      child: Text(
                    "Đơn của bạn (${context.watch<HomeBloc>().state.orderPending.length})",
                  )),
                  Tab(
                      child: Text(
                          "Đơn chờ nhận (${context.watch<HomeBloc>().state.orderWaiting.length})")),
                ],
              ),
              body: const TabBarView(children: [
                OrderPendingWidget(),
                OrderWaitingWidget(),
              ]),
            )),
      ),
      BlocConsumer<HomeBloc, HomeState>(
          listenWhen: (previous, current) =>
              previous.loading != current.loading,
          listener: (context, state) {
            if (state.loading == HomeStatusBloc.failure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.messageError),
                backgroundColor: Colors.red,
              ));
            }
            if (state.loading == HomeStatusBloc.success) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Lấy đơn hàng thành công"),
                backgroundColor: Colors.white,
              ));
            }
          },
          buildWhen: (previous, current) => previous.loading != current.loading,
          builder: (context, state) {
            if (state.loading == HomeStatusBloc.loading) {
              return const Center(
                  child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3.0,
                ),
              ));
            }

            return const SizedBox();
          }),
    ]);
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      toolbarHeight: 75,
      leading: IconButton(
          icon: Icon(
            Icons.sort_outlined,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
          onPressed: () {
            _key.currentState?.openDrawer();
          }),
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.green,
      elevation: 0,
      centerTitle: true,
      title: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Container(
            decoration: state.isConnected == true
                ? BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 108, 239, 113),
                          blurRadius: 3,
                          offset: Offset(0, 0))
                    ],
                    borderRadius: BorderRadius.circular(70.0),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(70.0),
                  ),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
            child: FloatingActionButton.extended(
                highlightElevation: 50,
                elevation: 5,
                onPressed: (() {
                  if (state.isConnected == false) {
                    context.read<HomeBloc>().add(ConnectServer());
                  } else {
                    context.read<HomeBloc>().add(StopServer());
                  }
                }),
                heroTag: UniqueKey().toString(),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.black,
                label: Row(
                  children: [
                    Icon(
                      state.isConnected != true
                          ? Icons.location_off_rounded
                          : Icons.location_on_rounded,
                      size: 20,
                      color: state.isConnected != true
                          ? Colors.grey
                          : Colors.green,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      state.isConnected == true ? "Đã kết nối" : "Bật kết nối",
                      style: Theme.of(context).textTheme.titleMedium?.merge(
                          TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: state.isConnected != true ? 15 : 13)),
                    )
                  ],
                )),
          );
        },
      ),
      actions: <Widget>[
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          onPressed: () async {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogout());
                    },
                    icon: const Icon(Icons.logout),
                  )
                  /*  HomeAvatarWidget(),
                  HomeAvatarOnlineWidget(), */
                ],
              ),
              // const CheckOnlineWidget()
            ],
          ),
        ),
      ],
    );
  }
}
