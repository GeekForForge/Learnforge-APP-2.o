import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/gradient_button.dart';

class AddTodoModal extends StatefulWidget {
  final Function(String, String, DateTime, String) onAdd;

  const AddTodoModal({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddTodoModal> createState() => _AddTodoModalState();
}

class _AddTodoModalState extends State<AddTodoModal> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime _selectedDate = DateTime.now();
  String _selectedPriority = 'medium';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.neonPurple,
              onPrimary: Colors.white,
              surface: AppColors.dark800,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.dark900,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: GlassMorphicCard(
        glowColor: AppColors.neonPurple,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Task',
                style: TextStyles.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white, // Fixed: textLight → white
                ),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Task title',
                  filled: true,
                  fillColor:
                      AppColors.dark700, // Fixed: darkBgSecondary → dark700
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.neonPurple,
                    ), // Fixed: accent → neonPurple
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.neonPurple,
                      width: 2,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: AppColors.grey400,
                  ), // Fixed: textMuted → grey400
                ),
                style: TextStyle(
                  color: AppColors.white,
                ), // Fixed: textLight → white
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  filled: true,
                  fillColor:
                      AppColors.dark700, // Fixed: darkBgSecondary → dark700
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.neonPurple,
                    ), // Fixed: accent → neonPurple
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.neonPurple,
                      width: 2,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: AppColors.grey400,
                  ), // Fixed: textMuted → grey400
                ),
                style: TextStyle(
                  color: AppColors.white,
                ), // Fixed: textLight → white
                maxLines: 2,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors
                              .dark700, // Fixed: darkBgSecondary → dark700
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.neonPurple,
                          ), // Fixed: accent → neonPurple
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppColors
                                  .neonPurple, // Fixed: accent → neonPurple
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                              style: TextStyle(
                                color:
                                    AppColors.white, // Fixed: textLight → white
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.dark700,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.neonPurple),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedPriority,
                      dropdownColor:
                          AppColors.dark700, // Fixed: darkBgSecondary → dark700
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Inter',
                      ), // Fixed: textLight → white
                      underline: Container(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.neonPurple,
                      ),
                      items: ['low', 'medium', 'high'].map((priority) {
                        Color priorityColor;
                        switch (priority) {
                          case 'high':
                            priorityColor = Colors.redAccent;
                            break;
                          case 'medium':
                            priorityColor = Colors.orange;
                            break;
                          case 'low':
                            priorityColor = AppColors.neonCyan;
                            break;
                          default:
                            priorityColor = AppColors.neonPurple;
                        }

                        return DropdownMenuItem(
                          value: priority,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: priorityColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                priority.toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedPriority = value);
                        }
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 20),
              GradientButton(
                text: 'Add Task', // Fixed: label → text
                onPressed: () {
                  if (_titleController.text.isNotEmpty) {
                    widget.onAdd(
                      _titleController.text,
                      _descController.text,
                      _selectedDate,
                      _selectedPriority,
                    );
                  }
                },
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ).animate().fadeIn(delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
