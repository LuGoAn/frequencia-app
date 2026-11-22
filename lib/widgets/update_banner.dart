import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/update_service.dart';
import '../theme/app_colors.dart';

class UpdateBanner extends StatelessWidget {
  final AppUpdate update;
  final VoidCallback onDismiss;

  const UpdateBanner({super.key, required this.update, required this.onDismiss});

  Future<void> _download(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launchUrl(Uri.parse(update.downloadUrl), mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(const SnackBar(content: Text('Não deu pra abrir o link do download.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 6),
      decoration: BoxDecoration(
        color: p.sheet,
        border: Border.all(color: p.rule),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Versão ${update.version} disponível',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.ink),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              'Baixe o APK e instale por cima. Suas faltas continuam salvas.',
              style: TextStyle(fontSize: 14, height: 1.35, color: p.inkSoft),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: onDismiss, child: const Text('Agora não')),
              TextButton(
                onPressed: () => _download(context),
                child: const Text('Baixar', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
