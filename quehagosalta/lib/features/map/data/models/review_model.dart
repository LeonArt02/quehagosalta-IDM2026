class ReviewModel {
  final String id;
  final int rate;
  final String description;
  final String username;
  final DateTime createdAt;
  final String bussinesId; 

  ReviewModel({
    required this.id,
    required this.rate,
    required this.description,
    required this.username,
    required this.createdAt,
    required this.bussinesId,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    
    // 1. Extraemos el usuario de forma segura
    String parsedUsername = 'Usuario anónimo';
    if (json['user'] is Map) {
      // Si Django mandó el diccionario completo
      parsedUsername = json['user']['username'] ?? 'Usuario anónimo';
    } else if (json['user'] is String) {
      // Si Django mandó solo el ID crudo
      parsedUsername = 'Usuario'; 
    }

    // 2. Extraemos el ID del negocio de forma segura
    String parsedBussinesId = '';
    if (json['bussines'] is Map) {
      // Si Django mandó el diccionario completo {'id': '...', 'name': '...'}
      parsedBussinesId = json['bussines']['id'] ?? '';
    } else if (json['bussines'] is String) {
      // Si Django mandó solo el ID crudo
      parsedBussinesId = json['bussines'];
    }

    return ReviewModel(
      id: json['id'] ?? '',
      rate: json['rate'] ?? 0, // Siempre es bueno poner un valor por defecto
      description: json['description'] ?? '',
      username: parsedUsername,
      bussinesId: parsedBussinesId,
      // 3. Protegemos la fecha por si viene nula
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
  /*
  
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      rate: json['rate'],
      description: json['description'] ?? '',
      // Accedemos al diccionario anidado 'user' que armaste en Django
      username: json['user']['username'] ?? 'Usuario anónimo', 
      createdAt: DateTime.parse(json['created_at']),
      bussinesId: json['bussines'] ?? '', 
    );
    }
  */
  
  }