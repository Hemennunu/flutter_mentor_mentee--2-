import 'package:flutter/material.dart';

class FilterMembersScreen extends StatefulWidget {
  @override
  _FilterMembersScreenState createState() => _FilterMembersScreenState();
}

class _FilterMembersScreenState extends State<FilterMembersScreen> {
  String search = '';
  String organization = '';
  String occupation = '';
  String location = '';

  String sortBy = '';
  bool needMentoring = false;
  bool availableToMentor = false;

  void clearAll() {
    setState(() {
      search = '';
      sortBy = '';
      needMentoring = false;
      availableToMentor = false;
      organization = '';
      occupation = '';
      location = '';
    });
  }

  void applyFilters() {
    // TODO: implement your filter logic or navigation here
    Navigator.pushNamed(context, 'memberProfile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Members', style: TextStyle(fontSize: 18)),
        backgroundColor: Color(0xFF4A2B2B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => search = value),
                controller: TextEditingController(text: search),
              ),

              const SizedBox(height: 16),

              // Sort By
              const Text('Sort By', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  SortChip(
                    label: 'Name (A-Z)',
                    selected: sortBy == 'name',
                    onTap: () => setState(() => sortBy = 'name'),
                  ),
                  const SizedBox(width: 8),
                  SortChip(
                    label: 'Registration Date',
                    selected: sortBy == 'date',
                    onTap: () => setState(() => sortBy = 'date'),
                  ),
                  const SizedBox(width: 8),
                  SortChip(
                    label: 'Age',
                    selected: sortBy == 'age',
                    onTap: () => setState(() => sortBy = 'age'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Filter By
              const Text('Filter By', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              FilterToggleChip(
                label: 'Need Mentoring',
                checked: needMentoring,
                onChanged: (val) => setState(() => needMentoring = val),
              ),
              const SizedBox(height: 8),
              FilterToggleChip(
                label: 'Available to Mentor',
                checked: availableToMentor,
                onChanged: (val) => setState(() => availableToMentor = val),
              ),

              const SizedBox(height: 16),

              // Other filters
              TextField(
                decoration: InputDecoration(
                  labelText: 'Organization',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => organization = val),
                controller: TextEditingController(text: organization),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => occupation = val),
                controller: TextEditingController(text: occupation),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => location = val),
                controller: TextEditingController(text: location),
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: clearAll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFECEC),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3F2C2C),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Color(0xFF4A2B2B) : Color(0xFFFFECEC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class FilterToggleChip extends StatelessWidget {
  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const FilterToggleChip({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: checked ? Color(0xFF4A2B2B) : Color(0xFFFFECEC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: checked ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
