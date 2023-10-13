import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
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
  @override
  Widget build(BuildContext context) {
    final bottomSheetProvider = Provider.of<BottomSheetProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Background(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * (60 / 870),
            right: MediaQuery.of(context).size.width * (22 / 412),
            left: MediaQuery.of(context).size.width * (22 / 412),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * (35 / 412),
              ),
              child: Text(
                AppLocalizations.of(context)!.appBarTitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (47 / 870),
            ),
            CalendarTimeline(
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(
                  const Duration(days: 365),
                ),
                onDateSelected: (date) => debugPrint('$date')),
            SizedBox(
              height: MediaQuery.of(context).size.height * (47 / 870),
            ),
            Expanded(
              child: Builder(builder: (BuildContext context) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) =>
                      OpenContainer(
                          closedElevation: 0,
                          openElevation: 0,
                          closedShape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          transitionDuration: const Duration(milliseconds: 500),
                          closedColor: Colors.transparent,
                          openColor: Colors.transparent,
                          closedBuilder: (BuildContext context,
                                  void Function() action) =>
                              Slidable(
                                // Specify a key if the Slidable is dismissible.
                                key: const ValueKey(0),
                                // The start action pane is the one at the left or the top side.
                                startActionPane: ActionPane(
                                  // A motion is a widget used to control how the pane animates.
                                  motion: const ScrollMotion(),

                                  // A pane can dismiss the Slidable.
                                  // All actions are defined in the children parameter.
                                  children: [
                                    // A SlidableAction can have an icon and/or a label.
                                    SlidableAction(
                                      label:
                                          AppLocalizations.of(context)!.delete,
                                      borderRadius: BorderRadius.circular(14),
                                      backgroundColor: const Color(0xFFEC4B4B),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      onPressed: (BuildContext context) {
                                        taskProvider.deleteTask(index);
                                      },
                                    ),
                                  ],
                                ),

                                // The end action pane is the one at the right or the bottom side.

                                // The child of the Slidable is what the user sees when the
                                // component is not dragged.
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      (357 / 412),
                                  height: MediaQuery.of(context).size.height *
                                      (115 / 870),
                                  decoration: ShapeDecoration(
                                    color:
                                        themeProvider.mode == AppTheme.darkTheme
                                            ? AppTheme.blackColor
                                            : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (17 / 412),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (4 / 412),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                (62 / 870),
                                        decoration: ShapeDecoration(
                                          color: taskProvider.tasks[index].done
                                              ? AppTheme.greenColor
                                              : AppTheme.blueColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (17 / 412),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            taskProvider.tasks[index]
                                                .title, //replace this with the title from the database u will make
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color: taskProvider
                                                          .tasks[index].done
                                                      ? AppTheme.greenColor
                                                      : AppTheme.blueColor,
                                                ),
                                          ),
                                          Row(
                                            children: [
                                              ImageIcon(
                                                AssetImage(Assets.discovery),
                                                size: 14,
                                                color: themeProvider.mode ==
                                                        AppTheme.darkTheme
                                                    ? AppTheme.lightColor
                                                    : AppTheme.blackColor,
                                              ),
                                              Text(
                                                DateFormat(
                                                        'hh:mm a',
                                                        languageProvider
                                                            .appLocale
                                                            .toString())
                                                    .format(taskProvider
                                                        .tasks[index]
                                                        .time), //replace this with the time from the database u will make
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(
                                        flex: 3,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            taskProvider.tasks[index].done
                                                ? taskProvider.updateTask(
                                                    index,
                                                    Task(
                                                        title: taskProvider
                                                            .tasks[index].title,
                                                        detail: taskProvider
                                                            .tasks[index]
                                                            .detail,
                                                        time: taskProvider
                                                            .tasks[index].time,
                                                        done: false))
                                                : taskProvider.updateTask(
                                                    index,
                                                    Task(
                                                        title: taskProvider
                                                            .tasks[index].title,
                                                        detail: taskProvider
                                                            .tasks[index]
                                                            .detail,
                                                        time: taskProvider
                                                            .tasks[index].time,
                                                        done: true));
                                          });
                                        },
                                        child: taskProvider.tasks[index]
                                                .done //replace this with the done from the database u will make
                                            ? Text(
                                                AppLocalizations.of(context)!
                                                    .done,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color:
                                                          AppTheme.greenColor,
                                                    ),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (69 / 412),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    (34 / 870),
                                                decoration: ShapeDecoration(
                                                  color: AppTheme.blueColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.check_rounded,
                                                  size: 35,
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
                            return TaskDetailsProvider(index);
                          }),
                  itemCount: taskProvider.tasks.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    height: MediaQuery.of(context).size.height * (47 / 870),
                  ),
                );
              }),
            )
          ]),
        ),
        bottomSheet: bottomSheetProvider.isBottomSheetVisible
            ? const BottomModelProvider()
            : null,
      ),
    );
  }
}

// ignore: must_be_immutable
class CalenderDay extends StatelessWidget {
  String dayss = '';
  String dayOfWeek = '';

  CalenderDay(this.dayOfWeek, this.dayss, {super.key});
  @override
  Widget build(BuildContext context) {
    bool today = DateTime.now().day.toString() == dayss;
    Color fillColor = Provider.of<ThemeProvider>(context, listen: false).mode ==
            AppTheme.darkTheme
        ? AppTheme.blackColor
        : Colors.white;
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * (56 / 412),
      height: MediaQuery.of(context).size.height * (76 / 870),
      decoration: BoxDecoration(color: fillColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayOFWeek(dayOfWeek, context),
            textAlign: TextAlign.center,
            style: today
                ? Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppTheme.blueColor)
                : Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            dayss,
            textAlign: TextAlign.center,
            style: today
                ? Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.blueColor,
                    )
                : Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  String dayOFWeek(String s, context) {
    if (s == 'Sun') {
      return AppLocalizations.of(context)!.sun;
    } else if (s == 'Mon') {
      return AppLocalizations.of(context)!.mon;
    } else if (s == 'Tue') {
      return AppLocalizations.of(context)!.tue;
    } else if (s == 'Wed') {
      return AppLocalizations.of(context)!.wed;
    } else if (s == 'Thu') {
      return AppLocalizations.of(context)!.thu;
    } else if (s == 'Fri') {
      return AppLocalizations.of(context)!.fri;
    } else {
      return AppLocalizations.of(context)!.sat;
    }
  }
}
