import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ShadowKiteApp());
}

class ShadowKiteApp extends StatelessWidget {
  const ShadowKiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF17233D);
    const blue = Color(0xFF2F6FE4);

    return MaterialApp(
      title: 'ShadowKite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFD),
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.light,
        ).copyWith(
          primary: blue,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: ink,
        ),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8FAFD),
          foregroundColor: ink,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 76,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE8F0FF),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: blue, width: 1.5),
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const _titles = ['Accueil', 'Mon CV', 'Portfolio', 'Profil'];

  void _openProfileWizard() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileWizardPage()),
    );
  }

  void _copyPublicLink() {
    Clipboard.setData(
      const ClipboardData(text: 'shadowkite.com/@jean-mukendi'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lien public copié'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardPage(
        onCompleteProfile: _openProfileWizard,
        onCopyLink: _copyPublicLink,
      ),
      const CvPage(),
      const PortfolioPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            const KiteMark(size: 27),
            const SizedBox(width: 9),
            Text(
              _titles[_currentIndex],
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Notifications',
            icon: const Badge(
              smallSize: 7,
              backgroundColor: Color(0xFF2F6FE4),
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description_rounded),
            label: 'CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_on_outlined),
            selectedIcon: Icon(Icons.grid_on_rounded),
            label: 'Portfolio',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.onCompleteProfile,
    required this.onCopyLink,
    super.key,
  });

  final VoidCallback onCompleteProfile;
  final VoidCallback onCopyLink;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        const Text(
          'Bonjour, Jean',
          style: TextStyle(
            color: Color(0xFF17233D),
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Votre identité professionnelle prend forme.',
          style: TextStyle(color: Color(0xFF718097), fontSize: 14),
        ),
        const SizedBox(height: 24),
        _CompletionCard(onPressed: onCompleteProfile),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.description_rounded,
                iconColor: const Color(0xFF2F6FE4),
                iconBackground: const Color(0xFFE8F0FF),
                label: 'MON CV',
                title: 'CV professionnel',
                subtitle: 'En cours',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.grid_on_rounded,
                iconColor: const Color(0xFF8864D1),
                iconBackground: const Color(0xFFF0EAFF),
                label: 'PORTFOLIO',
                title: '2 projets',
                subtitle: 'Brouillon',
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _SectionHeader(
          title: 'Actions rapides',
          action: 'Voir tout',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _QuickAction(
          icon: Icons.add_circle_outline_rounded,
          title: 'Ajouter une expérience',
          subtitle: 'Montrez ce que vous avez déjà accompli.',
          onTap: () => _showQuickAction(context, 'Expérience ajoutée à votre parcours'),
        ),
        const SizedBox(height: 10),
        _QuickAction(
          icon: Icons.auto_awesome_outlined,
          title: 'Ajouter votre premier projet',
          subtitle: 'Un projet personnel compte aussi.',
          onTap: () => _showQuickAction(context, 'Votre espace projet est prêt'),
        ),
        const SizedBox(height: 24),
        _PublicLinkCard(onCopy: onCopyLink),
      ],
    );
  }

  void _showQuickAction(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF2FF), Color(0xFFF5F7FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Kicker(text: 'VOTRE PROGRESSION'),
                const SizedBox(height: 9),
                const Text(
                  'Votre profil est à 70 %.',
                  style: TextStyle(
                    color: Color(0xFF17233D),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ajoutez un projet pour le rendre encore plus convaincant.',
                  style: TextStyle(
                    color: Color(0xFF758198),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Continuer →',
                    style: TextStyle(
                      color: Color(0xFF2F6FE4),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ProgressCircle(value: 0.7),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE7EBF2)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, color: iconColor, size: 17),
                ),
                Icon(Icons.arrow_outward_rounded, color: iconColor, size: 15),
              ],
            ),
            const SizedBox(height: 19),
            _Kicker(text: label),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF17233D),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF9AA5B5), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE7EBF2)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FB),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: const Color(0xFF2F6FE4), size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF17233D),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF8994A6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9AA5B5)),
          ],
        ),
      ),
    );
  }
}

