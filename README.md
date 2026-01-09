# GoRotas - Cliente

Aplicativo de passagens de vans e transportes.

## 🚀 Configuração do Projeto

### Pré-requisitos

- Flutter SDK (3.x ou superior)
- Dart SDK
- Firebase CLI
- Conta no Firebase

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/gorotas_client.git
cd gorotas_client
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure o Firebase

Os arquivos de configuração do Firebase não estão incluídos no repositório por segurança.

**Opção A - Usando FlutterFire CLI (recomendado):**

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

**Opção B - Configuração manual:**

1. Copie os arquivos de exemplo:

```bash
cp lib/firebase_options.dart.example lib/firebase_options.dart
cp android/app/google-services.json.example android/app/google-services.json
```

2. Substitua os valores `YOUR_*` pelas credenciais do seu projeto Firebase.

### 4. Execute o app

```bash
flutter run
```

## 📁 Estrutura do Projeto

```
lib/
├── colors/          # Cores do app
├── models/          # Modelos de dados
├── providers/       # State management (Provider)
├── routes/          # Rotas do app
├── screens/         # Telas principais
│   └── contents/    # Conteúdos das telas
├── services/        # Serviços (Firebase, API)
└── widgets/         # Widgets reutilizáveis
```

## 🔒 Segurança

Arquivos sensíveis que **NÃO** devem ser commitados:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- Arquivos `.env`
- Keystores (`.jks`, `.keystore`)

## 📚 Recursos

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Provider Package](https://pub.dev/packages/provider)
