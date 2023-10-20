import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/database.dart';
import '../task.dart';
import '../widgets/back_ground.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/l_d_mode.dart';
import '../providers/language.dart';

// ignore: must_be_immutable
class TaskDetailsScreen extends StatefulWidget {
  Task task;
  int index;
  TaskDetailsScreen({required this.task, super.key, required this.index});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final formKey2 = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late Box TaskBox;
  final TextEditingController titleControl = TextEditingController();
  final TextEditingController detailControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    TaskBox = Hive.box('tasks');

    titleControl.text = widget.task.title;
    detailControl.text = widget.task.detail;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    DateTime selectedDate = widget.task.time;
    bool done = widget.task.done;
    Color cardColor = themeProvider.mode == AppTheme.darkTheme
        ? AppTheme.blackColor
        : AppTheme.lightColor;
    return Background(
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Card(
          color: cardColor,
          elevation: 18,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
            side: const BorderSide(),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 800.h,
            color: Colors.transparent,
            padding: const EdgeInsets.all(16).w,
            child: Form(
              key: formKey2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.edit,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextFiild(
                    hint: AppLocalizations.of(context)!.taskTitle,
                    control: titleControl,
                  ),
                  SizedBox(height: 16.h),
                  TextFiild(
                    hint: AppLocalizations.of(context)!.taskDetails,
                    control: detailControl,
                    lines: 10,
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () async {
                        DateTime? chosenDate = await showDatePicker(
                            locale: languageProvider.appLocale,
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)));

                        if (chosenDate == null) return;

                        setState(() {
                          widget.task.time = chosenDate;
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.time,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: themeProvider.mode == AppTheme.darkTheme
                                  ? AppTheme.grayColor
                                  : Colors.black45,
                            ),
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('y-M-d').format(selectedDate),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 18.sp,
                          color: themeProvider.mode == AppTheme.darkTheme
                              ? AppTheme.grayColor
                              : Colors.black45,
                        ),
                  ),
                  const Spacer(flex: 5),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.donee,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: AppTheme.greenColor),
                      ),
                      const Spacer(flex: 5),
                      InkWell(
                        onTap: () {
                          done = done ? false : true;
                          taskProvider.updateTask(widget.index, widget.task);
                        },
                        child: Icon(
                          done
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color:
                              done ? AppTheme.greenColor : AppTheme.blueColor,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey2.currentState?.validate() ?? false) {
                        String titleTask = titleControl.text;
                        String detailTask = detailControl.text;
                        DateTime time = selectedDate;
                        Task task = Task(
                          title: titleTask,
                          detail: detailTask,
                          time: time,
                          done: done,
                        );
                        taskProvider.updateTask(widget.index, task);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TextFiild extends StatelessWidget {
  String hint;
  int lines;

  TextEditingController control = TextEditingController();
  TextFiild({
    super.key,
    required this.hint,
    this.lines = 1,
    required this.control,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color textColor = themeProvider.mode == AppTheme.darkTheme
        ? AppTheme.grayColor
        : Colors.black45;
    return TextFormField(
      style: Theme.of(context).textTheme.bodyMedium,
      controller: control,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return AppLocalizations.of(context)!.requiredFieldError;
        }
        return null;
      },
      maxLines: lines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor),
      ),
    );
  }
}
