import 'package:flutter/material.dart';

class CustomSegmentedButton extends StatelessWidget{
  final Set<String> selected;
  final ValueChanged<Set<String>> onSelectionChanged;
  final List<ButtonSegment<String>> segments;

  const CustomSegmentedButton({
    super.key,
    required this.selected,
    required this.onSelectionChanged,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: segments,
      selected: selected,
      showSelectedIcon: false,
      onSelectionChanged: onSelectionChanged,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).colorScheme.primary;
            }
            return Theme.of(context).scaffoldBackgroundColor;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).colorScheme.onPrimary;
            }
            return Theme.of(context).colorScheme.onSurface;
          },
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          (states) => BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 1.5,
          ),
        ),
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}