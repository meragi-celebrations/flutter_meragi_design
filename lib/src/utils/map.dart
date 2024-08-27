/// Retrieves a value from a map based on the provided enum value.
///
/// Args:
///   enumValue (T): The enum value to look up in the map.
///   map (Map<T, dynamic>): The map to search for the enum value.
///   defaultValue (dynamic): The value to return if the enum value is not found in the map.
///
/// Returns:
///   dynamic: The value associated with the enum value in the map, or the default value if not found.
dynamic valueFromMap<T>(T enumValue, Map<T, dynamic> map,
    [dynamic defaultValue]) {
  return map[enumValue] ?? defaultValue;
}
