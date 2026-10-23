# Réponses TP MaBiblio

## Partie 00 — Mise en place

### Q0.8 — Pourquoi ne pas envoyer build/ et .dart_tool/ sur GitHub ?

Ces dossiers sont générés automatiquement :
- `build/` contient les fichiers compilés de l'application ;
- `.dart_tool/` contient le cache et la configuration des paquets.

Il ne faut pas les envoyer sur GitHub car :
- ils sont lourds et alourdiraient inutilement le dépôt ;
- ils sont recréés à tout moment avec `flutter pub get` ou `flutter build` ;
- ils dépendent de la machine locale et causeraient des conflits chez une autre personne qui clone le projet.

Sur GitHub, on ne met que le code source.

### Réflexion Git — Pourquoi plusieurs petits commits ?

Plusieurs petits commits permettent de suivre l'évolution du projet étape par étape,
de retrouver facilement quand une erreur est apparue, et de revenir en arrière sur
une seule modification sans perdre tout le travail. Ils montrent aussi que le travail
a été fait régulièrement, et non