# flickr-app-swift
 Aplicação de referência, cujo objetivo é exemplificar o uso de Swift para implementação de aplicação para iOS.
 
## Resumo

Baixando este exemplo você vai encontrar o uso de:
 - Integração com a API REST do Flickr: flickr.photos.search e flickr.photos.getSizes
 - Busca através de TAGs
 - Paginação dos resultados integrado com a API REST
 - UI: layout de grade (2 imagens por linha) e otimizado para consumo de memoria.
 - Rolagem infinita do scrooll
 - Uso de Cache (dados de resposta do cache para evitar bater na rede toda vez)
 - Suporte ao App Transport Security (ATS)
 - Chamadas REST com certificado de segurança
 - Testes Unitários
 - Testes de Interface

Para construir foi utilizado:

 - Storyboard
 - Protocol
 - UIView
 - UILabel
 - UITableView
 - UITableViewCell (customização)
 - UIImage
 - UIImageView
 - UIColor
 - UIViewController
 - UITableViewDelegate
 - UITableViewDataSource

Além disso, tem também:
 - Alamofire (Componente de parse HTTP)
 - Autolayout
 - Stack View

## Screenshots
Veja na pasta: Screenshots.

## Construído utilizando

* [Xcode 9.4.1](https://developer.apple.com/xcode) - IDE de desenvolvimento.
* [Cocoa Pods](https://cocoapods.org) - Gerenciador de dependências.
* [Alamofire](https://github.com/Alamofire/Alamofire) - Componente para parse de requisições HTTP.

## Autor

* **João Carlos Brandão Morgado** - *Trabalho Inicial* - [joaobrandao](https://github.com/jocabrandao)

## Licença

MIT 
