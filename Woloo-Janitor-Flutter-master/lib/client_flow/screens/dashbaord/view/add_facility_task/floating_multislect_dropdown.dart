
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/tasklist_model.dart';

class FloatingMultiSelectDropdown extends StatefulWidget {
  final List<TaskDropdownModel> items;
  final List<TaskDropdownModel> selectedItems;
  final Function(List<TaskDropdownModel>) onSelectionChanged;

  const FloatingMultiSelectDropdown({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<FloatingMultiSelectDropdown> createState() =>
      _FloatingMultiSelectDropdownState();
}

class _FloatingMultiSelectDropdownState
    extends State<FloatingMultiSelectDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    setState(() {});
  }

  void _onItemTapped(TaskDropdownModel item) {
    setState(() {
      if (widget.selectedItems.contains(item)) {
        widget.selectedItems.remove(item);
      } else {
        widget.selectedItems.add(item);
      }
      widget.onSelectionChanged(widget.selectedItems);
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = widget.selectedItems.contains(item);

                return InkWell(
                  onTap: () => _onItemTapped(item),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => _onItemTapped(item),
                        activeColor: Colors.yellow,
                        checkColor: Colors.black,
                      ),
                      Expanded(
                        child: Text(
                          item.facilityName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff8F8F8F)),
                        ),
                      ),
                      Text(
                        "${item.requiredTime}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff8BDFFB)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _key,
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.selectedItems.isEmpty
                      ? 'Select Items'
                      : widget.selectedItems
                      .map((e) => e.facilityName)
                      .join(', '),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}