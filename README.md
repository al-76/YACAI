# YACAI
Yet Another Clean Architecture iOS

YACAI is a project showing Yet Another Clean Architecture iOS approach.

[An original idea and description (Robert C. Martin)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

The project uses:
* SwiftUI
* Combine
* [Resolver (DI framework)](https://github.com/hmlongco/Resolver)

## Key ideas
Clean architecture is all about layers.
One suggests using the following layers.
![Architecture layers](https://github.com/al-76/YACAI/blob/main/Images/Sk%C3%A4rmavbild.png)

Any lower layer is dependent on a higher layer.
When a higher layer uses a lower layer we create a protocol on the higher layer and put the implementation to the lower layer.
That way the higher layer dictates his rules to the lower layer (we force to use dependency inversion principle).

For example, we need a use case using a repository. For that, we have repository protocols in Domain/Repository but repository implementations are located in Data/Repository.
So, Domain can use Data but Data is dependent on Domain.

## Application (PLOS client)
The architectural approach is demonstrated on a very simple client of [open academic journal PLOS](https://plos.org/)

![PLOS client](https://github.com/al-76/YACAI/blob/main/Images/Simulator%20Screen%20Recording%20-%20iPhone%2011.gif)


## Unit tests
The application has unit tests.

We test:
* UI (only view models)
* Domain
* Data (excepting the DTO mapper)

We don't test:
* Views in UI because for that UI tests are more suitable
* Platform because is often just adapters for different external frameworks
