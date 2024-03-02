// ignore_for_file: file_names
// import 'dart:ui';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gantt_chart/gantt_chart.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyCustomScrollBehavior extends MaterialScrollBehavior {
//   // Override behavior methods and getters like dragDevices
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//         PointerDeviceKind.touch,
//         PointerDeviceKind.mouse,
//         PointerDeviceKind.trackpad
//         // etc.
//       };
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       scrollBehavior: MyCustomScrollBehavior(),
//       title: 'Flutter Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final scrollController = ScrollController();

//   double dayWidth = 30;
//   bool showDaysRow = true;
//   bool showStickyArea = true;
//   bool customStickyArea = false;
//   bool customWeekHeader = false;
//   bool customDayHeader = false;

//   List<GanttRelativeEvent> events = [];
//   late DateTime timelineStartDate;

//   @override
//   void initState() {
//     super.initState();
//     timelineStartDate = DateTime.now();
//   }

//   void onZoomIn() {
//     setState(() {
//       dayWidth += 5;
//     });
//   }

//   void onZoomOut() {
//     if (dayWidth <= 10) return;
//     setState(() {
//       dayWidth -= 5;
//     });
//   }

//   void addTask(String taskName, DateTime beginDate, DateTime endDate) {
//     setState(() {
//       events.add(
//         GanttRelativeEvent(
//           relativeToStart: beginDate.difference(timelineStartDate),
//           duration: endDate.difference(beginDate),
//           displayName: taskName,
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RawKeyboardListener(
//       focusNode: FocusNode(),
//       autofocus: true,
//       onKey: (event) {
//         if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
//           if (scrollController.offset <
//               scrollController.position.maxScrollExtent) {
//             scrollController.jumpTo(scrollController.offset + 50);
//           }
//         }
//         if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
//           if (scrollController.offset >
//               scrollController.position.minScrollExtent) {
//             scrollController.jumpTo(scrollController.offset - 50);
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Gantt chart demo'),
//           actions: [
//             IconButton(
//               onPressed: onZoomIn,
//               icon: const Icon(
//                 Icons.zoom_in,
//               ),
//             ),
//             IconButton(
//               onPressed: onZoomOut,
//               icon: const Icon(
//                 Icons.zoom_out,
//               ),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Text(
//                 'Try navigating with keyboard arrow keys',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: 24,
//                 ),
//               ),
//               const Divider(),
//               GanttChartView(
//                 scrollPhysics: const BouncingScrollPhysics(),
//                 startDate: timelineStartDate,
//                 stickyAreaWeekBuilder: (context) {
//                   return const Text(
//                     'Custom navigation buttons',
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 16,
//                     ),
//                   );
//                 },
//                 stickyAreaDayBuilder: (context) {
//                   return AnimatedBuilder(
//                     animation: scrollController,
//                     builder: (context, _) {
//                       final pos = scrollController.positions.firstOrNull;
//                       final currentOffset = pos?.pixels ?? 0;
//                       final maxOffset = pos?.maxScrollExtent ?? double.infinity;
//                       return Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         // bottom: 0,
//                         children: [
//                           IconButton(
//                             onPressed: currentOffset > 0
//                                 ? () {
//                                     scrollController
//                                         .jumpTo(scrollController.offset - 50);
//                                   }
//                                 : null,
//                             color: Colors.black,
//                             icon: const Icon(
//                               Icons.arrow_left,
//                               size: 28,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           IconButton(
//                             onPressed: currentOffset < maxOffset
//                                 ? () {
//                                     scrollController
//                                         .jumpTo(scrollController.offset + 50);
//                                   }
//                                 : null,
//                             color: Colors.black,
//                             icon: const Icon(
//                               Icons.arrow_right,
//                               size: 28,
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 scrollController: scrollController,
//                 maxDuration: const Duration(days: (30 * 10) + 2),
//                 dayWidth: dayWidth,
//                 eventHeight: 40,
//                 stickyAreaWidth: 200,
//                 showStickyArea: showStickyArea,
//                 stickyAreaEventBuilder: customStickyArea
//                     ? (context, eventIndex, event, eventColor) => eventIndex ==
//                             0
//                         ? Container(
//                             color: Colors.yellow,
//                             child: Center(
//                               child:
//                                   Text("Custom Widget: ${event.displayName}"),
//                             ),
//                           )
//                         : GanttChartDefaultStickyAreaCell(
//                             event: event,
//                             eventIndex: eventIndex,
//                             eventColor: eventColor,
//                             widgetBuilder: (context) => Text(
//                               "Default Widget with custom colors: ${event.displayName}",
//                               textAlign: TextAlign.center,
//                             ),
//                           )
//                     : null,
//                 weekHeaderBuilder: customWeekHeader
//                     ? (context, weekDate) => GanttChartDefaultWeekHeader(
//                         weekDate: weekDate,
//                         color: Colors.black,
//                         backgroundColor: Colors.yellow,
//                         border: const BorderDirectional(
//                           end: BorderSide(color: Colors.green),
//                         ))
//                     : null,
//                 dayHeaderBuilder: customDayHeader
//                     ? (context, date, bool isHoliday) =>
//                         GanttChartDefaultDayHeader(
//                           date: date,
//                           isHoliday: isHoliday,
//                           color: isHoliday ? Colors.yellow : Colors.black,
//                           backgroundColor:
//                               isHoliday ? Colors.grey : Colors.yellow,
//                         )
//                     : null,
//                 showDays: showDaysRow,
//                 // weekEnds: const {WeekDay.saturday, WeekDay.sunday},
//                 isExtraHoliday: (context, day) {
//                   //define custom holiday logic for each day
//                   return DateUtils.isSameDay(DateTime(2024, 7, 1), day);
//                 },
//                 startOfTheWeek: WeekDay.sunday,
//                 events: events,
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return TaskFormDialog(
//                   addTask: addTask,
//                   timelineStartDate: timelineStartDate,
//                 );
//               },
//             );
//           },
//           tooltip: 'Add Task',
//           child: const Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }

// class TaskFormDialog extends StatefulWidget {
//   final Function(String taskName, DateTime beginDate, DateTime endDate) addTask;
//   final DateTime timelineStartDate;

//   const TaskFormDialog({
//     Key? key,
//     required this.addTask,
//     required this.timelineStartDate,
//   }) : super(key: key);

//   @override
//   _TaskFormDialogState createState() => _TaskFormDialogState();
// }

// class _TaskFormDialogState extends State<TaskFormDialog> {
//   late TextEditingController _taskNameController;
//   late DateTime _beginDate;
//   late DateTime _endDate;

//   @override
//   void initState() {
//     super.initState();
//     _taskNameController = TextEditingController();
//     _beginDate = widget.timelineStartDate;
//     _endDate = widget.timelineStartDate.add(const Duration(days: 7));
//   }

//   @override
//   void dispose() {
//     _taskNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add Task'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: _taskNameController,
//             decoration: const InputDecoration(labelText: 'Task Name'),
//           ),
//           SizedBox(height: 16.0),
//           Text('Begin Date: ${_beginDate.toString()}'),
//           SizedBox(height: 16.0),
//           Text('End Date: ${_endDate.toString()}'),
//           SizedBox(height: 16.0),
//           ElevatedButton(
//             onPressed: () {
//               widget.addTask(
//                 _taskNameController.text,
//                 _beginDate,
//                 _endDate,
//               );
//               Navigator.of(context).pop();
//             },
//             child: const Text('Submit'),
//           ),
//         ],
//       ),
//     );
//   }
// }
