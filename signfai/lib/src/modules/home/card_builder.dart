import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signfai/src/modules/home/card_widget.dart';
import 'package:signfai/src/modules/home/cubit/home_cubit.dart';
import 'package:signfai/src/shared/styles/colors.dart';
import '../../models/data.dart';

class CardBuilder extends StatelessWidget {
  const CardBuilder({
    super.key,
    required this.tap,
  });

  final int tap;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return FutureBuilder<List<Data>?>(
          future: HomeCubit.get(context).loadData(tap),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 8,
                    backgroundColor: thirdColor,
                    color: primaryColor),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final apiData = snapshot.data;
              return GridView.count(
                crossAxisCount: 3,
                children: apiData!
                    .map((cardData) => CardWidget(cardData: cardData))
                    .toList(),
              );
            } else {
              return Center(
                  child: IconButton(
                      color: primaryColor,
                      iconSize: 40,
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        HomeCubit.get(context).refresh();
                      }));
            }
          },
        );
      },
    );
  }
}
