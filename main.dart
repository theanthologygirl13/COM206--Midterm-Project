import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define a list of pastel colors for theme and backgrounds
const Color pastelPink = Color(0xFFE284B2);
const Color pastelMint = Color(0xFFB2F7EF);
const Color pastelBlue = Color(0xFFA7C7E7);
const Color pastelOrange = Color(0xFFFFBCB3);
const Color pastelLilac = Color(0xFFD9B2FF);
const Color pastelYellow = Color(0xFFFFF9C4);
const Color pastelPeach = Color(0xFFFFCCB2);
const Color darkBlack = Color(0xFF1A1A1A);
const Color whiteBackground = Color(0xFFFFFFFF);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastel To Do List',
      theme: ThemeData(
        primaryColor: pastelPink,
        scaffoldBackgroundColor: whiteBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: pastelPink,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: darkBlack,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: darkBlack,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: darkBlack,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: darkBlack,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            color: darkBlack,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoItem {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdDate;
  DateTime? dueDate;
  String page; // 'inbox', 'today', 'notes'

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdDate,
    this.dueDate,
    required this.page,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currIndex = 0;
  List<TodoItem> todoItems = [
    TodoItem(
      id: '1',
      title: 'Buy groceries',
      description: 'Milk, Eggs, Bread, Fruit',
      isCompleted: false,
      createdDate: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: 1)),
      page: 'inbox',
    ),
    TodoItem(
      id: '2',
      title: 'Finish Flutter project',
      description: 'Complete the to-do app',
      isCompleted: false,
      createdDate: DateTime.now(),
      dueDate: DateTime.now(),
      page: 'today',
    ),
    TodoItem(
      id: '3',
      title: 'Call mom',
      description: 'Check on how she is doing',
      isCompleted: false,
      createdDate: DateTime.now().subtract(Duration(days: 2)),
      dueDate: DateTime.now(),
      page: 'inbox',
    ),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      InboxPage(
        todoItems: todoItems,
        onTodoRemoved: _removeTodo,
      ),
      TodayPage(
        todoItems: todoItems,
        onTodoRemoved: _removeTodo,
      ),
      NotesPage(
        todoItems: todoItems,
        onTodoRemoved: _removeTodo,
      ),
    ];
  }

  void _removeTodo(String id) {
    setState(() {
      todoItems.removeWhere((item) => item.id == id);
    });
  }

  void _addNewTodo(String title, String description, String page) {
    setState(() {
      todoItems.add(
        TodoItem(
          id: DateTime.now().toString(),
          title: title,
          description: description,
          isCompleted: false,
          createdDate: DateTime.now(),
          dueDate: DateTime.now().add(Duration(days: 1)),
          page: page,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TODOPINK",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: _pages[_currIndex],
      drawer: DrawerMenu(
        onNavigation: (index) {
          setState(() => _currIndex = index);
          Navigator.pop(context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () {
          _showAddTodoDialog(context);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currIndex,
        onTap: (int index) {
          setState(() => _currIndex = index);
        },
        selectedItemColor: darkBlack,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: whiteBackground,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
        ],
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    String title = '';
    String description = '';
    String selectedPage = 'inbox';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add New To-Do',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: darkBlack, width: 2),
                    ),
                  ),
                  onChanged: (value) => title = value,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: darkBlack, width: 2),
                    ),
                  ),
                  onChanged: (value) => description = value,
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: selectedPage,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'inbox', child: Text('Inbox')),
                    DropdownMenuItem(value: 'today', child: Text('Today')),
                    DropdownMenuItem(value: 'notes', child: Text('Notes')),
                  ],
                  onChanged: (value) {
                    selectedPage = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  _addNewTodo(title, description, selectedPage);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Add',
                style: GoogleFonts.poppins(
                  color: darkBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Drawer Menu
class DrawerMenu extends StatelessWidget {
  final Function(int) onNavigation;

  const DrawerMenu({required this.onNavigation, super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: pastelPink),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: darkBlack,
                  child: Icon(Icons.check_circle, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  "TODOPINK",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          _DrawerListTile(
            icon: Icons.mail,
            title: 'Inbox',
            onTap: () => onNavigation(0),
          ),
          _DrawerListTile(
            icon: Icons.today,
            title: 'Today',
            onTap: () => onNavigation(1),
          ),
          _DrawerListTile(
            icon: Icons.notes,
            title: 'Notes',
            onTap: () => onNavigation(2),
          ),
          const Divider(),
          _DrawerListTile(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon!')),
              );
            },
          ),
          _DrawerListTile(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('TODOPINK v1.0 - Your Pastel To-Do Manager'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerListTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: darkBlack),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: darkBlack,
        ),
      ),
      onTap: onTap,
    );
  }
}

