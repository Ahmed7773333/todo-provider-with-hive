import 'package:flutter/material.dart';
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
class TaskDetailsProvider extends StatefulWidget {
  int index;
  TaskDetailsProvider(this.index, {super.key});

  @override
  State<TaskDetailsProvider> createState() => _TaskDetailsProviderState();
}

class _TaskDetailsProviderState extends State<TaskDetailsProvider> {
  final formKey2 = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late Box TaskBox;
  final TextEditingController titleControl = TextEditingController();
  final TextEditingController detailControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    TaskBox = Hive.box('tasks');
    if (widget.index < TaskBox.length) {
      titleControl.text = TaskBox.getAt(widget.index)?.title ?? '';
      detailControl.text = TaskBox.getAt(widget.index)?.detail ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    bool done = taskProvider.tasks[widget.index].done;
    Color cardColor = themeProvider.mode == AppTheme.darkTheme
        ? AppTheme.blackColor
        : AppTheme.lightColor;
    return Background(
      child: Padding(
        padding:
            EdgeInsets.all(MediaQuery.of(context).size.height * (12 / 870)),
        child: Card(
          color: cardColor,
          elevation: 18,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide()),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * (800 / 870),
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
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
                      height: MediaQuery.of(context).size.height * (16 / 870)),
                  TextFiild(
                    hint: AppLocalizations.of(context)!.taskTitle,
                    control: titleControl,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * (16 / 870)),
                  TextFiild(
                    hint: AppLocalizations.of(context)!.taskDetails,
                    control: detailControl,
                    lines: 10,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * (16 / 870)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        showDatePicker(
                          locale: languageProvider.appLocale,
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.time,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: themeProvider.mode == AppTheme.darkTheme
                                ? AppTheme.grayColor
                                : Colors.black45),
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('y-M-d').format(DateTime.now()),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        color: themeProvider.mode == AppTheme.darkTheme
                            ? AppTheme.grayColor
                            : Colors.black45),
                  ),
                  const Spacer(
                    flex: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.donee,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: AppTheme.greenColor),
                      ),
                      const Spacer(
                        flex: 5,
                      ),
                      InkWell(
                        onTap: () {
                          done
                              ? taskProvider.updateTask(
                                  widget.index,
                                  Task(
                                      title: titleControl.text,
                                      detail: detailControl.text,
                                      time: DateTime.now(),
                                      done: false))
                              : taskProvider.updateTask(
                                  widget.index,
                                  Task(
                                      title: titleControl.text,
                                      detail: detailControl.text,
                                      time: DateTime.now(),
                                      done: true));
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
                        DateTime time = DateTime.now();
                        Task task = Task(
                            title: titleTask,
                            detail: detailTask,
                            time: time,
                            done: done);
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
  TextFiild(
      {super.key, required this.hint, this.lines = 1, required this.control});

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