class _PublicLinkCard extends StatelessWidget {
  const _PublicLinkCard({required this.onCopy});

  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17233D),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              color: const Color(0xFF273B62),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.link_rounded, color: Color(0xFF9FC1FF)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Kicker(text: 'VOTRE LIEN PUBLIC', light: true),
                SizedBox(height: 6),
                Text(
                  'shadowkite.com/@jean-mukendi',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCopy,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF2F6FE4),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.copy_rounded, size: 16),
          ),
        ],
      ),
    );
  }
}

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        const Text(
          'Construisez un CV qui vous ressemble.',
          style: TextStyle(
            color: Color(0xFF17233D),
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.9,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Complétez chaque section à votre rythme. Vos modifications sont enregistrées automatiquement.',
          style: TextStyle(
            color: Color(0xFF718097),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF17233D),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Kicker(text: 'PROGRESSION', light: true),
                    SizedBox(height: 8),
                    Text(
                      '4 sections sur 6 complétées',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 13),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: LinearProgressIndicator(
                        value: .66,
                        minHeight: 6,
                        backgroundColor: Color(0xFF304368),
                        valueColor: AlwaysStoppedAnimation(Color(0xFF77A5FF)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const ProgressCircle(value: .66, light: true),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Sections du CV'),
        const SizedBox(height: 12),
        _EditorRow(
          icon: Icons.person_outline_rounded,
          title: 'Informations personnelles',
          subtitle: 'Jean Mukendi · Développeur web',
          complete: true,
        ),
        _EditorRow(
          icon: Icons.short_text_rounded,
          title: 'Résumé professionnel',
          subtitle: 'Une présentation courte de votre profil',
          complete: true,
        ),
        _EditorRow(
          icon: Icons.work_outline_rounded,
          title: 'Expériences',
          subtitle: 'Ajoutez vos expériences principales',
          complete: true,
        ),
        _EditorRow(
          icon: Icons.school_outlined,
          title: 'Formations',
          subtitle: 'Diplômes, formations et certifications',
          complete: true,
        ),
        _EditorRow(
          icon: Icons.auto_awesome_outlined,
          title: 'Compétences',
          subtitle: 'Ajoutez au moins trois compétences',
          complete: false,
        ),
        _EditorRow(
          icon: Icons.translate_rounded,
          title: 'Langues',
          subtitle: 'Français, anglais, lingala…',
          complete: false,
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => _showPreview(context),
          icon: const Icon(Icons.visibility_outlined, size: 18),
          label: const Text('Prévisualiser mon CV'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: const Color(0xFF2F6FE4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
      ],
    );
  }

  void _showPreview(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => const CvPreviewSheet(),
    );
  }
}

class _EditorRow extends StatelessWidget {
  const _EditorRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.complete,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7EBF2)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: complete
                ? const Color(0xFFE8F6EE)
                : const Color(0xFFF0F4FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: complete
                ? const Color(0xFF3BA36C)
                : const Color(0xFF2F6FE4),
            size: 19,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF17233D),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF8B96A8), fontSize: 11),
          ),
        ),
        trailing: Icon(
          complete ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
          color: complete
              ? const Color(0xFF43AB73)
              : const Color(0xFF9AA5B5),
          size: complete ? 18 : 22,
        ),
      ),
    );
  }
}

