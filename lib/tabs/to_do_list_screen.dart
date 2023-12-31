import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../assets.dart';
import '../providers/database.dart';
import '../providers/language.dart';
import '../task.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/edit_screen.dart';
import '../widgets/back_ground.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../providers/bottom_sheet.dart';
import '../providers/l_d_mode.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  var selectedDate = DateTime.now();
  Box taskBox = Hive.box('tasks');
  @override
  Widget build(BuildContext context) {
    final bottomSheetProvider = Provider.of<BottomSheetProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    List<Task> taskList = [];

    for (var i = 0; i < taskBox.length; i++) {
      taskList.add(taskBox.getAt(i));
    }
    return Background(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: 60.h,
            right: 22.w,
            left: 22.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 35.w,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.appBarTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 47.h),
                CalendarTimeline(
                  initialDate: selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(
                    days: 365,
                  )),
                  onDateSelected: (date) {
                    selectedDate = date;
                    setState(() {});
                  },
                  leftMargin: 21.w,
                  monthColor: Theme.of(context).textTheme.bodyLarge!.color,
                  dayColor: Colors.blue.withOpacity(.5),
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.blue,
                  dotsColor: Colors.white,
                  selectableDayPredicate: (date) => true,
                  locale: languageProvider.appLocale.toLanguageTag(),
                ),
                SizedBox(height: 47.h),
                Builder(builder: (BuildContext context) {
                  final filteredTasks = taskProvider.tasks
                      .where((element) =>
                          DateUtils.dateOnly(element.time)
                              .millisecondsSinceEpoch ==
                          DateUtils.dateOnly(selectedDate)
                              .millisecondsSinceEpoch)
                      .toList();

                  return SizedBox(
                    height: 620.h,
                    width: double.infinity,
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        int indexx = taskList.indexOf(filteredTasks[index]);
                        return OpenContainer(
                          closedElevation: 0,
                          openElevation: 0,
                          closedShape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                          ),
                          transitionDuration: const Duration(milliseconds: 500),
                          closedColor: Colors.transparent,
                          openColor: Colors.transparent,
                          closedBuilder:
                              (BuildContext context, void Function() action) =>
                                  Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  label: AppLocalizations.of(context)!.delete,
                                  borderRadius: BorderRadius.circular(14.r),
                                  backgroundColor: const Color(0xFFEC4B4B),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  onPressed: (BuildContext context) {
                                    taskProvider.deleteTask(indexx);
                                  },
                                ),
                                SlidableAction(
                                  label: AppLocalizations.of(context)!.editicon,
                                  borderRadius: BorderRadius.circular(14.r),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  onPressed: (BuildContext context) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TaskDetailsScreen(
                                                    index: indexx,
                                                    task: Task(
                                                      title: taskBox
                                                          .getAt(indexx)
                                                          .title,
                                                      detail: taskBox
                                                          .getAt(indexx)
                                                          .detail,
                                                      time: taskBox
                                                          .getAt(indexx)
                                                          .time,
                                                      done: taskBox
                                                          .getAt(indexx)
                                                          .done,
                                                    ))));
                                  },
                                ),
                              ],
                            ),
                            child: Container(
                              width: 357.w,
                              height: 115.h,
                              decoration: ShapeDecoration(
                                color: themeProvider.mode == AppTheme.darkTheme
                                    ? AppTheme.blackColor
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 17.w),
                                  Container(
                                    width: 4.w,
                                    height: 62.h,
                                    decoration: ShapeDecoration(
                                      color: taskProvider.tasks[index].done
                                          ? AppTheme.greenColor
                                          : AppTheme.blueColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 17.w),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        taskBox
                                            .getAt(indexx)
                                            .title, // Replace this with the title from the database you will make
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: taskBox.getAt(indexx).done
                                                  ? AppTheme.greenColor
                                                  : AppTheme.blueColor,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          ImageIcon(
                                            AssetImage(Assets.discovery),
                                            size: 14.w,
                                            color: themeProvider.mode ==
                                                    AppTheme.darkTheme
                                                ? AppTheme.lightColor
                                                : AppTheme.blackColor,
                                          ),
                                          Text(
                                            DateFormat(
                                                    'hh:mm a',
                                                    languageProvider.appLocale
                                                        .toString())
                                                .format(taskBox
                                                    .getAt(indexx)
                                                    .time), // Replace this with the time from the database you will make
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(flex: 3),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        taskBox.getAt(indexx).done =
                                            taskBox.getAt(indexx).done
                                                ? false
                                                : true;
                                        taskProvider.updateTask(
                                            indexx, taskBox.getAt(indexx));
                                      });
                                    },
                                    child: taskBox.getAt(indexx).done
                                        ? Text(
                                            AppLocalizations.of(context)!.done,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  color: AppTheme.greenColor,
                                                ),
                                          )
                                        : Container(
                                            width: 69.w,
                                            height: 34.h,
                                            decoration: ShapeDecoration(
                                              color: AppTheme.blueColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.check_rounded,
                                              size: 35.w,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          openBuilder:
                              (BuildContext context, void Function() action) {
                            return TaskDetailsScreen(
                                index: indexx,
                                task: Task(
                                  title: taskBox.getAt(indexx).title,
                                  detail: taskBox.getAt(indexx).detail,
                                  time: taskBox.getAt(indexx).time,
                                  done: taskBox.getAt(indexx).done,
                                ));
                          },
                        );
                      },
                      itemCount: taskProvider.tasks
                          .where((element) =>
                              DateUtils.dateOnly(element.time)
                                  .millisecondsSinceEpoch ==
                              DateUtils.dateOnly(selectedDate)
                                  .millisecondsSinceEpoch)
                          .length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: 47.h),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
        bottomSheet: bottomSheetProvider.isBottomSheetVisible
            ? const AddTaskBottomSheet()
            : null,
      ),
    );
  }
}
