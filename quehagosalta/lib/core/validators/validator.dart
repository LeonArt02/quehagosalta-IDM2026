class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el email';
    }

    final bool emailValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(value);

    if (!emailValid) {
      return 'Email inválido';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese la contraseña';
    }

    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }

    return null;
  }

  static String? requiredField(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese $field';
    }

    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }

    return null;
  }

  static String? cuil(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el CUIL';
    }

    // Extraemos únicamente los números (eliminando los guiones del formato visual)
    final cleanCuil = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanCuil.length != 11) {
      return 'El CUIL debe tener 11 dígitos';
    }
  }
}
