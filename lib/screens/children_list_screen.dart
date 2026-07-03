import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/child.dart';
import '../services/database_service.dart';
import 'child_detail_screen.dart';
import 'add_health_record_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChildrenListScreen extends StatefulWidget {
  const ChildrenListScreen({super.key});

  @override
  State<ChildrenListScreen> createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends State<ChildrenListScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Child> _children = [];
  List<Child> _filteredChildren = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');
      final children = await _databaseService.getAllChildren(user.uid);
      setState(() {
        _children = children;
        _filteredChildren = children;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading children: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterChildren(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChildren = _children;
      } else {
        _filteredChildren = _children.where((child) {
          return child.name.toLowerCase().contains(query.toLowerCase()) ||
                 child.parentName.toLowerCase().contains(query.toLowerCase()) ||
                 child.village.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Children'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChildren,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredChildren.isEmpty
                      ? _buildEmptyState()
                      : _buildChildrenList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search children by name, parent, or village...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterChildren('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: _filterChildren,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.child_care,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No children found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a child to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Child'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenList() {
    return RefreshIndicator(
      onRefresh: _loadChildren,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredChildren.length,
        itemBuilder: (context, index) {
          final child = _filteredChildren[index];
          return _buildChildCard(child);
        },
      ),
    );
  }

  Widget _buildChildCard(Child child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => _showAddHealthRecord(child),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.add_chart,
              label: 'Add Record',
            ),
            SlidableAction(
              onPressed: (context) => _showDeleteDialog(child),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue[100],
            child: child.photoPath != null
                ? ClipOval(
                    child: Image.asset(
                      child.photoPath!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.child_care,
                          size: 30,
                          color: Colors.blue[600],
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.child_care,
                    size: 30,
                    color: Colors.blue[600],
                  ),
          ),
          title: Text(
            child.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('Parent: ${child.parentName}'),
              Text('Age: ${_calculateAge(child.dateOfBirth)} years'),
              Text('Village: ${child.village}'),
              Text('District: ${child.district}'),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
          ),
          onTap: () => _navigateToChildDetail(child),
        ),
      ),
    );
  }

  String _calculateAge(String dateOfBirth) {
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      final age = now.year - birthDate.year;
      if (now.month < birthDate.month || 
          (now.month == birthDate.month && now.day < birthDate.day)) {
        return (age - 1).toString();
      }
      return age.toString();
    } catch (e) {
      return 'Unknown';
    }
  }

  void _navigateToChildDetail(Child child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildDetailScreen(child: child),
      ),
    );
  }

  void _showAddHealthRecord(Child child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHealthRecordScreen(child: child),
      ),
    );
  }

  void _showDeleteDialog(Child child) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Child'),
        content: Text(
          'Are you sure you want to delete ${child.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteChild(child);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteChild(Child child) async {
    try {
      await _databaseService.deleteChild(child.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${child.name} deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _loadChildren();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting child: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 