import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class KnowledgeBasePage extends StatelessWidget {
  const KnowledgeBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final tips = [
      {
        'title': loc.tipVatTitle,
        'category': loc.categoryFinance,
        'content': loc.tipVatContent,
      },
      {
        'title': loc.tipMaterialTitle,
        'category': loc.categoryMaterials,
        'content': loc.tipMaterialContent,
      },
      {
        'title': loc.tipSafetyTitle,
        'category': loc.categorySafety,
        'content': loc.tipSafetyContent,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.knowledgeBase),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 2,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        separatorBuilder: (context, i) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final tip = tips[i];
          return ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(tip['title']!),
            subtitle: Text(tip['category']!),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(tip['title']!),
                content: Text(tip['content']!),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(loc.close),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 