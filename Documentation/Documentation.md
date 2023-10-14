# Anotācija

Kvalifikācijas darba ietvaros ir izstrādāta informācijas sistēma kopā ar tās projektējumu, kas paredzēta Latvijas Skautu un Gaidu centrālajās organizācijas iekšējai lietošanai. Sistēmas galvenais mērķis ir optimizēt struktūrvienību darbību, samazinot nepieciešamību pēc ikgadējām atskaitēm un atvieglojot biedru un struktūrvienību aktivitāšu uzraudzību un pārvaldību. Tāpat sistēma palīdz informēt organizācijas biedrus par nenomaksātu biedra naudu un uzskaita informāciju par gaidāmajiem pasākumiem un iespējām palīdzēt to organizēšanā. Tāpat sistēma veic jaunu struktūrvienību izveidi, ko var veikt tikai administratori (biedri, kuri darbojas organizācijas nacionālajā līmenī), kā arī veido atskaites PDF un XLSX formātos. Sistēma ir izstrādāta tā, ka šī projekta ietvaros tiek izstrādāta sistēmas pamatfunkcionalitāte, ņemot vērā iespēju ieviest papildu funkcijas nākotnē.
**Atslēgas vārdi:** informācijas sistēma, jaunatnes organizācija, biedrzinība

# Abstract

Qualification work includes, an information system, along with its specification, that has been developed for internal use by the Latvian Scout and Guide Central Organization. The main goal of the system is to optimize the operations of units, reducing the need for annual reports and facilitating the monitoring and management of members and unit activities. Additionally, the system helps inform organization members about unpaid membership fees and keeps track of upcoming events and opportunities to assist in their organization. The system also allows the creation of new units, which can only be done by administrators (members working at the national level of the organization), and it generates reports in PDF and XLSX formats. The system is developed in such a way that only the core functionality of the system is being developed within the scope of this project, with the possibility of introducing additional features in the future.
**Key words:** information system, youth organization, member management

# Ievads

## Nolūks

Šis dokuments ir paredzēts, lai aprakstītu izstrādājamās sistēmas "Latvijas Skautu un Gaidu centrālās organizācijas" jeb "LSGCO IS" programmatūras prasības un projektējumu.  Šī sistēma ir paredzēta Latvijas Skautu un Gaidu centrālās organizācijas iekšējai lietošanai. Šajā dokumentā tiks detalizēti aprakstītas sistēmas produkta prasības, projektējums un funkcionalitāte, kā arī sistēmas izstrāde un testēšana.

## Darbības sfēra

Sistēma "LSGCO IS" ir tīmekļa lietotne, kas nodrošina datu uzskaiti un pārvaldīšanu organizācijas ietvaros. Sistēmas galvenais mērķis ir strādāt kā biedruzinības platformai, kura ļauj organizācijai un tās struktūrvienībām izsekot saviem biedriem, šo biedru statusam, biedra naudas bilances stāvoklim, kā arī biedru datu uzturēšanai. Tāpat sistēma uzturēs informāciju par dažādu struktūrvienību veidotiem pasākumiem, brīvprātīgajiem, kas tajos piedalās un kuri to organizē. 
Dati sistēmā tiek glabāti ar to īpašnieku atļauju reģistrējoties sistēmā, kā arī pievienojoties biedrībai. Struktūrvienību vadītājiem ir iespējas iegūt atskaites par pasākumiem un biedriem noteiktā laika periodā. Nacionālā līmeņa vadītājiem ir iespēja iegūt atskaites par vienu vai vairākām struktūrvienībām noteiktā laika periodā. Reģistrēšanās sistēmai ir slēgta, tikai struktūrvienības vadītāja ierosināta. Biedrs pēc reģistrēšanās papildina datus par sevi (kurus vēlas izpaust). Sistēma nodrošinās arī e-pasta apziņošanas sistēmu, kas ļaus paziņot biedriem par biedra maksas kavējumiem.

## Saistība ar citiem dokumentiem

PPS ir izstrādāts atbilstoši standartam "LVS 68:1996 Programmatūras prasību specifikācijas ceļvedis".

PPA ir izstrādāts atbilstoši standartam "LVS 72:1996 Ieteicamā prakse programmatūras projektējuma aprakstīšanai".

## Pārskats

Dokumenta struktūru veido trīs daļas:

