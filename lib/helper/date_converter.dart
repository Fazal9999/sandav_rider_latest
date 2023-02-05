import 'package:delivery_man/controller/splash_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringToDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime);
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat(_timeFormatter()).format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateAnTime(String dateTime) {
    return DateFormat('dd/MMM/yyyy ${_timeFormatter()}').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
  }

  static String convertTimeToTime(String time) {
    return DateFormat(_timeFormatter()).format(DateFormat('hh:mm:ss').parse(time));
  }

  static int timeDistanceInMin(String time) {
    DateTime _currentTime = Get.find<SplashController>().currentTime;
    DateTime _rangeTime = dateTimeStringToDate(time);
    return _currentTime.difference(_rangeTime).inMinutes;
  }

  static String _timeFormatter() {
    return Get.find<SplashController>().configModel.timeformat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  static int differenceInMinute(String deliveryTime, String orderTime, int processingTime, String scheduleAt) {
    // 'min', 'hours', 'days'
    int _minTime = processingTime != null ? processingTime : 0;
    if(deliveryTime != null && deliveryTime.isNotEmpty && processingTime == null) {
      try {
        List<String> _timeList = deliveryTime.split('-'); // ['15', '20']
        _minTime = int.parse(_timeList[0]);
      }catch(e) {}
    }
    DateTime _deliveryTime = dateTimeStringToDate(scheduleAt != null ? scheduleAt : orderTime).add(Duration(minutes: _minTime));
    return _deliveryTime.difference(DateTime.now()).inMinutes;
  }

  static bool isBeforeTime(String dateTime) {
    if(dateTime == null) {
      return false;
    }
    DateTime scheduleTime = dateTimeStringToDate(dateTime);
    return scheduleTime.isBefore(DateTime.now());
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('${_timeFormatter()} | d-MMM-yyyy ').format(dateTime.toLocal());
  }

}
