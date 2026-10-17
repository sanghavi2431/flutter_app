import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasklist_model.dart';

class CustomTaskDropdown extends StatefulWidget {
  final List<TaskDropdownModel> items;
  final List<TaskDropdownModel> selectedItems;
  final Function(List<TaskDropdownModel>) onSelectionChanged;
  final String hintText;
  final double borderRadius;
  final TextStyle? hintTextStyle;
  final TextStyle? selectedTextStyle;
  final List<BoxShadow>? fieldBoxShadow;

  const CustomTaskDropdown({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.hintText = "Select Tasks",
    this.borderRadius = 8,
    this.hintTextStyle,
    this.selectedTextStyle,
    this.fieldBoxShadow,
  }) : super(key: key);

  @override
  State<CustomTaskDropdown> createState() => _CustomTaskDropdownState();
}

class _CustomTaskDropdownState extends State<CustomTaskDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomTaskDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild overlay when selectedItems change - defer to after build
    if (_isOpen) {
      // Check if the selection has changed by comparing IDs
      final oldIds = oldWidget.selectedItems.map((e) => e.id).toSet();
      final newIds = widget.selectedItems.map((e) => e.id).toSet();
      if (oldIds.length != newIds.length || !oldIds.containsAll(newIds)) {
        // Selection changed, rebuild overlay after build completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_overlayEntry != null && _isOpen && mounted) {
            _overlayEntry!.markNeedsBuild();
          }
        });
      }
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeightBelow = screenHeight - offset.dy - size.height;
    final maxHeight = availableHeightBelow > 200
        ? MediaQuery.of(context).size.height * 0.35
        : availableHeightBelow - 20;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        // Use StatefulBuilder to allow the overlay to rebuild when selection changes
        return StatefulBuilder(
          builder: (context, setOverlayState) {
            return GestureDetector(
              onTap: () {
                // Close dropdown when tapping outside
                _removeOverlay();
              },
              child: Stack(
                children: [
                  // Transparent background to catch taps
                  Positioned.fill(
                    child: Container(color: Colors.transparent),
                  ),
                  // Dropdown content
                  Positioned(
                    width: size.width,
                    left: offset.dx,
                    top: offset.dy + 45,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: maxHeight > 0 ? maxHeight : 200,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: widget.items.length,
                                itemBuilder: (context, index) {
                                  final item = widget.items[index];
                                  final isSelected = widget.selectedItems.any(
                                    (selected) =>
                                        selected.id != null &&
                                        item.id != null &&
                                        selected.id == item.id,
                                  );

                                  return ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 0,
                                    ),
                                    minVerticalPadding: 0,
                                    visualDensity: const VisualDensity(
                                      horizontal: 0,
                                      vertical: -4,
                                    ),
                                    leading: Checkbox(
                                      value: isSelected,
                                      onChanged: (_) {
                                        _toggleItem(item);
                                        // Update overlay state immediately
                                        setOverlayState(() {});
                                      },
                                      activeColor: Colors.yellow,
                                      checkColor: Colors.black,
                                    ),
                                    title: Text(item.facilityName ?? ''),
                                    trailing: Text(
                                      "+ ${item.requiredTime ?? 0} min",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    onTap: () {
                                      _toggleItem(item);
                                      // Update overlay state immediately
                                      setOverlayState(() {});
                                    },
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _removeOverlay();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Done",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _toggleItem(TaskDropdownModel item) {
    if (item.id == null) return;

    final List<TaskDropdownModel> updated = List.from(widget.selectedItems);
    final index = updated.indexWhere(
      (selected) => selected.id != null && selected.id == item.id,
    );

    if (index >= 0) {
      updated.removeAt(index);
    } else {
      updated.add(item);
    }

    widget.onSelectionChanged(updated);
  }

  void _removeItem(TaskDropdownModel item) {
    if (item.id == null) return;

    final List<TaskDropdownModel> updated = List.from(widget.selectedItems);
    updated.removeWhere(
      (selected) => selected.id != null && selected.id == item.id,
    );
    widget.onSelectionChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: widget.fieldBoxShadow ??
                  [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
            ),
            child: InkWell(
              onTap: _toggleDropdown,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: widget.selectedItems.isEmpty
                          ? Text(
                              widget.hintText,
                              style: widget.hintTextStyle ??
                                  const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff8F8F8F),
                                  ),
                            )
                          : Text(
                              widget.selectedItems
                                  .map((e) => e.facilityName ?? '')
                                  .where((name) => name.isNotEmpty)
                                  .join(', '),
                              style: widget.selectedTextStyle ??
                                  const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Color(0xff8F8F8F),
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Chips card (separate from dropdown)
          if (widget.selectedItems.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.selectedItems.map((item) {
                  return Chip(
                    avatar: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? Image.network(
                            item.imageUrl!,
                            width: 16,
                            height: 16,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                width: 16,
                                height: 16,
                              );
                            },
                          )
                        : null,
                    label: Text(item.facilityName ?? ''),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    backgroundColor:
                        const Color(0xFF8BDFFB).withValues(alpha: 0.20),
                    onDeleted: () {
                      _removeItem(item);
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
