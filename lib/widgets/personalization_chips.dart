import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';

class CustomChip extends StatefulWidget {
  final List<String> selectedItems; // ✅ Items yang sudah dipilih
  final Function(String) onItemAdded; // ✅ Callback saat item ditambah
  final Function(String) onItemRemoved; // ✅ Callback saat item dihapus
  final List<String>? suggestedItems; // ✅ Saran items (opsional)
  final String? hintText;
  final bool showTextField; // ✅ Show/hide text field untuk input manual
  final int? maxItems; // ✅ Limit jumlah maksimal items

  const CustomChip({
    super.key,
    required this.selectedItems,
    required this.onItemAdded,
    required this.onItemRemoved,
    this.suggestedItems,
    this.hintText,
    this.showTextField = true,
    this.maxItems,
  });

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  final TextEditingController _controller = TextEditingController();
  List<String> _availableSuggestions = [];

  @override
  void initState() {
    super.initState();
    _updateAvailableSuggestions();
  }

  @override
  void didUpdateWidget(CustomChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItems != widget.selectedItems ||
        oldWidget.suggestedItems != widget.suggestedItems) {
      _updateAvailableSuggestions();
    }
  }

  void _updateAvailableSuggestions() {
    if (widget.suggestedItems != null) {
      setState(() {
        _availableSuggestions = widget.suggestedItems!
            .where((item) => !widget.selectedItems.contains(item))
            .toList();
      });
    }
  }

  void _addItem(String value) {
    if (value.trim().isEmpty) return;

    // Check max items
    if (widget.maxItems != null &&
        widget.selectedItems.length >= widget.maxItems!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maksimal ${widget.maxItems} item'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check duplicate
    if (widget.selectedItems.any(
      (item) => item.toLowerCase() == value.trim().toLowerCase(),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item "$value" sudah ada'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    widget.onItemAdded(value.trim());
    _controller.clear();
    _updateAvailableSuggestions();
  }

  void _removeItem(String value) {
    widget.onItemRemoved(value);
    _updateAvailableSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Text Field untuk input manual
        if (widget.showTextField) ...[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Ketik dan tekan Enter',
              hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF8FAFB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: thirdColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: thirdColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: bluePrimaryColor, width: 2),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.add_circle, color: bluePrimaryColor),
                onPressed: () => _addItem(_controller.text),
              ),
            ),
            onSubmitted: _addItem,
          ),
          const SizedBox(height: 16),
        ],

        // ✅ Suggested Chips (yang belum dipilih)
        if (_availableSuggestions.isNotEmpty) ...[
          Text(
            'Saran:',
            style: primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableSuggestions.map((item) {
              return GestureDetector(
                onTap: () => _addItem(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: bluePrimaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item,
                        style: primaryTextStyle.copyWith(
                          color: bluePrimaryColor,
                          fontSize: 14,
                          fontWeight: medium,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.add, color: bluePrimaryColor, size: 16),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // ✅ Selected Chips (yang sudah dipilih)
        if (widget.selectedItems.isNotEmpty) ...[
          Text(
            'Terpilih (${widget.selectedItems.length}${widget.maxItems != null ? '/${widget.maxItems}' : ''}):',
            style: primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedItems.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: bluePrimaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: bluePrimaryColor.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item,
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeItem(item),
                      child: Icon(Icons.close, color: whiteColor, size: 18),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Belum ada item yang dipilih',
                  style: secondaryTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
