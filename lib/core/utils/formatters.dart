class Formatters {
  static String usd(double value) {
    if (value.isNaN || value.isInfinite) return r'$—';
    final abs = value.abs();
    final decimals = abs >= 1000
        ? 2
        : abs >= 1
            ? 2
            : abs >= 0.01
                ? 4
                : 6;
    return '\$${value.toStringAsFixed(decimals)}';
  }

  static String percent(double value) {
    if (value.isNaN || value.isInfinite) return '—';
    final sign = value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }
}

