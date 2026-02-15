# iOS App Store screenshots

Put screenshots by locale:
- `ios/fastlane/screenshots/en-US/*.png`
- `ios/fastlane/screenshots/ru/*.png`

Fastlane uploads screenshots during `ios upload_app_store` (main branch release).
`overwrite_screenshots` is enabled, so updated screenshots replace previous ones.