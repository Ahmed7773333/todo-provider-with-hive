import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/database.dart';
import '../tabs/settings.dart';
import '../tabs/to_do_list_screen.dart';
import '../task.dart';
import 'back_ground.dart';
import '../providers/bottom_sheet.dart';
import '../providers/l_d_mode.dart';
import 'bottom_sheet.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});
  static const String routeName = "BottomBar";

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final List<Widget> _pages = [
    const ToDoListScreen(),
    const Settings(),
  ];

  int _currentIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final bottomSheetProvider = Provider.of<BottomSheetProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    Color shadowCOlor =
        Provider.of<ThemeProvider>(context, listen: false).mode ==
                AppTheme.darkTheme
            ? Colors.grey.shade800
            : Colors.white;
    return Background(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: _pageController,
          children: _pages,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.list,
                  size: 35.w,
                  color: _currentIndex == 0
                      ? AppTheme.blueColor
                      : AppTheme.iconColor,
                ),
                onPressed: () {
                  _navigateToTab(0);
                },
              ),
              const SizedBox(),
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  size: 35.w,
                  color: _currentIndex == 1
                      ? AppTheme.blueColor
                      : AppTheme.iconColor,
                ),
                onPressed: () {
                  _navigateToTab(1);
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          decoration: ShapeDecoration(
            shape: OvalBorder(
              side: BorderSide(
                color: shadowCOlor,
                width: 5.w,
              ),
            ),
          ),
          child: FloatingActionButton(
            shape: CircleBorder(),
            elevation: 0,
            onPressed: () {
              if (bottomSheetProvider.isBottomSheetVisible) {
                if (AddTaskBottomSheet.formKey.currentState?.validate() ??
                    false) {
                  Task task = Task(
                      title: AddTaskBottomSheet.titleController.text,
                      detail: AddTaskBottomSheet.detailsController.text,
                      time: bottomSheetProvider.selectedTime,
                      done: false);
                  taskProvider.addTask(task);
                  AddTaskBottomSheet.clearControllers();
                  bottomSheetProvider.hideBottomSheet();
                }
              } else {
                bottomSheetProvider.toggleBottomSheet();
              }
            },
            child: Icon(
              bottomSheetProvider.buttonIcon,
              size: 40.w,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTab(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
