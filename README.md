# Latvijas Skautu un Gaidu centrālās organizācijas Informācijas Sistēma (LSGCO IS)

LSGCO IS ir biedrzinības sistēma, kas ir paredzēta organizācijas iekšējai lietošanai, lai risinātu biedru pārvaldību, biedra naudas nomaksu, pasākumu reģistrāciju, un citus jautājumus.

## Izmantotās tehnoloģijas
- Sistēma ir veidota Ruby on Rails vidē, lai nodrošinātu ātru un kvalitatīvu sistēmas izstrādi un iebūvētu e-pastu izsūtīšanu.
- Frontend tiek lietota .slim templating valoda

## Palaišana

Šī aplikācija lieto docker container un rails puma serveri. Lai to palaistu izstrādes režīmā izmanotjiet lejā redzamās komandas
```bash
docker compose up -d
rails db:create
rails db:seed
./bin/dev
```
Lai palaistu produkcijas versiju palaidiet docker image, TBD

## Piebildes

Darbs izstrādāts Latvijas Universitātes Datorzinātņu profesionālās bakalaura programmas kvalifikācijas darba ietvaros, ar LSGCO atbalstu.
