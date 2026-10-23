import 'package:flutter/material.dart';
import '../data/livres_data.dart';
import '../widgets/livre_card.dart';

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Q2.7 : on garde seulement les livres où nouveaute == true
    final nouveautes = livres.where((livre) => livre.nouveaute).toList();

    // Q2.8 : organisation en Column
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre « Nouveautés »
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Nouveautés',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // Q2.7 : ListView horizontal de 160 px de haut
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: nouveautes.length,
            itemBuilder: (context, index) {
              final livre = nouveautes[index];
              return Container(
                width: 110,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: livre.couleur,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  livre.titre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),

        // Titre « Tout le catalogue »
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Tout le catalogue',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // Q2.8 : le ListView vertical doit être dans un Expanded
        Expanded(
          // Q2.4 : première version avec ListView.builder
          // child: ListView.builder(
          //   itemCount: livres.length,
          //   itemBuilder: (context, index) => livreTile(livres[index]),
          // ),

          // Q2.5 : ListView.builder est préférable à ListView(children: ...)
          // pour 1 000 livres, car il ne construit que les éléments visibles
          // à l'écran (construction « paresseuse »). ListView(children: ...)
          // crée les 1 000 widgets dès le départ : plus de mémoire utilisée
          // et un affichage plus lent.

          // Q2.6 : version finale avec ListView.separated
          child: ListView.separated(
            itemCount: livres.length,
            itemBuilder: (context, index) => livreTile(livres[index]),
            separatorBuilder: (context, index) => const Divider(indent: 72),
          ),

          // Q2.9 : alternative à Expanded (à tester sans le Expanded) :
          // child: ListView.separated(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   ...
          // ),
        ),
      ],
    );
  }
}