// INBOX PAGE
class InboxPage extends StatelessWidget {
  final List<TodoItem> todoItems;
  final Function(String) onTodoRemoved;

  const InboxPage({
    required this.todoItems,
    required this.onTodoRemoved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final inboxItems = todoItems.where((item) => item.page == 'inbox').toList();

    return Container(
      color: whiteBackground,
      child: inboxItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline, size: 64, color: pastelPink),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks in Inbox',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: inboxItems.length,
              itemBuilder: (context, index) {
                return TodoCard(
                  todoItem: inboxItems[index],
                  onRemove: () => onTodoRemoved(inboxItems[index].id),
                );
              },
            ),
    );
  }
}

// TODAY PAGE
class TodayPage extends StatelessWidget {
  final List<TodoItem> todoItems;
  final Function(String) onTodoRemoved;

  const TodayPage({
    required this.todoItems,
    required this.onTodoRemoved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final todayItems = todoItems.where((item) => item.page == 'today').toList();
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    return Container(
      color: whiteBackground,
      child: todayItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: pastelBlue),
                  const SizedBox(height: 16),
                  Text(
                    "No tasks for today",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Today's Tasks - ${todayDate.toString().split(' ')[0]}",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkBlack,
                    ),
                  ),
                ),
                ...todayItems.map(
                  (item) => TodoCard(
                    todoItem: item,
                    onRemove: () => onTodoRemoved(item.id),
                  ),
                ),
              ],
            ),
    );
  }
}

// NOTES PAGE
class NotesPage extends StatelessWidget {
  final List<TodoItem> todoItems;
  final Function(String) onTodoRemoved;

  const NotesPage({
    required this.todoItems,
    required this.onTodoRemoved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notesItems = todoItems.where((item) => item.page == 'notes').toList();

    return Container(
      color: whiteBackground,
      child: notesItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notes, size: 64, color: pastelOrange),
                  const SizedBox(height: 16),
                  Text(
                    'No notes yet',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notesItems.length,
              itemBuilder: (context, index) {
                return TodoCard(
                  todoItem: notesItems[index],
                  onRemove: () => onTodoRemoved(notesItems[index].id),
                );
              },
            ),
    );
  }
}

// TODO CARD WIDGET
class TodoCard extends StatelessWidget {
  final TodoItem todoItem;
  final VoidCallback onRemove;

  const TodoCard({
    required this.todoItem,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: _getCardColor(),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: darkBlack, width: 2.5),
                color: Colors.transparent,
              ),
              child: const Icon(
                Icons.check,
                size: 18,
                color: darkBlack,
              ),
            ),
          ),
          title: Text(
            todoItem.title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: darkBlack,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              todoItem.description,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          trailing: Icon(
            Icons.calendar_today,
            color: darkBlack,
            size: 18,
          ),
        ),
      ),
    );
  }

  Color _getCardColor() {
    switch (todoItem.page) {
      case 'inbox':
        return pastelPink.withOpacity(0.15);
      case 'today':
        return pastelBlue.withOpacity(0.15);
      case 'notes':
        return pastelOrange.withOpacity(0.15);
      default:
        return pastelLilac.withOpacity(0.15);
    }
  }
}