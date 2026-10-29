import 'package:dio/dio.dart';
import 'package:todo_gabarito/modules/habits/infra/datasources/habitsDatasource.dart';

class HabitApiDatasoucers implements HabitsDatasource {
  final Dio dio = Dio();

  @override
  Future<List<Map<String, dynamic>>> fetchHabits() async {
    final res = await dio.get<List<dynamic>>('/habits');
    return res.data!.cast<Map<String, dynamic>>();
  }
}
