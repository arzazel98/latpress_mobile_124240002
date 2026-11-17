import 'package:flutter_test/flutter_test.dart';
import 'package:latres_cipaip14purple/models/show_model.dart';
import 'package:latres_cipaip14purple/services/auth_service.dart';

void main() {
  group('ShowModel Tests', () {
    test('ShowModel correctly parses JSON with HTML summary and rating', () {
      final json = {
        'id': 1,
        'name': 'Under the Dome',
        'genres': ['Drama', 'Science-Fiction', 'Thriller'],
        'status': 'Ended',
        'runtime': 60,
        'premiered': '2013-06-24',
        'officialSite': 'http://www.cbs.com/shows/under-the-dome/',
        'rating': {'average': 6.6},
        'image': {
          'medium': 'https://static.tvmaze.com/uploads/images/medium_portrait/610/1525272.jpg',
          'original': 'https://static.tvmaze.com/uploads/images/original_untouched/610/1525272.jpg',
        },
        'summary': '<p><b>Under the Dome</b> is the story of a small town.</p>',
        'language': 'English',
      };

      final show = ShowModel.fromJson(json);

      expect(show.id, 1);
      expect(show.name, 'Under the Dome');
      expect(show.genres, ['Drama', 'Science-Fiction', 'Thriller']);
      expect(show.rating, 6.6);
      expect(show.ratingText, '6.6');
      expect(show.cleanSummary, 'Under the Dome is the story of a small town.');
      expect(show.premieredYear, '2013');
      expect(show.displayImage, 'https://static.tvmaze.com/uploads/images/original_untouched/610/1525272.jpg');
    });

    test('ShowModel handles null fields safely', () {
      final json = {
        'id': 99,
        'name': 'Mysterious Show',
      };

      final show = ShowModel.fromJson(json);

      expect(show.id, 99);
      expect(show.name, 'Mysterious Show');
      expect(show.genres, isEmpty);
      expect(show.rating, isNull);
      expect(show.ratingText, 'N/A');
      expect(show.mediumImage, isNull);
      expect(show.originalImage, isNull);
      expect(show.displayImage, '');
      expect(show.cleanSummary, contains('Tidak ada ringkasan'));
    });
  });

  group('Auth Requirements Tests', () {
    test('Default NIM is 124240002 and password is 123', () {
      expect(AuthService.requiredNim, '124240002');
      expect(AuthService.requiredPassword, '123');
    });
  });
}
