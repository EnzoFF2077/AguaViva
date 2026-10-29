# Estrutura de arquitetura

O projeto usa Clean Architecture organizada por funcionalidade (feature-first).

```text
lib/
|-- app/                         # Composicao e configuracao global do app
|   |-- config/
|   |-- di/                     # Injecao de dependencias
|   |-- router/                 # Rotas e navegacao
|   `-- theme/
|-- core/                        # Codigo compartilhado entre features
|   |-- constants/
|   |-- errors/
|   |-- extensions/
|   |-- network/
|   |-- services/
|   |-- usecases/
|   |-- utils/
|   `-- widgets/
|-- features/
|   `-- _feature_template/       # Modelo a ser copiado para cada feature
|       |-- data/
|       |   |-- datasources/
|       |   |   |-- local/
|       |   |   `-- remote/
|       |   |-- models/
|       |   `-- repositories/
|       |-- domain/
|       |   |-- entities/
|       |   |-- repositories/
|       |   `-- usecases/
|       `-- presentation/
|           |-- controllers/
|           |-- pages/
|           `-- widgets/
|-- schema/                      # Schemas realmente globais, se necessarios
|-- firebase_options.dart
`-- main.dart
```

## Dependencias entre camadas

- `presentation` depende de `domain`.
- `data` implementa os contratos definidos em `domain`.
- `domain` nao depende de Flutter, Firebase ou da camada `data`.
- `core` contem apenas recursos reutilizados por mais de uma feature.
- Cada nova funcionalidade deve ter sua propria pasta dentro de `features`.

Modelos e schemas exclusivos de uma feature devem permanecer dentro dela. A
pasta global `schema` deve ser usada somente quando um schema for realmente
compartilhado por diferentes features.
