import 'domain_error_type.dart';

sealed class DomainResult<T, E> {}

final class Success<T, E> extends DomainResult<T, E> {
  final T data;

  Success({required this.data});
}

final class Error<T, E> extends DomainResult<T, E> {
  final E errorData;

  Error({required this.errorData});
}

typedef EmptyDomainResult = DomainResult<void, DomainErrorType>;

/// domain result with default error
typedef DomainResultDErr<T> = DomainResult<T, DomainErrorType>;
