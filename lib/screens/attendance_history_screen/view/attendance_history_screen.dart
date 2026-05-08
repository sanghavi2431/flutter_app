import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/view/iot_onbaord.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/bloc/history_list_bloc.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/bloc/history_list_event.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/bloc/history_list_state.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/data/model/attendance_history_model.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/data/model/month_list_model.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/view/local_widgets/history_list_widget.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/error_widget.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/leading_button.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:excel/excel.dart' as ex;
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../main.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({
    super.key,
  });

  @override
  State<AttendanceHistoryScreen> createState() =>
      AttendanceHistoryScreenState();
}

class AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  var monthItems = [
    MyAttendanceHistoryScreenConstants.JAN.tr(),
    MyAttendanceHistoryScreenConstants.FEB.tr(),
    MyAttendanceHistoryScreenConstants.MAR.tr(),
    MyAttendanceHistoryScreenConstants.APR.tr(),
    MyAttendanceHistoryScreenConstants.MAY.tr(),
    MyAttendanceHistoryScreenConstants.JUN.tr(),
    MyAttendanceHistoryScreenConstants.JUL.tr(),
    MyAttendanceHistoryScreenConstants.AUG.tr(),
    MyAttendanceHistoryScreenConstants.SEP.tr(),
    MyAttendanceHistoryScreenConstants.OCT.tr(),
    MyAttendanceHistoryScreenConstants.NOV.tr(),
    MyAttendanceHistoryScreenConstants.DEC.tr()
  ];
  List<MonthListModel> _data = [];
  List<AttendanceHistoryModel> _historyData = [];

  String dropdownvalue = MyAttendanceHistoryScreenConstants.SELECT.tr();
  final HistoryListBloc _historyListBloc = HistoryListBloc();
  bool showList = false;
  MonthListModel? selectedMonth;

  String year = "";
  List<DateTime> absentDates = [];
  List<DateTime> presentDates = [];
  List<DateTime> clockedDates = [];
  String? selectedValue;

  bool isChecked = false;

  @override
  void initState() {
    _historyListBloc.add(const GetAllMonths());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leadingWidth: 100,
          leading: const LeadingButton(),

          backgroundColor: AppColors.white,
          elevation: 0,
        ),
        body: BlocConsumer(
            bloc: _historyListBloc,
            listener: (context, state) {
              // if (state is MonthListSuccess) {
              //   EasyLoading.dismiss();

              // }
              // if (state is HistoryListSuccess) {
              //   EasyLoading.dismiss();

              // }
            },
            builder: (context, state) {
              if (state is MonthListLoading) {
                EasyLoading.show(status: MydashboardScreenConstants.LOADING_TOAST.tr());
              } else if (state is MonthListError) {
                EasyLoading.dismiss();
                return CustomErrorWidget(error: state.error.message);
              }
              else if(state is MonthListEmpty){
                EasyLoading.dismiss();
                return Center(child: Text(state.error.message,
                  style: const TextStyle(fontSize: 20),));
              }
              else if (state is MonthListSuccess) {
                _data = state.data;

                _historyListBloc.add(GetAllHistory(
                    month: _data.last.month ?? '',
                    year: _data.last.year ?? ''));
                EasyLoading.dismiss();

                return SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      child: Text(
                          MyJanitorProfileScreenConstants.ATTENDANCE_HISTORY.tr(),
                          textAlign: TextAlign.start,
                          style: AppTextStyle.font24bold.copyWith(
                            color: AppColors.black,
                          )),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          child: SizedBox(
                            width: 140.w,
                            height: 50.h,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,

                                // 🔽 Dynamic Icon Change
                                // onMenuStateChange: (isOpen) {
                                //   isOpenDrop = isOpen;
                                //   setState(() {});
                                // },
                                // iconStyleData: IconStyleData(
                                //   icon: isOpenDrop == true
                                //       ? const Icon(Icons.keyboard_arrow_up_rounded,
                                //           size: 28, color: Color(0xff8F8F8F))
                                //       : const Icon(Icons.keyboard_arrow_down_rounded,
                                //           size: 28, color: Color(0xff8F8F8F)),
                                // ),

                                // 🔽 Dropdown Style
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.white,
                                  ),
                                ),

                                // 🔽 Hint (When nothing is selected)
                                hint: Text(
                                  MyAttendanceHistoryScreenConstants.SELECT
                                      .tr(),
                                  style: AppTextStyle.font14w6.copyWith(
                                    color: const Color(0xff8F8F8F),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                // 🔽 Items List
                                items: <String>[
                                  'Admin',
                                  'Task Buddy',
                                  'Supervisor'
                                ].map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item!,
                                      style: AppTextStyle.font10bold.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff8F8F8F)),
                                    ),
                                  );
                                }).toList(),

                                // 🔽 Selected Value
                                // value: _data.firstWhere(
                                //   (m) => m.month == selectedMonth && m.year == year,
                                //   orElse: () => null,
                                // ),

                                // 🔽 On Change
                                onChanged: (item) {
                                  // if (item != null) {
                                  //   setState(() {
                                  //     selectedMonth = item.month ?? '';
                                  //     year = item.year ?? '';
                                  //   });

                                  //   _historyListBloc.add(
                                  //     GetAllHistory(month: item.month ?? '', year: item.year ?? ''),
                                  //   );
                                  // }
                                },

                                // 🔽 Button Style
                                buttonStyleData: ButtonStyleData(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(50),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),

                                // 🔽 Each Menu Item Style
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // !showList
                    //     ?
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100.h,
                            ),
                            CustomImageProvider(
                              image: AppImages.blankListImg,
                              height: 100.h,
                              width: 100.w,
                            ),
                            Text(
                                MyAttendanceHistoryScreenConstants
                                    .BLANK_LIST_TEXT
                                    .tr(),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: AppTextStyle.font24.copyWith(
                                  color: AppColors.black,
                                ))
                          ],
                        ),
                      ),
                    )
                    //     : HistoryListWidget(
                    //         onTapItem: () {},
                    //         data: _historyData,
                    //       ),
                  ],
                ));

                //const EmptyListWidget();
              } else if (state is HistoryListLoading) {
                EasyLoading.show(
                    status: MydashboardScreenConstants.LOADING_TOAST.tr());
              } else if (state is HistoryListError) {
                EasyLoading.dismiss();
                return CustomErrorWidget(error: state.error.message);
              } else if (state is HistoryListSuccess) {
                _historyData = state.data;
                showList = true;

                for (var attendance in _historyData) {
                  if (attendance.attendance == "Absent") {
                    absentDates.add(_parseDate(attendance.date ?? "01"));
                  }
                  // else  if(attendance.attendance == "Absent" && isChecked ){
                  // //   clockedDates.add(_parseDate(attendance.date ?? "01"));
                  //  }
                  else if (attendance.attendance == "Present") {
                    presentDates.add(_parseDate(attendance.date ?? "01"));
                  }
                }
                EasyLoading.dismiss();
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 15.w,
                            // vertical: 10.h,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (selectedMonth == null) {
                                Fluttertoast.showToast(
                                    backgroundColor: Colors.red,
                                    msg: "Please select month from drop down ");
                              } else {
                                var month = monthItems[
                                    (int.tryParse(selectedMonth.toString()) ??
                                            1) -
                                        1];
                                export(
                                    _data, _historyData, month, year, context);
                              }

                              // setState(() {

                              // });
                              print("sdfds$selectedMonth");
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 8.h),
                              child: Container(
                                width: 140.w,
                                height: 48.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppColors.acceptButtonColor,
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  MyAttendanceHistoryScreenConstants
                                      .DOWNLOAD_TO_EXCEL
                                      .tr(),
                                  style: AppTextStyle.font12w7
                                      .copyWith(color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<MonthListModel>(
                              //  onMenuStateChange: (isOpen) {
                              //    print( "is oner $isOpen");
                              //    isOpenDrop = isOpen;
                              //    setState(() {

                              //    });

                              //  },
                              //  iconStyleData: IconStyleData(
                              //       icon:
                              //       isOpenDrop! ?
                              //        const Icon( Icons.keyboard_arrow_up_rounded,
                              //        size: 38,
                              //          color: Color(0xff8F8F8F)
                              //        )
                              //       :
                              //        const Icon( Icons.keyboard_arrow_down_rounded,
                              //        size: 38,
                              //          color: Color(0xff8F8F8F)
                              //        )
                              //     ),
                              dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.white)),
                              isExpanded: true,
                              hint: Text(
                                "select".tr(),
                                style: AppTextStyle.font10bold.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff8F8F8F)),
                              ),

                              items: _data.map((MonthListModel item) {
                                return DropdownMenuItem<MonthListModel>(
                                  value: item,
                                  child: Text(
                                    "${monthItems[(int.tryParse(item.month.toString()) ?? 1) - 1]} ${item.year}",
                                    style: AppTextStyle.font10bold.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff8F8F8F)),
                                  ),
                                );
                              }).toList(),
                              value:
                                  selectedMonth, // This should be a FacilityDropdownModel?
                              onChanged: (value) {
                                print(" skdjd $value");
                                setState(() {
                                  selectedMonth = value;
                                });

                                //  var i = item as MonthListModel;
                                //                selectedMonth = i!;
                                //                year = value!;
                                _historyListBloc.add(GetAllHistory(
                                    month: value!.month ?? '',
                                    year: value.year ?? ''));
                                // if(selectedValue == "Admin" ){
                                //          Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                                //             return const ClientLogin();
                                //             // return const ClientLogin();
                                //          },  ) );
                                //        }
                                //        else{
                                //            Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                                //             return const LoginScreen(
                                //               type: "sdfs",
                                //             );
                                //          },  ) );
                                //        }
                              },

                              buttonStyleData: ButtonStyleData(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                height: 65,
                                width: 140.w,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withAlpha(50), // ✅ Corrected
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              menuItemStyleData:
                                  const MenuItemStyleData(height: 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildSingleDatePickerWithValue(state.data),
                    !showList
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 100.h,
                                  ),
                                  CustomImageProvider(
                                    image: AppImages.blankListImg,
                                    height: 100.h,
                                    width: 100.w,
                                  ),
                                  Text(
                                      MyAttendanceHistoryScreenConstants
                                          .BLANK_LIST_TEXT
                                          .tr(),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.font24.copyWith(
                                        color: AppColors.black,
                                      ))
                                ],
                              ),
                            ),
                          )
                        : HistoryListWidget(
                            onTapItem: () {},
                            data: _historyData,
                          ),
                  ],
                ));

                //const EmptyListWidget();
              }
              return const SizedBox();
            }));
  }

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];

  Color getDayColor(data, DateTime date) {
    // Check if the attendance data has an entry for this specific date
    // final attendanceForDate = data.where((attendance) {
    //   return _isSameDate(_parseDate(attendance.date ?? "01"), date);
    // }).toList();
    //
    // // Return colors based on the attendance status
    // if (attendanceForDate.isNotEmpty) {
    //   final status = attendanceForDate.first.attendance;
    //   if (status == "Absent") {
    //     return Colors.red;  // Red for Absent
    //   } else if (status == "Present") {
    //     return Colors.green;  // Green for Present
    //   } else if (status == "SH") {
    //     return Colors.orange;  // Orange for Sick Leave or Holiday (SH)
    //   }
    // }
    data["Present${date.day}"] == "Present" ? Colors.red : Colors.green;

    return Colors.transparent; // Default color for no entry
  }

