import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class DropTargetItem extends StatefulWidget {
  final String property;
  final Function(String, String) onDrop;

  const DropTargetItem({
    super.key,
    required this.property,
    required this.onDrop,
  });

  @override
  State<DropTargetItem> createState() => _DropTargetItemState();
}

class _DropTargetItemState extends State<DropTargetItem> {
  String dragItem = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(widget.property)),

        Expanded(
          flex: 2,
          child: DragTarget<String>(
            onAcceptWithDetails: (details) {
              setState(() {
                dragItem = details.data;
              });

              widget.onDrop(details.data, widget.property);
            },

            builder: (context, candidateData, rejectedData) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: candidateData.isEmpty
                        ? Appcolors.gray
                        : Appcolors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(dragItem.isNotEmpty ? dragItem : 'Drop here'),
                    ),

                    if (dragItem.isNotEmpty)
                      InkWell(
                        onTap: () {
                          setState(() {
                            dragItem = '';
                          });
                        },
                        child: const Icon(Icons.delete),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
