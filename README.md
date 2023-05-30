# Currency - iOS Native [Fixer REST API][Fixer REST API] Client 


## Project Highlights: 

- Uncle Bob Clean Architecture.
- UIKit and SwiftUI with iOS 13 Deployment Target.
- MVVM with [RxSwift][RxSwift] & [RxCocoa][RxSwift] in Presentation Layer.
- Dependency Injection.
- Unit Testing with Mocks and Stubs.
- Uses Swift Package Manager for managing Dependencies.

## Screenshots: 

<p align="center">
<img src="Media/Converter-1.png" width="200" height="433">
<img src="Media/Converter-2.png" width="200" height="433">
<img src="Media/Converter-3.png" width="200" height="433">
</p>

## Project Layers: 

- Domain Layer = Entities + Use Cases + Repositories Interfaces
- Data Layer = Repositories Implementations + Remote (API) + Data Model
- Presentation Layer (MVVM) = ViewController - ViewModels - Views ( Custom Cells, Headers, etc ..) 

***Look at this diagaram will explain how Clean Architecture works***

![CleanArchitectureDependencies](https://user-images.githubusercontent.com/72504852/221656809-fcde020e-f7d9-48eb-964e-1f9fe2b07718.png)

## Video Demo:

<p align="center">
<video width="200" height="433" controls muted markdown="1">
  <source src="Media/Demo.mp4" type="video/mp4">
</video>
</p>


## Notes:

- [Fixer REST API][Fixer REST API] free subscription is limited with 100 request per month.
- This App Don't Use Any Third Party Libraries.

[Swift]: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/
[Fixer REST API]: https://apilayer.com/marketplace/fixer-api
[contact]: https://www.linkedin.com/in/ali-fayed-8682aa1a6/
[RxSwift]: https://github.com/ReactiveX/RxSwift