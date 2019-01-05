# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Pobierz i zapisz dane z aktualnego dnia. Skrypt powinien się uruchamiać automatycznie raz dziennie. (model Day has many Currencies)

Stwórz proste API dla panelu który pozwoli na przeglądanie danych zapisanych w bazie używając filtrów (np. Od konkretnej daty, do konkretnej daty) i zwracanie średniej ceny dla wskazanego zakresu

Zabezpiecz API przed nieautoryzowanym dostępem i zbyt dużym ruchem

Jeśli w bazie nie ma wyników dla konkretnego dnia ustawionego w filtrach, wyniki powinny się pobrać w tle z API.

Napisz obsługę błędów dla zapytań API które zwracają błędy (np. 93 dni wstecz)

Stwórz testy do API i prostą dokumentację

Zastosuj mechanizm machine learning, który na podstawie danych historycznych, będzie w stanie wygenerować wartości dla przyszłych dat

Dodatkowym plusem będzie dostępność aplikacji online