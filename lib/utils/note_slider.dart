import 'package:Clubzey/models/club.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../views/clubs_page.dart';

class NoteSlider extends StatelessWidget {
  final Club club;
  final  onRemove;
  final VoidCallback onPressed;

  const NoteSlider({Key? key, required this.club, this.onRemove, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Slidable(

        key: UniqueKey(),

        startActionPane: ActionPane(
          extentRatio: .2,
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(

              onPressed: (context) {},
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.edit,

            ),

          ],
        ),
        endActionPane: ActionPane(
          extentRatio: .2,
          motion: ScrollMotion(),
          children: [
            SlidableAction(

              // An action can be bigger than the others.
              onPressed: onRemove,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,

            ),
          ],
        ),
        child: ClubItemCard(
          club: club,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

