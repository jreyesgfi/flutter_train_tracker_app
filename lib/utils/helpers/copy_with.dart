library copy_with_utils;

const copyWithUnset = Object();

T? valueOrCurrent<T>(Object? candidate, T? current) =>
    identical(candidate, copyWithUnset) ? current : candidate as T?;