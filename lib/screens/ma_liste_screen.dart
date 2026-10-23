import 'package:flutter/material.dart';
import '../data/livres_data.dart';
import '../models/livre.dart';

// Q3.1 : StatefulWidget, car l'écran change quand l'utilisateur coche des cases
class MaListeScreen extends StatefulWidget {
  const MaListeScreen({super.key});

  @override
  State<MaListeScreen> createState() => _MaListeScreenState();
}

class _MaListeScreenState extends State<MaListeScreen> {
  // Q3.2 : filtre « nouveautés »
  bool _nouveautesSeulement = false;

  // Q3.3 : les 5 genres, tous cochés au départ
  final Map<String, bool> _genres = {
    'Roman': true,
    'Science': true,
    'Histoire': true,
    'Jeunesse': true,
    'Informatique': true,
  };

  // Q3.4 : une icône par genre
  final Map<String, IconData> _icones = {
    'Roman': Icons.menu_book,
    'Science': Icons.science,
    'Histoire': Icons.history_edu,
    'Jeunesse': Icons.child_care,
    'Informatique': Icons.computer,
  };

  // Q3.4 : nombre de livres d'un genre
  int _nombreDeLivres(String genre) {
    return livres.where((livre) => livre.genre == genre).length;
  }

  // Q3.6 : état de la case « Tous les genres »
  // true = tous cochés, false = aucun, null = quelques-uns (tiret)
  bool? get _tousLesGenres {
    if (_genres.values.every((coche) => coche)) return true;
    if (_genres.values.every((coche) => !coche)) return false;
    return null;
  }

  // Q3.7 : livres filtrés par genres cochés (et nouveautés si demandé)
  List<Livre> get _livresAffiches {
    return livres.where((livre) {
      final genreCoche = _genres[livre.genre] == true;
      final nouveauteOk = !_nouveautesSeulement || livre.nouveaute;
      return genreCoche && nouveauteOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final affiches = _livresAffiches;
    final nbLus = affiches.where((livre) => livre.lu).length;

    return Scaffold(
      // Q3.8 : compteur dynamique dans l'AppBar
      appBar: AppBar(
        title: Text('Lus : $nbLus / ${affiches.length}'),
      ),
      body: ListView(
        children: [
          // Q3.2 : un seul CheckboxListTile lié à _nouveautesSeulement
          CheckboxListTile(
            title: const Text('Afficher uniquement les nouveautés'),
            value: _nouveautesSeulement,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (valeur) {
              // Sans setState, la variable change mais l'écran ne se redessine pas
              setState(() {
                _nouveautesSeulement = valeur ?? false;
              });
            },
          ),
          const Divider(),

          // Q3.6 : case « Tous les genres » à trois états
          CheckboxListTile(
            title: const Text(
              'Tous les genres',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            tristate: true,
            value: _tousLesGenres,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (_) {
              setState(() {
                // Si tout est coché -> on décoche tout ; sinon -> on coche tout
                final toutCocher = _tousLesGenres != true;
                _genres.updateAll((genre, coche) => toutCocher);
              });
            },
          ),

          // Q3.3 + Q3.4 + Q3.5 : un CheckboxListTile par genre, généré depuis la map
          ..._genres.keys.map((genre) {
            return CheckboxListTile(
              title: Text(genre),
              subtitle: Text('${_nombreDeLivres(genre)} livre(s)'),
              secondary: Icon(_icones[genre]),
              activeColor: Colors.teal,
              value: _genres[genre],
              // Q3.5 : .leading place la case à gauche
              // .trailing la place à droite, .platform dépend du système
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (valeur) {
                setState(() {
                  _genres[genre] = valeur ?? false;
                });
              },
            );
          }),
          const Divider(thickness: 2),

          // Q3.7 : liste des livres filtrée, avec ListView.separated
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: affiches.length,
            separatorBuilder: (context, index) => const Divider(indent: 72),
            itemBuilder: (context, index) {
              final livre = affiches[index];
              return CheckboxListTile(
                value: livre.lu,
                controlAffinity: ListTileControlAffinity.leading,
                secondary: CircleAvatar(
                  backgroundColor: livre.couleur,
                  child: Text(
                    livre.titre[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  livre.titre,
                  style: TextStyle(
                    // titre barré si le livre est lu
                    decoration: livre.lu ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text('${livre.auteur} – ${livre.annee}'),
                onChanged: (valeur) {
                  setState(() {
                    livre.lu = valeur ?? false;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}