1. **Vispārīgs apraksts**, kas ietver 
   
   - produkta aprakstu
   - pasūtītāju
   - 0.līmeņa datu plūsmas diagrammu
   - produkta perspektīvu
   - darījumprasības
   - sistēmas lietotājus 
   - vispārējus ierobežojumus
   - pieņēmumus un atkarības.

2. **Programmatūras prasību specifikācija**, kurā norādītas
   
   - funkcionālās un nefunkcionālās prasības
   - datu bāzes ER diagramma 
   - konceptuālais datu bāzes apraksts
   - 1.un 2.līmeņa datu plūsmas diagrammas
   - sistēmas moduļu sadalījums pēc funkcijām un funkciju apraksti.

3. **Programmatūras projektējuma apraksts**, kur aprakstīts 
   
   - datu bāzes loģiskais un fiziskais modelis  
   - lietotāja saskarņu projektējums
   - testēšanas protokols

# Apzīmējumu saraksts

**DB** - datubāze;
**ER** - entītiju relāciju;
**MB** - megabaits;
**PK** - primārā atslēga;
**FK** - ārējā atslēga;
**ID** - identifikators;
**String** - simbolu virkne;
**Char** - simbols;
**Int** - vesels skaitlis;

**LSGCO** - Latvijas Skautu un Gaidu centrālā organizācija
**Vienība** - LSGCO struktūrvienība

# 1 Vispārīgs apraksts

## 1.1 Esošā stāvokļa apraksts

LSGCO ir pāri 500 biedriem. Pašlaik biedru apzināšana un atskaites tiek veikta katrā vienībā atsevišķi lietojot excel tabulas. Tapēc tiek izstrādāts šis risinājums- informācijas sistēma, kura spēj uzskaitīt biedrus, sagatavot atskaites un vispārēji atvieglot struktūrvienību, kā arī organizācijas nacionālā līmeņa vadības darbu.

## 1.2 Pasūtītājs

Sistēma netiek veidota pēc pasūtījuma, bet pēc LSGCO biedra iniciatīvas kvalifikācijas darba ietvaros. Sistēmas izstrādes laikā tiek uzturēts dialogs ar LSGCO valdi, kā arī citiem biedriem, ar mērķi nākotnē ieviest šīs sistēmas lietošanu organizācijā.

## 1.3 Produkta perspektīva

Izstrādājamā sistēma ir pārsvarā neatkarīga un patstāvīga.

## 1.4 Darījumprasības

Sistēmai ir jānodrošina sekojošas funkcijas:

- Lietotāju reģistrācija, autentifikācija un autorizācija.
- Lietotāju datu izveidošana, dzēšana, rediģēšana, lasīšana.
- Vienību izveidošana, dzēšana, rediģēšana, lasīšana.
- Pasākmu izveidošana, dzēšana, rediģēšana, lasīšana.
- Lietotāju pievienošana/noņemšana no pasākumiem.
- Atskaišu ģenerēšana par biedru sastāvu, pasākumiem.
- Biedru naudas uzskaite, ziņojumi par kavētām biedra naudas iemaksām.

## 1.5 Sistēmas lietotāji

<img src="/Documentation/0_limena_dpd.png" />

**Attēls 1.1.1.** *0. līmeņa datu plūsmas diagramma*
Kā redzams attēlā 1.1.1., sistēmas visi lietotāji tiek uzskatīti par Biedriem. Katra nākamā sistēmas lietotāja grupa iegūst jaunas tiesības, nezaudējot iepriekšējās. Sākot no Priekšnieka atļaujas līmeņa ir iespējams iegūt atskaites.

- Organizācijas biedrs (turpmāk Biedrs) - lietotājs, kurš spēj papildināt datus par sevi, pievienoties pasākumiem, saņemt paziņojumus par beidra naudām, apskatīt un pieteikties pasākumiem. Šim lietotājam ir piekļuve sistēmas "Biedrs" modulim un tā funkcijām, daļai no "Pasākums" modeļa funkcijām.
- Struktūrvienības vadītājs (turpmāk Priekšnieks) - lietotājs, kurš spēj veikt visas darbības ko Biedrs, bet arī pārvaldīt vienības biedrus un to statusu, izveidot jaunu biedru, izveidot atskaites par vienību, izveidot pasākumus. Šim lietotājam ir piekļuve sistēmas "Biedrs", "Pasākums" un "Vienība" moduļiem un to funkcijām.
- Nacionālā līmeņa biedrs (turpmāk Administrators) - lietotājs, kurš spēj veikt visas darbības ko Biedrs un Priekšnieks, bet arī pārvaldīt vienības, izveidot jaunu vienību, izveidot atskaites par organizāciju. Šim lietotājam ir piekļuve sistēmas "Biedrs", "Vienība", "Pasākums" un "Valde" moduļiem un to funkcijām.

