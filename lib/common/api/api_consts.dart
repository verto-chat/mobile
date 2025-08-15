const String notAuthExtraKey = 'notAuth';

/// Запрос на сервер работает корректно без токена авторизации
const Map<String, Object> notAuthExtra = {notAuthExtraKey: true};

const String bothAuthExtraKey = 'bothAuth';

/// Запрос на сервер работает корректно с токеном авторизации и без
const Map<String, Object> bothAuthExtra = {bothAuthExtraKey: true};
