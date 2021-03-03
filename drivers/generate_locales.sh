flutter pub get

flutter pub run intl_translation:extract_to_arb \
    --output-dir=lib/l10n \
    lib/strings.dart

flutter pub run intl_translation:generate_from_arb \
    --output-dir=lib/l10n \
    --no-use-deferred-loading \
    lib/strings.dart \
    lib/l10n/intl_*.arb