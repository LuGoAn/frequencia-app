import 'package:flutter/material.dart';
import '../services/icon_service.dart';
import '../theme/app_colors.dart';

class IconPickerSheet extends StatefulWidget {
  final String selectedKey;
  final ValueChanged<String> onSelected;

  const IconPickerSheet({
    super.key,
    required this.selectedKey,
    required this.onSelected,
  });

  static Future<String?> show(BuildContext context, String currentKey) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => IconPickerSheet(
        selectedKey: currentKey,
        onSelected: (key) => Navigator.of(ctx).pop(key),
      ),
    );
  }

  @override
  State<IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<IconPickerSheet> {
  static const _categories = [
    'Todos',
    'Tecnologia',
    'Inteligência & Robótica',
    'Matemática & Ciências',
    'Acadêmico & Projetos',
    'Geral & Humanas',
  ];

  String _category = 'Todos';

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final icons = IconService.allIcons
        .where((i) => _category == 'Todos' || i.category == _category)
        .toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              'Escolher ícone',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: p.ink),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = cat == _category;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _category = cat),
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: selected ? p.onInk : p.inkSoft,
                  ),
                  selectedColor: p.ink,
                  backgroundColor: p.cellEmpty,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                final item = icons[index];
                final selected = item.key == widget.selectedKey;
                return Tooltip(
                  message: item.label,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => widget.onSelected(item.key),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected ? p.ink : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item.icon, size: 26, color: selected ? p.onInk : p.ink),
                          const SizedBox(height: 6),
                          Text(
                            item.label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.2,
                              color: selected ? p.onInk : p.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
