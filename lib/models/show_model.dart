class ShowModel {
  final int id;
  final String name;
  final List<String> genres;
  final String? status;
  final int? runtime;
  final String? premiered;
  final String? officialSite;
  final double? rating;
  final String? mediumImage;
  final String? originalImage;
  final String? summary;
  final String? language;

  ShowModel({
    required this.id,
    required this.name,
    required this.genres,
    this.status,
    this.runtime,
    this.premiered,
    this.officialSite,
    this.rating,
    this.mediumImage,
    this.originalImage,
    this.summary,
    this.language,
  });

  String get displayImage => originalImage ?? mediumImage ?? '';

  String get ratingText {
    if (rating == null || rating == 0.0) return 'N/A';
    return rating!.toStringAsFixed(1);
  }

  String get genreText {
    if (genres.isEmpty) return 'General';
    return genres.join(', ');
  }

  String get premieredYear {
    if (premiered == null || premiered!.isEmpty) return '';
    try {
      final parts = premiered!.split('-');
      if (parts.isNotEmpty) return parts[0];
    } catch (_) {}
    return premiered!;
  }

  String get cleanSummary {
    if (summary == null || summary!.trim().isEmpty) {
      return 'Tidak ada ringkasan atau sinopsis yang tersedia untuk show ini.';
    }
    // Remove HTML tags
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    String clean = summary!.replaceAll(exp, '');
    clean = clean
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();
    return clean;
  }

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    double? parsedRating;
    if (json['rating'] != null && json['rating'] is Map) {
      final avg = json['rating']['average'];
      if (avg != null) {
        if (avg is num) {
          parsedRating = avg.toDouble();
        } else if (avg is String) {
          parsedRating = double.tryParse(avg);
        }
      }
    }

    String? medImg;
    String? origImg;
    if (json['image'] != null && json['image'] is Map) {
      medImg = json['image']['medium']?.toString();
      origImg = json['image']['original']?.toString();
    }

    List<String> parsedGenres = [];
    if (json['genres'] != null && json['genres'] is List) {
      parsedGenres = (json['genres'] as List)
          .map((item) => item.toString())
          .toList();
    }

    int? parsedRuntime;
    if (json['runtime'] != null) {
      if (json['runtime'] is int) {
        parsedRuntime = json['runtime'];
      } else {
        parsedRuntime = int.tryParse(json['runtime'].toString());
      }
    }

    return ShowModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? 'Untitled Show',
      genres: parsedGenres,
      status: json['status']?.toString(),
      runtime: parsedRuntime,
      premiered: json['premiered']?.toString(),
      officialSite: json['officialSite']?.toString(),
      rating: parsedRating,
      mediumImage: medImg,
      originalImage: origImg,
      summary: json['summary']?.toString(),
      language: json['language']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genres': genres,
      'status': status,
      'runtime': runtime,
      'premiered': premiered,
      'officialSite': officialSite,
      'rating': rating != null ? {'average': rating} : null,
      'image': {
        if (mediumImage != null) 'medium': mediumImage,
        if (originalImage != null) 'original': originalImage,
      },
      'summary': summary,
      'language': language,
    };
  }
}
