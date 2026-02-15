# iOS App Store screenshots

Put screenshots by locale:
- `ios/fastlane/screenshots/en-US/*.png`
- `ios/fastlane/screenshots/ru/*.png`

Recommended naming pattern (stable order, no collisions):
- iPhone: `01_iphone_<screen>.png`, `02_iphone_<screen>.png`, ...
- iPad: `01_ipad_<screen>.png`, `02_ipad_<screen>.png`, `03_ipad_<screen>.png`

Example:
- `01_iphone_home.png`
- `02_iphone_chat.png`
- `01_ipad_home.png`
- `02_ipad_chat.png`
- `03_ipad_profile.png`

Fastlane uploads screenshots during `ios upload_app_store` (main branch release).
`overwrite_screenshots` is enabled, so updated screenshots replace previous ones.
