import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

class JanitorBottomSheet extends StatelessWidget {
  final List<dynamic> janitorList;
  final int selectedJanitor;
  final Function(int index) onSelect;
  final VoidCallback onNext;
  final String errorMessage;

  const JanitorBottomSheet({
    super.key,
    required this.janitorList,
    required this.selectedJanitor,
    required this.onSelect,
    required this.onNext,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 680,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(80),
          topRight: Radius.circular(80),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          _header(),

          const SizedBox(height: 60),

          Expanded(
            child: ListView.builder(
              itemCount: janitorList.length,
              itemBuilder: (context, index) {
                final isSelected = selectedJanitor == index;

                return GestureDetector(
                  onTap: () => onSelect(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.backgroundColor
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      color:
                          isSelected ? Colors.yellow.shade100 : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          ClientImages.avatar,
                          height: 48,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                janitorList[index].name ?? "",
                                style: AppTextStyle.font16bold,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                janitorList[index].mobile ?? "",
                                style: AppTextStyle.font14w6,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          const SizedBox(height: 12),

          GestureDetector(
            onTap: onNext,
            child: const Custombutton(
              text: "Assign Task",
              width: double.infinity,
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Image.asset(ClientImages.avatar, height: 48),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            text: "Assign ",
            style: AppTextStyle.font22bold,
            children: [
              TextSpan(
                text: "Janitor",
                style: AppTextStyle.font22bold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
