class TimeCalculation{
  static String getTimeDiff(DateTime createdDate){
    DateTime now = DateTime.now();
    Duration timeDiff = now.difference(createdDate);
    if(timeDiff.inMinutes <= 5){
      return '방금 전';
    } else if(timeDiff.inMinutes <= 60){
      return '${timeDiff.inMinutes}분전';
    } else if(timeDiff.inHours<=24){
      return '${timeDiff.inHours}시간전';
    } else{
      int dayBefore = timeDiff.inHours~/24;
      return '$dayBefore일전';
    }
  }
}