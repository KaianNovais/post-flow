Post Flow
Um aplicativo móvel desenvolvido com Flutter para autenticação OAuth e consumo de API pública de posts.

📋 Sobre o Projeto
Post Flow é uma aplicação desenvolvida em Flutter que implementa autenticação via Firebase, consumo da API do JSONPlaceholder, e oferece uma interface amigável para visualização de posts. O projeto segue os princípios de Clean Architecture com divisão em camadas e utiliza o Bloc para gerenciamento de estado.

✨ Funcionalidades
Autenticação

Login via Firebase Authentication (e-mail e senha)
Persistência de sessão
Logout

Posts

Listagem de posts da API JSONPlaceholder
Paginação (10 posts por carregamento)
Exibição de detalhes do post incluindo autor
Visualização truncada com opção "Ver mais"



🛠️ Tecnologias Utilizadas

Flutter
Firebase Authentication
Dio para requisições HTTP
Flutter Bloc para gerenciamento de estado
Clean Architecture
Princípios SOLID

🔧 Configuração do Projeto
Pré-requisitos

Flutter (versão mais recente)
Firebase 
Dio
Flutter Bloc

Instalação

Clone o repositório:

git clone https://github.com/KaianNovais/post-flow.git

Navegue até o diretório do projeto:


Instale as dependências:

flutter pub get

Execute o aplicativo:

flutter run

Credenciais para Teste
Para facilitar os testes, você pode usar as seguintes credenciais:

Email: admin@admin.com
Senha: admin2025

🧪 Testes
O projeto inclui testes automatizados usando Flutter Test e Mocktail.
Para executar os testes de autenticação:
flutter test test/auth_test.dart

🏗️ Arquitetura
O projeto utiliza Clean Architecture para garantir uma separação clara de responsabilidades e facilitar a manutenção e testabilidade do código. Esta arquitetura divide a aplicação em camadas:
1. Domain Layer
Contém as regras de negócio da aplicação e é independente de frameworks externos:

Entities: Representam os objetos de domínio (User, Post)
Use Cases: Implementam operações específicas de negócio
Repositories (interfaces): Definem contratos para acesso a dados

2. Data Layer
Implementa a camada de acesso a dados:

Models: Extensões das entidades com métodos de conversão
Repositories (implementações): Implementam as interfaces definidas no Domain
Data Sources: Responsáveis pela comunicação com APIs e Firebase

3. Presentation Layer
Lida com a interface do usuário:

BLoC: Gerencia o estado da aplicação de forma reativa
Pages: Telas da aplicação
Widgets: Componentes reutilizáveis da UI

Vantagens desta arquitetura:

Testabilidade: Facilita a criação de testes unitários e de integração
Manutenibilidade: Código organizado e de fácil compreensão
Escalabilidade: Permite adicionar novos recursos sem afetar o código existente
Independência de frameworks: As regras de negócio não dependem de bibliotecas externas