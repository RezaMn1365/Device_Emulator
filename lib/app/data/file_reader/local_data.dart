abstract class LocalData {
  ///
  ///this function returns devices list based on existing directories on devices directory
  ///
  Future<List<String>> directorySurvey();
  
  ///
  ///this function returns ini file contents from input path directory
  ///
  Future<Map<String, String>?> iniFileReader(String path);
}
