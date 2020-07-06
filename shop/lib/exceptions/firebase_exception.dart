class AuthException implements Exception {
  static Map<String, String> errors = {
    "EMAIL_EXISTS": "E-mail existente",
    "OPERATION_NOT_ALLOWED": "Operação não permitida!",
    "TOO_MANY_ATTEMPS_TRY_LATER": "Tente mais tarde!",
    "EMAIL_NOT_FOUND": "E-mail não encontrado!",
    "INVALID_PASSWORD": "Senha inválida.",
    "USER_DISABLED": "Usuário desativado."
  };
  final String key;

  AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) return errors[key];
    return "Ocorreu um erro na autenticação.";
  }
}