## 1.6 Vispārējie ierobežojumi

- Lietotne ir veidota lietošanai tīmeklī Chrome, Firefox vai Safari pārlūkprogrammā. 
- Sistēmas lietošanai ir nepieviešams stabils interneta savienojums.
- Valsts datu regulas ierobežojumi saistībā ar privātpersonu datu glabāšanu.

## 1.7 Pieņēmumi un atkarības

1. Lietotājam ir ierīce, kas spēj izmantot pārlūkprogrammu;
2. Lietotājam ir pieejams stabils interneta savienojums;
3. Serveris un DB ir nepārtraukti pieejams visiem lietotājiem;

# 2 Programmatūras prasību specifikācija

## 2.1 Datu bāzes apraksts

<img src="/Documentation/DB_konceptuala_diagramma.png">

**Attēls 2.1.1.** *Konceptuālais datu bāzes modelis*
Attēlā 2.2.1 var redzēt datubāzes konceptuālo modeli, kurā ir redzamas savstarpējās attiecības starp tabulu entītijām, kā arī to datu lauki.

## 2.2 Funkcionālās prasības

### 2.2.2. Funkciju sadalījums pa modeļiem

<img src="/Documentation/1_limena_dpd.png" alt="">

   **Attēls 2.2.1.** *1. līmeņa datu plūsmas diagramma*
Attēlā 2.2.1. ir redzama pirmā līmeņa datu plūsmas diagramma, kas atspoguļo sistēmas moduļu miejdarbību ar sistēmas lietotājiem un datubāzi. Pārskatāmības dēļ 1. līmenī DB ir abstraktētas vairākās datubāzēs, un tā neatspoguļo reālo datubāzes uzbūvi. Detalizētāks modeļu funkciju apraksts ir apskatāms zemāk tabulā 2.2.

Sistēma ir sadalīta 5 galvenajos modeļos. Šie moduļi ir sekojoši:

- "Biedrs" (**BDR**) modulis, kas ir domāts lietotāja personīgās informācijas uzturēšanai, labošanai un izmantošanai, kā arī biedra naudu izsekošanai. 
  Funkciju sadalījums pa sistēmas moduļiem

- "Vienība" (**VNB**) modulis, kas ir domāts struktūrvienības informācijas uzturēšanai, labošanai un izmantošanai, jaunu biedru pievienošanai, kā arī vienības līmeņa atskaišu sagatavošanai.

- "Valde" (**VLD**) modulis, kas ir domāts organizācijas līmeņa atskaišu sagatavošanai, jaunu vienību izveidei.

- "Pasākums" (**PSK**) modulis, kas ir domāts pasākumu izveidei, uzturēšanai un izmantošanai, biedru pievienošanai pasākumu dalībnieku / organizatoru sarakstam.

