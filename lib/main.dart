import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:roadside_unit/features/presentation/blocs/history/history_order_bloc.dart';
import 'package:roadside_unit/features/presentation/blocs/home/home_bloc.dart';

import 'core/routes/routes.dart';
import 'di/injector.dart';
import 'features/presentation/blocs/auth/auth_bloc.dart';
import 'features/presentation/blocs/order/order_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await initializeDependencies();
  runApp(const BlocApp());
}

class BlocApp extends StatelessWidget {
  const BlocApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => injector()..add(AuthInit())),
        BlocProvider<OrderBloc>(create: (_) => injector()),
        BlocProvider<HomeBloc>(create: (_) => injector()),
        BlocProvider<HistoryOrderBloc>(create: (_) => injector()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color materialColor = const Color(0x001cae81);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primaryColor: materialColor,
        colorScheme:
            ColorScheme.fromSwatch(brightness: Brightness.light).copyWith(
          secondary: materialColor.withOpacity(1),
        ),
        scaffoldBackgroundColor: Colors.white.withOpacity(1),
        primaryColor: Colors.white,
        indicatorColor: materialColor,

        iconTheme: const IconThemeData(color: Colors.black),
      ),
      onGenerateRoute: AppNavigator.onGenerateRoute,
      navigatorKey: AppNavigator.navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == AuthStatusBloc.unauthenticated) {
              Navigator.of(AppNavigator.navigatorKey.currentContext!)
                  .pushNamedAndRemoveUntil("/Login", (route) => false);
            }
          },
          child: child,
        );
      },
    );
  }
}
