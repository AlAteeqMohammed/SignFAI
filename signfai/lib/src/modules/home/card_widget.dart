import 'package:flutter/material.dart';
import 'package:signfai/src/models/data.dart';
import 'package:signfai/src/modules/video/video_screen.dart';
import 'package:signfai/src/shared/components/components.dart';
import 'package:signfai/src/shared/styles/colors.dart';

class CardWidget extends StatelessWidget {
  final Data cardData;

  const CardWidget({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: !cardData.locked!
            ? () {
                navigateTo(context,
                    VideoScreen(link: cardData.video!, id: cardData.id!));
              }
            : null,
        child: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: cardData.locked! ? Colors.grey : fifthColor,
                spreadRadius: 5,
                blurRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: Text(cardData.title!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ));
  }
}