- "Sistēma" (**SYS**) modulis, kas ir paredzēts sistēmas darbībām un autorizācijām.
  
  | Modulis | Funkcijas apzīmējums | Funkcija                                            | Lietotāji                                      |
  | ------- | -------------------- | --------------------------------------------------- | ---------------------------------------------- |
  | BDR     | BDR-01               | Biedra datu apskatīšana                             | Biedrs, Priekšnieks, Administrators            |
  |         | BDR-02               | Biedra datu atjaunošana                             | Biedrs, Priekšnieks, Administrators            |
  |         | BDR-03               | Izstāšanās pieteikuma iesniegšana                   | Biedrs, Priekšnieks, Administrators            |
  |         | BDR-04               | Biedra naudas statusa iegūšana                      | Biedrs, Priekšnieks, Administrators            |
  |         | BDR-05               | Biedra naudas paziņojums                            | Autonoma funkcija                              |
  | VNB     | VNB-01               | Biedra pievienošana                                 | Priekšnieks, Administrators                    |
  |         | VNB-02               | Vienības biedru apskaīšana                          | Priekšnieks, Administrators                    |
  |         | VNB-03               | Vienības biedra vienības nomaiņa                    | Priekšnieks, Administrators                    |
  |         | VNB-04               | Vienības datu apskaīšana                            | Priekšnieks, Administrators                    |
  |         | VNB-05               | Vienības datu atjaunošana                           | Priekšnieks, Administrators                    |
  |         | VNB-06               | Vienības biedru atskaites sagatavošana              | Priekšnieks, Administrators                    |
  |         | VNB-07               | Vienības biedra biedra naudas nomaksas reģistrēšana | Priekšnieks, Administrators                    |
  |         | VNB-08               | Vienības biedra amata pievienošana                  | Priekšnieks, Administrators                    |
  |         | VNB-09               | Iknedēļas nodarbības pievienošana                   | Priekšnieks, Administrators                    |
  |         | VNB-10               | Iknedēļas nodarbības izmainīšana                    | Priekšnieks, Administrators                    |
  |         | VNB-11               | Iknedēļas nodarbības noņemšana                      | Priekšnieks, Administrators                    |
  |         | VNB-12               | Novadītas nodarbības atzīmēšana                     | Priekšnieks, Administrators, Biedrs (ar vadītāja statusu) |
  | VLD     | VLD-01               | Vienības pievienošana                               | Administrators                                 |
  |         | VLD-02               | Vienības dzēšana                                    | Administrators                                 |
  |         | VLD-03               | Biedru atskaites sagatavošana                       | Administrators                                 |
  |         | VLD-04               | Vienību atskaites sagatavošana                      | Administrators                                 |
  |         | VLD-05               | Biedra personīgo datu dzēšana                       | Administrators                                 |
  | PSK     | PSK-01               | Pasākuma izveidošana                                | Priekšnieks, Administrators                    |
  |         | PSK-02               | Pasākuma dzēšana                                    | Priekšnieks, Administrators                    |
  |         | PSK-03               | Pasākuma datu atjaunošana                           | Priekšnieks, Administrators                    |
  |         | PSK-04               | Pasākumu apsktīšana                                 | Biedrs, Priekšnieks, Administrators            |
  |         | PSK-05               | Pieteikšanās pasākumam                              | Biedrs, Priekšnieks, Administrators            |
  |         | PSK-06               | Atteikšanās no pasākuma                             | Biedrs, Priekšnieks, Administrators            |
  |         | PSK-07               | Aktuālo pasākumu iegūšana                           | Biedrs, Priekšnieks, Administrators            |
  | SYS     | SYS-01               | Pieslēgšanās                                        | Biedrs, Priekšnieks, Administrators            |
  |         | SYS-02               | Atslēgšanās                                         | Biedrs, Priekšnieks, Administrators            |
  |         | SYS-03               | Biedra naudas bilances pārrēķins                    | Autonoma funkcija                              |

**Tabula 2.2.2** *Funkciju sadalījums pa sistēmas moduļiem*

### 2.2.2. Modulis "Biedrs"

<img src="/Documentation/2_limena_BDR_DPD.png">

**Attēls 2.2.3** *BDR moduļa 2. līmeņa DPD diagrama*

### 2.2.3. Modulis "Vienība"

<img src="/Documentation/2_limena_VNB_DPD.png">

**Attēls 2.2.4** *VNB moduļa 2. līmeņa DPD diagrama*

### 2.2.4. Modulis "Valde"

<img src="/Documentation/2_limena_VLD_DPD.png">

**Attēls 2.2.5** *VNB moduļa 2. līmeņa VLD diagrama*

### 2.2.5. Modulis "Pasākums"

<img src="/Documentation/2_limena_PSK_DPD.png">

**Attēls 2.2.6** *VNB moduļa 2. līmeņa PSK diagrama*

### 2.2.5. Modulis "Sistēma"

<img src="/Documentation/2_limena_SYS_DPD.png">

**Attēls 2.2.7** *VNB moduļa 2. līmeņa SYS diagrama*


# 3 Projektējuma apraksts

## 3.1. Datubāzes projektējums
<img src="/Documentation/DB_logiska_diagramma.png">

