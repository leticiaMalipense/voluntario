
enum JobType {
  RECURRENT,
  SINGLE
}

class JobTypeHelper {

  static String getValue(JobType type){
    switch(type){
      case JobType.RECURRENT:
        return "RECURRENT";
      case JobType.SINGLE:
        return "SINGLE";
      default:
        return "";
    }
  }

  static JobType getType(String value){
    switch(value){
      case "RECURRENT":
        return  JobType.RECURRENT;
      case "SINGLE":
        return JobType.SINGLE;
      default:
        return null;
    }
  }

}