// Helper function to compare dates without considering time
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

// Helper function to parse the date from a string like "01" (day)
  DateTime _parseDate(String day) {
    int dayInt = int.parse(day);
    return DateTime(DateTime.now().year, DateTime.now().month, dayInt);
  }


  Widget _buildSingleDatePickerWithValue(
      List<AttendanceHistoryModel> historyData) {
    final config = CalendarDatePicker2Config(
      // historyData: historyData,
      selectedDayHighlightColor: Colors.amber[900],
      weekdayLabels: [
        'sun'.tr(),
        'mon'.tr(),
        'tue'.tr(),
        'wed'.tr(),
        'thu'.tr(),
        'fri'.tr(),
        'sat'.tr(),
      ],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      hideMonthPickerDividers: false,

      // disabledYearTextStyle: ,
      // yearBuilder: ({decoration, isCurrentYear, isDisabled, isSelected, textStyle, required year}) {
      //   return  Container();
      // },
      firstDayOfWeek: 1,
      controlsHeight: 50,
      dayMaxWidth: 25,
      animateToDisplayedMonthDate: true,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),
      centerAlignModePicker: true,
      useAbbrLabelForMonthModePicker: true,
      modePickersGap: 20,
      // Custom dayBuilder to add red/green dots below the date
      dayBuilder: (
          {required date,
          decoration,
          isDisabled,
          isPresent,
          isSelected,
          isToday,
          textStyle}) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2), // Space between date and dot

            //   historyData.map( (e){} ).toList()
            Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: absentDates
                        .any((absentDate) => _isSameDate(absentDate, date))
                    ? Colors.red // Red dot for absent days
                    : presentDates.any(
                            (presentDate) => _isSameDate(presentDate, date))
                        ? Colors.green // Green dot for present days
                        : Colors.transparent,
                // absentDates.any((absentDate) => _isSameDate(absentDate, date))
                //      ? Colors.red // Red dot for absent days
                //      : presentDates.any((presentDate) => _isSameDate(presentDate, date))
                //      ? Colors.green // Green dot for present days
                //      : Colors.transparent, // No dot for other days
              ),
            ),
          ],
        );
      },
      // dayBuilder: ({required date, decoration, isDisabled, isSelected, isToday, textStyle}) {
      //   return Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         '${date.day}',
      //         style: const TextStyle(
      //           color: Colors.black,
      //           fontSize: 12,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //       const SizedBox(height: 2), // Space between date and dot
      //
      //     //   historyData.map( (e){} ).toList()
      //       Container(
      //         height: 5,
      //         width: 5,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(5),
      //           color:
      //
      //          absentDates.any((absentDate) => _isSameDate(absentDate, date))
      //               ? Colors.red // Red dot for absent days
      //               : presentDates.any((presentDate) => _isSameDate(presentDate, date))
      //               ? Colors.green // Green dot for present days
      //               : Colors.transparent, // No dot for other days
      //         ),
      //       ),
      //     ],
      //   );
      // },
      selectableDayPredicate: (day) =>
          !day
              .difference(DateTime.now().add(const Duration(days: 3)))
              .isNegative &&
          day.isBefore(DateTime.now().add(const Duration(days: 30))),
    );

    return Container(
      width: 375,
      height: 286,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffC6C6C6)),
          borderRadius: BorderRadius.circular(25)),
      // height: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          //    const Text('Single Date Picker'),
          SizedBox(
            width: MediaQuery.of(context).size.width,

            //MediaQuery.of(context).size.width,
            child: CalendarDatePicker2(
              displayedMonthDate: _singleDatePickerValueWithDefaultValue.first,
              config: config,
              value: _singleDatePickerValueWithDefaultValue,
              onValueChanged: (dates) => setState(
                  () => _singleDatePickerValueWithDefaultValue = dates),
            ),
          ),
          const SizedBox(height: 10),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     const Text('Selection(s):  '),
          //     const SizedBox(width: 10),
          //     Text(
          //       _getValueText(
          //         config.calendarType,
          //         _singleDatePickerValueWithDefaultValue,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

}

