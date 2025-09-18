import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/goal.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();

  GoalCategory _selectedCategory = GoalCategory.other;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 365));
  Color _selectedColor = const Color(0xFF607D8B);
  IconData _selectedIcon = Icons.category;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Goal',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _saveGoal,
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal Title
              _buildSectionTitle('Goal Title'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Emergency Fund, Vacation, New Car',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.flag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a goal title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Goal Description
              _buildSectionTitle('Description (Optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe your goal and why it\'s important to you',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 24),

              // Target Amount
              _buildSectionTitle('Target Amount'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _targetAmountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Enter target amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  prefixText: '\$ ',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a target amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Target Date
              _buildSectionTitle('Target Date'),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Category Selection
              _buildSectionTitle('Category'),
              const SizedBox(height: 8),
              _buildCategorySelector(),
              const SizedBox(height: 24),

              // Color and Icon Selection
              _buildSectionTitle('Customize Appearance'),
              const SizedBox(height: 8),
              _buildAppearanceSelector(),
              const SizedBox(height: 24),

              // Preview Card
              _buildSectionTitle('Preview'),
              const SizedBox(height: 8),
              _buildPreviewCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                GoalCategory.values.map((category) {
                  final defaults = Goal.getCategoryDefaults(category);
                  final isSelected = _selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                        _selectedColor = defaults['color'] as Color;
                        _selectedIcon = defaults['icon'] as IconData;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? (defaults['color'] as Color).withOpacity(0.2)
                                : Colors.transparent,
                        border: Border.all(
                          color:
                              isSelected
                                  ? defaults['color'] as Color
                                  : Theme.of(context).dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            defaults['icon'] as IconData,
                            color: defaults['color'] as Color,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getCategoryDisplayName(category),
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? defaults['color'] as Color
                                      : Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Color Selection
          Row(
            children: [
              const Icon(Icons.palette),
              const SizedBox(width: 12),
              Text(
                'Color',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Icon Selection
          Row(
            children: [
              const Icon(Icons.emoji_emotions),
              const SizedBox(width: 12),
              Text(
                'Icon',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_selectedIcon, color: _selectedColor, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    final targetAmount = double.tryParse(_targetAmountController.text) ?? 0.0;
    final daysLeft = _selectedDate.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _selectedColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_selectedIcon, color: _selectedColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleController.text.isEmpty
                          ? 'Goal Title'
                          : _titleController.text,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$0 of \$${targetAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '0%',
                    style: TextStyle(
                      color: _selectedColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${daysLeft}d left',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.0,
              backgroundColor:
                  Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withOpacity(0.1) ??
                  Colors.grey.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(_selectedColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(GoalCategory category) {
    switch (category) {
      case GoalCategory.emergency:
        return 'Emergency';
      case GoalCategory.vacation:
        return 'Vacation';
      case GoalCategory.education:
        return 'Education';
      case GoalCategory.home:
        return 'Home';
      case GoalCategory.vehicle:
        return 'Vehicle';
      case GoalCategory.health:
        return 'Health';
      case GoalCategory.entertainment:
        return 'Entertainment';
      case GoalCategory.investment:
        return 'Investment';
      case GoalCategory.other:
        return 'Other';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      final goal = Goal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        targetAmount: double.parse(_targetAmountController.text),
        currentAmount: 0.0,
        targetDate: _selectedDate,
        createdAt: DateTime.now(),
        status: GoalStatus.active,
        category: _selectedCategory,
        color: _selectedColor,
        icon: _selectedIcon,
      );

      // TODO: Save goal to database/storage
      // For now, we'll just show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Goal "${goal.title}" created successfully!'),
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            label: 'View Goals',
            textColor: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );

      // Navigate back to goals screen
      Navigator.pop(context, goal);
    }
  }
}
