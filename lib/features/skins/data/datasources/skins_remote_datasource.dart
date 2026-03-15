import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:test_cloude/core/error/exceptions.dart';
import 'package:test_cloude/features/skins/data/models/skin_model.dart';

abstract class SkinsRemoteDataSource {
  Future<List<SkinModel>> getSkins();
}

class SkinsRemoteDataSourceImpl implements SkinsRemoteDataSource {
  final Dio dio;

  static const String _skinsUrl =
      'https://raw.githubusercontent.com/ByMykel/CSGO-API/main/public/api/en/skins.json';

  SkinsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SkinModel>> getSkins() async {
    try {
      final response = await dio.get(
        _skinsUrl,
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      final List<dynamic> jsonList;
      if (response.data is String) {
        jsonList = json.decode(response.data as String) as List<dynamic>;
      } else {
        jsonList = response.data as List<dynamic>;
      }

      return jsonList
          .map((item) => SkinModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException('Failed to load skins: $e');
    }
  }
}