class CvPreviewSheet extends StatelessWidget {
  const CvPreviewSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aperçu du CV',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE0E5ED)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x140E1A31),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JEAN MUKENDI',
                    style: TextStyle(
                      color: Color(0xFF17233D),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'DÉVELOPPEUR WEB · KINSHASA, RDC',
                    style: TextStyle(
                      color: Color(0xFF2F6FE4),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .4,
                    ),
                  ),
                  Divider(height: 27),
                  _CvPreviewSection(
                    title: 'PROFIL',
                    text:
                        'Je conçois des expériences web simples et utiles pour les personnes et les petites organisations.',
                  ),
                  _CvPreviewSection(
                    title: 'EXPÉRIENCE',
                    text:
                        'Développeur web indépendant · 2023 — aujourd’hui\nCréation de produits numériques et accompagnement de projets locaux.',
                  ),
                  _CvPreviewSection(
                    title: 'COMPÉTENCES',
                    text: 'Flutter · Angular · UX/UI · JavaScript · Gestion de projet',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Télécharger le PDF'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: const Color(0xFF2F6FE4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CvPreviewSection extends StatelessWidget {
  const _CvPreviewSection({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF94A0B1),
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF3F4B60),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vos projets, au premier plan.',
                    style: TextStyle(
                      color: Color(0xFF17233D),
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.9,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Présentez ce que vous savez réellement faire.',
                    style: TextStyle(color: Color(0xFF718097), fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF2F6FE4),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ProjectCard(
          title: 'AfriMarket',
          type: 'Produit digital · 2025',
          description:
              'Une expérience de commerce en ligne pensée pour les petites entreprises locales.',
          colors: const [Color(0xFFF7D98C), Color(0xFFE9B94D)],
          icon: Icons.shopping_bag_outlined,
        ),
        _ProjectCard(
          title: 'Kinshasa Maps',
          type: 'Application web · 2024',
          description:
              'Un outil simple pour découvrir les lieux et services utiles autour de soi.',
          colors: const [Color(0xFFBFD7FF), Color(0xFF5C85D7)],
          icon: Icons.map_outlined,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _showAddProject(context),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Ajouter un projet'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(51),
            foregroundColor: const Color(0xFF2F6FE4),
            side: const BorderSide(color: Color(0xFFBCD0F5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _PublicLinkCard(
          onCopy: () {
            Clipboard.setData(
              const ClipboardData(text: 'shadowkite.com/@jean-mukendi'),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lien public copié'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddProject(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const AddProjectSheet(),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.title,
    required this.type,
    required this.description,
    required this.colors,
    required this.icon,
  });

  final String title;
  final String type;
  final String description;
  final List<Color> colors;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7EBF2)),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 126,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 24,
                  top: 22,
                  child: Icon(icon, color: Colors.white.withOpacity(.75), size: 68),
                ),
                Positioned(
                  left: 18,
                  bottom: 16,
                  child: Text(
                    title.substring(0, 1),
                    style: TextStyle(
                      color: Colors.white.withOpacity(.7),
                      fontSize: 74,
                      fontWeight: FontWeight.w900,
                      height: .8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF2F6FE4),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF17233D),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF7C889B),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Text(
                      'Modifier le projet',
                      style: TextStyle(
                        color: Color(0xFF2F6FE4),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 7),
                    Icon(
                      Icons.arrow_outward_rounded,
                      color: Color(0xFF2F6FE4),
                      size: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddProjectSheet extends StatelessWidget {
  const AddProjectSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        22,
        4,
        22,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajouter un projet',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Décrivez un projet personnel, scolaire ou professionnel.',
              style: TextStyle(color: Color(0xFF718097), fontSize: 13),
            ),
            const SizedBox(height: 22),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nom du projet',
                hintText: 'Ex. Application de gestion',
              ),
            ),
            const SizedBox(height: 13),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Quel était le problème et votre rôle ?',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: const Color(0xFF2F6FE4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text('Enregistrer le projet'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 74,
                height: 74,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8D2C2),
                ),
                child: const Text(
                  'JM',
                  style: TextStyle(
                    color: Color(0xFF8F5A45),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Jean Mukendi',
                style: TextStyle(
                  color: Color(0xFF17233D),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Développeur web · Kinshasa, RDC',
                style: TextStyle(color: Color(0xFF718097), fontSize: 13),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileWizardPage()),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2F6FE4),
                  side: const BorderSide(color: Color(0xFFBCD0F5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Modifier mon profil'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const _SectionHeader(title: 'Mon espace'),
        const SizedBox(height: 10),
        _ProfileOption(
          icon: Icons.visibility_outlined,
          title: 'Aperçu public',
          subtitle: 'Voir ce que les visiteurs voient',
          onTap: () {},
        ),
        _ProfileOption(
          icon: Icons.tune_rounded,
          title: 'Visibilité et partage',
          subtitle: 'Contrôlez les informations publiques',
          onTap: () {},
        ),
        _ProfileOption(
          icon: Icons.settings_outlined,
          title: 'Paramètres du compte',
          subtitle: 'Langue, sécurité et préférences',
          onTap: () {},
        ),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'À propos de ShadowKite'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              KiteMark(size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Un projet ouvert pour rendre les parcours professionnels plus visibles.',
                  style: TextStyle(
                    color: Color(0xFF3F6098),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7EBF2)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF2F6FE4)),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF17233D),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF8B96A8), fontSize: 11),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF9AA5B5),
        ),
      ),
    );
  }
}

class ProfileWizardPage extends StatefulWidget {
  const ProfileWizardPage({super.key});

  @override
  State<ProfileWizardPage> createState() => _ProfileWizardPageState();
}

class _ProfileWizardPageState extends State<ProfileWizardPage> {
  int _step = 0;

