# Google Play metadata

Fastlane uploads these files only for production releases from `main`.

## Locale files
- `en-US/title.txt`
- `en-US/short_description.txt`
- `en-US/full_description.txt`
- `ru-RU/title.txt`
- `ru-RU/short_description.txt`
- `ru-RU/full_description.txt`

## Screenshots
Put screenshots here:
- `en-US/images/phoneScreenshots/*.png`
- `ru-RU/images/phoneScreenshots/*.png`

Recommended naming:
- `01_create_local_chats.png`
- `02_translation_chat.png`

When screenshots are changed, commit updated image files to re-upload them on the next production release.

## Release notes (What's new)
CI generates changelog files automatically for production releases from `main`:
- `en-US/changelogs/<build_number>.txt`
- `ru-RU/changelogs/<build_number>.txt`

`<build_number>` equals `github.run_number`.
Source is always:
- `en-US/changelogs/default.txt`
- `ru-RU/changelogs/default.txt`

Before upload, CI copies each `default.txt` to `<build_number>.txt`.
