# ShadowKite Mobile — Flutter

Ce dépôt contient uniquement le socle Flutter initialisé pour l’application mobile ShadowKite. Il ne contient pas encore les écrans métier, le design final, la navigation produit ni la connexion à l’API.

## Responsabilité

L’application mobile prendra en charge l’accès au compte, le profil, la saisie guidée du CV, la gestion des projets, l’aperçu, la publication et le partage du portfolio, avec une expérience adaptée aux petits écrans et aux connexions modestes.

## Tâches principales du mobile

- [ ] Définir l’architecture de navigation après validation des parcours Figma.
- [ ] Intégrer les écrans mobile Figma sans créer de templates visuels à l’avance.
- [ ] Construire l’inscription, la connexion, la récupération de compte et le tableau de bord.
- [ ] Construire les formulaires profil, CV et portfolio avec validations et sauvegarde d’état.
- [ ] Ajouter les états de chargement, les messages d’erreur, l’accessibilité et le mode responsive.
- [ ] Intégrer l’aperçu, la publication, le partage du lien et le téléchargement lorsque le contrat API sera stabilisé.
- [ ] Ajouter les tests unitaires et widget, puis préparer les builds Android, iOS et web.
- [ ] Reporter les tâches transversales 1 à 80 dans `PROJECT_TASKS.md` et cocher uniquement les livrables réellement terminés.

## Socle initialisé

Le projet est généré avec Flutter et un package Dart valide `shadowkite_mobile`, pour Android, iOS et Web. Le contenu généré reste celui du starter officiel ; aucune fonctionnalité ShadowKite n’est ajoutée.

## À ne pas faire dans cette initialisation

Ne pas créer les écrans définitifs, ne pas choisir de templates visuels, ne pas ajouter d’authentification réelle et ne pas connecter de secrets ou d’API avant validation du design mobile et du contrat backend.
