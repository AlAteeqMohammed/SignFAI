import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signfai/src/Localization/app_localizations.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'card_builder.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeLoading) {
            circularProgress(context);
          }
          if (state is HomeSuccess) {
            Navigator.pop(context);
          }
          if (state is HomeFailure) {
            Navigator.pop(context);
            showSnackBar(
                context: context,
                message: "Try again later",
                duration: 3,
                icon: Icons.error_outline);
          }
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.black,
              body: DefaultTabController(
                length: 3,
                child: Scaffold(
                    appBar: AppBar(
                      iconTheme: const IconThemeData(color: Colors.white),
                      leading: IconButton(
                        icon: const Icon(Icons.translate),
                        onPressed: () {
                          HomeCubit.get(context).langChange(context);
                        },
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            HomeCubit.get(context).logout(context);
                          },
                        )
                      ],
                      bottom: TabBar(
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        indicatorWeight: 5,
                        tabs: [
                          Tab(
                              child: Text(
                            AppLocalizations.of(context).translate('letters')!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                          Tab(
                              child: Text(
                            AppLocalizations.of(context).translate('words')!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                          Tab(
                              child: Text(
                            AppLocalizations.of(context)
                                .translate('sentences')!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ))
                        ],
                      ),
                      title: const Text(
                        "SIGNFAI",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: primaryColor,
                      centerTitle: true,
                    ),
                    body: const TabBarView(
                      children: [
                        CardBuilder(tap: 0),
                        CardBuilder(tap: 1),
                        CardBuilder(tap: 2),
                      ],
                    )),
              ));
        },
      ),
    );
  }
}
