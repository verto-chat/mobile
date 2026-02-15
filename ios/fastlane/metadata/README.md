# iOS App Store metadata

Fastlane reads metadata from:
- `ios/fastlane/metadata/en-US/*`
- `ios/fastlane/metadata/ru/*`
- `ios/fastlane/metadata/copyright.txt` (non-localized)

Editable files per locale:
- `name.txt`
- `subtitle.txt`
- `description.txt`
- `keywords.txt`
- `promotional_text.txt`
- `release_notes.txt`
- `support_url.txt`
- `marketing_url.txt`
- `privacy_url.txt`

Metadata is uploaded on `main` in lane `ios upload_app_store`.