**Attēls 3.1.1.** *Loģiskais datu bāzes modelis*
Kā var redzēt attēlā 2.1.2. datubāzē ir 3 galvenās tabulas (Lieotājs (User), Vienība (Unit), Pasākums (Event)) ar 5 palīgtabulām (Biedra naudas nomaksa (Membership Fee Payments), Amats(Position), Iknedēļas nodarbība (Weekly Activity), Pakāpes vēsture (Rank History) un Reģistrācija pasākumam (Event Registration)). Klāt konceptuālajam modelim ir nākuši datu tipi, kā arī palīglauki ārējām atslēgām un unikālajiem identifikatoriem. Sistēmas specifikas dēļ primārajām atslēgām tiek lietots unikāls ID lauks.

## 3.2. Skatu projektējums

### 3.2.1. Pievienošanās skats
<img src="/Documentation/sk_landing.png">

**Attēls 3.2.1** *Pievienošanās skats*


# 4 Testēšas protokols

## 4.1. Testēšanas procesu apraksts

Sistēmas testēšanai tiek lietota rails bibleotēka rspec, kas ir paredzēta automātisko testu izveidei un dokumentēšanai. Rspec sintakse ir labi lasāma, un tās metodes nosaukums apraksta vēlamo sasniedzamo rezultātu. Turpmākajā nodaļā tiks uzskaitīti testa piemēri, kas tiek pārbaudīti sistēmā, kā arī to vēlamais rezultāts. Šos pašus datus var atrast arī projekta /spec/ mapē.

## 4.2. Protokols

#### Lietotāju modeļa vienībtesti

> **Sistēma lietotāja objektu aizpilda ar noklusējuma datiem**
> Automatizētais tests izveidots 9/10/2023
> Ievaddati- jauns lietotāja objekts bez aizpildītiem datiem
> Vēlamais rezultāts- sistēmas lietotājs nav derīgs, bet tā *membership_fee_bilance* ir 0 un *permission_level* ir "biedrs"

> **Lietotājs ar derīgiem datiem ir derīgs**
> Automatizētais tests izveidots 9/10/2023
> Ievaddati- jauns lietotāja objekts, kas aizpildīts ar derīgiem datiem
> Vēlamais rezultāts- sistēmas lietotājs ir derīgs

> **Lietotājs ir derīgs ja nav aizpildīti neobligātie lauki**
> Automatizētais tests izveidots 9/10/2023
> Ievaddati- jauns lietotāja objekts, kas aizpildīts tikai ar obligātajiem laukiem
> Vēlamais rezultāts- sistēmas lietotājs ir derīgs

> **Lietotājs nav derīgs ja nav aizpildīti obligātie lauki**
> Automatizētais tests izveidots 9/10/2023
> Ievaddati- jauns lietotāja objekts, kurā aizpildīti tikai neobligātie lauki
> Vēlamais rezultāts- sistēmas lietotājs nav derīgs

> **No lietotāja var iegūt tā vienības datus**
> Automatizētais tests izveidots 9/10/2023
> Ievaddati- jauns lietotāja objekts
> Vēlamais rezultāts- lietotāja vienības dati nav tukši

#### Vienības modeļa vienībtesti

> **Vienība ar derīgiem datiem ir derīga**
> Automatizētais tests izveidots 9/10/2023
> Ievaddati- jauns vienības objekts, kas aizpildīts ar derīgiem datiem
> Vēlamais rezultāts- vienība ir derīga

> **Vienība ir derīga ja nav aizpildīti neobligātie lauki**
> Automatizētais tests izveidots 9/10/2023
> Ievaddati- jauns vienības objekts, kas aizpildīts tikai ar obligātajiem laukiem
> Vēlamais rezultāts- vienība ir derīga

> **Vienība nav derīga ja nav aizpildīti obligātie lauki**
> Automatizētais tests izveidots 9/10/2023
> Ievaddati- jauns vienības objekts, kurā aizpildīti tikai neobligātie lauki
> Vēlamais rezultāts- vienība nav derīga

> **No vienības var iegūt tās biedru (lietotāju) datus**
> Automatizētais tests izveidots 9/10/2023
> Ievaddati- eksistējošs vienības objekts, kam ppievienoti 2 lietotāja objekti
> Vēlamais rezultāts- 2 lietotāji, kas atbilst vienībai pievienotajiem objektiem
