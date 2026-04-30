**Zadanie 1** Paradygmaty

- [x] 3.0 Procedura do generowania 50 losowych liczb od 0 do 100
  ([ba9c350](https://github.com/26d4/po26/commit/ba9c3508f5d700c251fb9d1395616efd3660293d))
- [x] 3.5 Procedura do sortowania liczb
  ([248042b](https://github.com/26d4/po26/commit/248042be1cda915b3705dfe0801a2f3fbb3ecd76))
- [x] 4.0 Dodanie parametrów do procedury losującej określającymi zakres losowania: od, do, ile
  ([4d00ec1](https://github.com/26d4/po26/commit/4d00ec1e46d7f745794e26df8946fc8fe8f49f6f))
- [x] 4.5 5 testów jednostkowych testujące procedury
  ([0818cdd](https://github.com/26d4/po26/commit/0818cddc85afc4114b3bce8953f668c42eafda3c))
- [x] 5.0 Skrypt w bashu do uruchamiania aplikacji w Pascalu via docker
  ([d805b64](https://github.com/26d4/po26/commit/d805b648a36b40c9ea550b3e79aa77a06defceba))

https://github.com/user-attachments/assets/72479a7f-f180-41a4-9dca-ce6a4182db72

**Zadanie 2** Wzorce architektury

Symfony (PHP)

- [x] 3.0 Należy stworzyć jeden model z kontrolerem z produktami, zgodnie z CRUD (JSON)
  ([a77766b](https://github.com/26d4/po26/commit/a77766b3be0292d2119a329ad23271cd9d2a5be9))
- [x] 3.5 Należy stworzyć skrypty do testów endpointów via curl (JSON)
  ([7ac1abc](https://github.com/26d4/po26/commit/7ac1abcec7e8553fb22d7bdb8d9f3d7ca19d1399))
- [x] 4.0 Należy stworzyć dwa dodatkowe kontrolery wraz z modelami  (JSON)
  ([43673db](https://github.com/26d4/po26/commit/43673db815a7e46f7b37225de0affe80fdabd066))
- [x] 4.5 Należy stworzyć widoki do wszystkich kontrolerów
  ([43673db](https://github.com/26d4/po26/commit/43673db815a7e46f7b37225de0affe80fdabd066))
- [ ] 5.0 Stworzenie panelu administracyjnego

https://github.com/user-attachments/assets/f45cf572-cbdd-49ef-994d-b2f91d427b94

**Zadanie 3** Wzorce kreacyjne

Spring Boot (Kotlin)

Proszę stworzyć prosty serwis do autoryzacji, który zasymuluje
autoryzację użytkownika za pomocą przesłanej nazwy użytkownika oraz
hasła. Serwis powinien zostać wstrzyknięty do kontrolera (4.5).
Aplikacja ma oczywiście zawierać jeden kontroler i powinna zostać
napisana w języku Kotlin. Oparta powinna zostać na frameworku Spring
Boot. Serwis do autoryzacji powinien być singletonem.

- [x] 3.0 Należy stworzyć jeden kontroler wraz z danymi wyświetlanymi z listy na endpoint’cie w formacie JSON - Kotlin + Spring Boot
  ([27805a6](https://github.com/26d4/po26/commit/27805a6392c3d82109836799366c5ef7d35567c5))
- [x] 3.5 Należy stworzyć klasę do autoryzacji (mock) jako Singleton w formie eager
  ([fd2cb3d](https://github.com/26d4/po26/commit/fd2cb3dd24b940f6e8519e899b43090aa5e2cbd9))
- [x] 4.0 Należy obsłużyć dane autoryzacji przekazywane przez użytkownika
  ([fd2cb3d](https://github.com/26d4/po26/commit/fd2cb3dd24b940f6e8519e899b43090aa5e2cbd9))
- [x] 4.5 Należy wstrzyknąć singleton do głównej klasy via @Autowired lub kontruktor (constructor injection)
  ([9bf96ce](https://github.com/26d4/po26/commit/9bf96ce168b6616f07f5b7d42b0ec2076ea99223))
- [x] 5.0 Obok wersji Eager do wyboru powinna być wersja Singletona w wersji lazy
  ([fddcdb6](https://github.com/26d4/po26/commit/fddcdb6dd4c5176e244c2ab300f52456f66c86e7))

https://github.com/user-attachments/assets/484465be-8828-4f6c-ab10-d0f5022e4077

**Zadanie 4** Wzorce strukturalne

Echo (Go)
Należy stworzyć aplikację w Go na frameworku echo. Aplikacja ma mieć
jeden endpoint, minimum jedną funkcję proxy, która pobiera dane np. o
pogodzie, giełdzie, etc. (do wyboru) z zewnętrznego API. Zapytania do
endpointu można wysyłać w jako GET lub POST.

- [x] 3.0 Należy stworzyć aplikację we frameworki echo w j. Go, która będzie miała kontroler Pogody, która pozwala na pobieranie danych o pogodzie (lub akcjach giełdowych)
  ([843ac54](https://github.com/26d4/po26/commit/843ac54b7dbc3373151e33485e7d4b5d7b75f23d))
- [x] 3.5 Należy stworzyć model Pogoda (lub Giełda) wykorzystując gorm, a dane załadować z listy przy uruchomieniu
  ([253e76c](https://github.com/26d4/po26/commit/253e76c3b94baa07abffb5ebbd835bc05f5ccdc5))
- [x] 4.0 Należy stworzyć klasę proxy, która pobierze dane z serwisu zewnętrznego podczas zapytania do naszego kontrolera
  ([253e76c](https://github.com/26d4/po26/commit/253e76c3b94baa07abffb5ebbd835bc05f5ccdc5))
- [x] 4.5 Należy zapisać pobrane dane z zewnątrz do bazy danych
  ([253e76c](https://github.com/26d4/po26/commit/253e76c3b94baa07abffb5ebbd835bc05f5ccdc5))
- [x] 5.0 Należy rozszerzyć endpoint na więcej niż jedną lokalizację (Pogoda), lub akcje (Giełda) zwracając JSONa
  ([21e0a27](https://github.com/26d4/po26/commit/21e0a27002dd28d6c18d2344053729f3712b8b6a))

https://github.com/user-attachments/assets/47e5f430-84b6-4af4-990b-98b01a0d63ff
