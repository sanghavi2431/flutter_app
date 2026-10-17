import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/tasklist_model.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final List<TaskDropdownModel> items;
  final List<TaskDropdownModel> selectedItems;
  final Function(List<TaskDropdownModel>) onSelectionChanged;

  const CustomMultiSelectDropdown({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  bool isDropdownOpen = false;

  void _toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown button
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.selectedItems.isEmpty
                        ? 'Select Items'
                        : widget.selectedItems
                        .map((e) => e.facilityName)
                        .join(', '),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),

        // Dropdown content
        if (isDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              height: 200,
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
      ],
    );
  }
}