  final _steps = const [
    (
      title: 'Commençons par vous.',
      subtitle: 'Ces informations apparaîtront en haut de votre profil.',
      fields: ['Nom complet', 'Titre professionnel'],
    ),
    (
      title: 'Présentez votre parcours.',
      subtitle: 'Une courte présentation aide les visiteurs à vous comprendre.',
      fields: ['Votre présentation'],
    ),
    (
      title: 'Ajoutez vos compétences.',
      subtitle: 'Commencez avec les compétences que vous utilisez le plus.',
      fields: ['Compétences principales', 'Langues'],
    ),
    (
      title: 'Votre profil est prêt.',
      subtitle: 'Vous pourrez toujours modifier ces informations plus tard.',
      fields: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text(
          'Mon profil',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                '${_step + 1}/${_steps.length}',
                style: const TextStyle(
                  color: Color(0xFF718097),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_step + 1) / _steps.length,
                  minHeight: 5,
                  backgroundColor: const Color(0xFFE3EAF5),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF2F6FE4)),
                ),
              ),
              const SizedBox(height: 42),
              Text(
                step.title,
                style: const TextStyle(
                  color: Color(0xFF17233D),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                step.subtitle,
                style: const TextStyle(
                  color: Color(0xFF718097),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              if (_step < 3)
                ...step.fields.map(
                  (field) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TextField(
                      maxLines: field == 'Votre présentation' ? 5 : 1,
                      decoration: InputDecoration(
                        labelText: field,
                        hintText: _hintFor(field),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6EF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: Color(0xFF3AA76C), size: 26),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Votre profil de base est enregistré. Ajoutez maintenant votre premier projet.',
                          style: TextStyle(
                            color: Color(0xFF327D58),
                            fontSize: 13,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          foregroundColor: const Color(0xFF2F6FE4),
                          side: const BorderSide(color: Color(0xFFBCD0F5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text('Retour'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () {
                        if (_step == _steps.length - 1) {
                          Navigator.pop(context);
                        } else {
                          setState(() => _step++);
                        }
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF2F6FE4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: Text(
                        _step == _steps.length - 1 ? 'Terminer' : 'Continuer',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _hintFor(String field) {
    switch (field) {
      case 'Nom complet':
        return 'Ex. Jean Mukendi';
      case 'Titre professionnel':
        return 'Ex. Développeur web';
      case 'Votre présentation':
        return 'Décrivez ce que vous faites en deux ou trois phrases.';
      case 'Compétences principales':
        return 'Ex. Flutter, UX/UI, gestion de projet';
      default:
        return 'Ex. Français, anglais';
    }
  }
}

class ProgressCircle extends StatelessWidget {
  const ProgressCircle({required this.value, this.light = false, super.key});

  final double value;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 7,
            backgroundColor:
                light ? const Color(0xFF304368) : const Color(0xFFDCE7FB),
            valueColor: AlwaysStoppedAnimation(
              light ? const Color(0xFF8EB3FF) : const Color(0xFF2F6FE4),
            ),
          ),
          Text(
            '${(value * 100).round()}%',
            style: TextStyle(
              color: light ? Colors.white : const Color(0xFF2F6FE4),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.action,
    this.onTap,
  });

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF17233D),
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -.3,
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              action!,
              style: const TextStyle(
                color: Color(0xFF2F6FE4),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class _Kicker extends StatelessWidget {
  const _Kicker({required this.text, this.light = false});

  final String text;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: light ? const Color(0xFF8EB3FF) : const Color(0xFF98A3B3),
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    );
  }
}

class KiteMark extends StatelessWidget {
  const KiteMark({this.size = 30, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: KitePainter()),
    );
  }
}

class KitePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final top = Offset(center.dx, size.height * .1);
    final right = Offset(size.width * .9, center.dy);
    final bottom = Offset(center.dx, size.height * .9);
    final left = Offset(size.width * .1, center.dy);

    final full = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();
    paint.color = const Color(0xFFE7EFFF);
    canvas.drawPath(full, paint);

    final leading = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(center.dx, center.dy + size.height * .1)
      ..close();
    paint.color = const Color(0xFF2F6FE4);
    canvas.drawPath(leading, paint);

    final side = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(center.dx, center.dy + size.height * .1)
      ..lineTo(left.dx, left.dy)
      ..close();
    paint.color = const Color(0xFF78A4FF);
    canvas.drawPath(side, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}