snacbar(String title, Color color) {
  return SnackBar(
    backgroundColor: color,
    content: Text(title
        //'Excel Exported successfully'
        ),
  );
}

Future<void> export(
    List<MonthListModel> monthlyData,
    List<AttendanceHistoryModel> historyData,
    String month,
    String year,
    BuildContext context) async {
  if (Platform.isAndroid) {
    await Permission.manageExternalStorage.request();
  } else {
    await Permission.storage.request();
  }

  var status = await Permission.storage.status;
  debugPrint("statd $status");

  final excel = ex.Excel.createExcel();

  var columnIterableSheet = excel['MonthHistory'];
  //    var sheet = excel['mySheet'];
  excel.delete('Sheet1');

  /// unlinking the sheet if any link function is used !!
  excel.unLink('sheet1');

  //  var columnIterabl = excel['ColumnIterables'];

  var date = historyData.map((e) => "${e.date}-$month-$year").toList();
  date.insert(0, "Dates");
  //  var columnIterables = date;

  var chekIn = historyData.map((e) => e.checkIn).toList();
  chekIn.insert(0, "Check In");

  // var checkInColumn = chekIn;

  var chekOut = historyData.map((e) => e.checkOut).toList();
  chekOut.insert(0, "Check Out");

  //  var checkOutColumn = chekOut;

  var attendance = historyData.map((e) => e.attendance).toList();
  attendance.insert(0, "Attendance");

  // var attendanceColumn = attendance;

  List<List<String?>> columnIterables = [date, chekIn, chekOut, attendance];

  for (int columnIndex = 0;
      columnIndex < columnIterables.length;
      columnIndex++) {
    for (int rowIndex = 0;
        rowIndex < columnIterables[columnIndex].length;
        rowIndex++) {
      columnIterableSheet
              .cell(ex.CellIndex.indexByColumnRow(
                  rowIndex: rowIndex, columnIndex: columnIndex))
              .value =
          columnIterables[columnIndex][rowIndex] == null
              ? ex.TextCellValue("-")
              : ex.TextCellValue(columnIterables[columnIndex][rowIndex]!);
    }
  }

  try {
    List<int>? fileBytes = excel.save();

    Directory? directory = Platform.isAndroid
        ? await getApplicationSupportDirectory()
        : await getApplicationDocumentsDirectory();

    debugPrint("andr path ${directory.path}");

    String path = Platform.isAndroid
        ? '${directory.path}/$month-$year.xlsx'
        : '${directory.path}/$month-$year.xlsx';

    var file = File(path);
    file
      ..createSync()
      ..writeAsBytesSync(fileBytes!);
    await mediaStorePlugin.saveFile(
      tempFilePath: file.path,
      dirType: DirType.download,
      dirName: DirType.download.defaults,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snacbar(
          MyAttendanceHistoryScreenConstants.DOWNLOAD_SUCCESS_MESSAGE.tr(),
          AppColors.greenText));
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(snacbar(e.toString(), AppColors.rejectButtonColor));
  }
}
