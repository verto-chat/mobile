# mobile

VertoChat - Mobile App

## Getting Started

### Команды на генерацию OpenApi:

```bash
npx @openapitools/openapi-generator-cli generate -i https://verto-chat-ekaadnatandjb7h7.germanywestcentral-01.azurewebsites.net/openapi/v1.json -g dart-dio -o ./ --skip-validate-spec --additional-properties "serializationLibrary=json_serializable,skipCopyWith=true"
```
