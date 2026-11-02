# Sažetak rada — sajt Pet Shop Šilja Plus

Stanje na dan 2.11.2026. Ovaj fajl služi da se rad nastavi u novoj sesiji bez ponavljanja.

## Cilj

Dovršiti statički sajt prodavnice (GitHub: https://github.com/maretebra/silja-plus) i prilagoditi ga Google SEO pravilima, **stavku po stavku**, uz uredan folder sa semantičkim nazivima fajlova.

## Šta je urađeno

### 1. Preuzimanje i organizacija foldera ✅
- Sajt je preuzet sa GitHuba (grana `main`). Sastoji se od 8 HTML stranica, jednog CSS-a, jednog JS-a i logotipa.
- Nova struktura:
  ```
  silja-plus/
  ├── index.html, o-nama.html, brendovi.html
  ├── sve-za-pse.html, sve-za-macke.html, sve-za-ptice.html
  ├── sve-za-glodare.html, akvaristika-teraristika.html
  ├── README.md
  ├── assets/
  │   ├── css/main.css               (bio style.css)
  │   ├── js/main.js                 (bio script.js)
  │   └── images/logo/silja-plus-logo.png   (bio slike/Logo.png)
  ├── data/proizvodi.json            (katalog proizvoda)
  └── docs/
      ├── podaci-o-prodavnici.md     (proverene informacije o firmi)
      └── sazetak-rada.md            (ovaj fajl)
  ```
- HTML stranice su ostale u korenu jer su njihovi nazivi dobre adrese za Google.
- Sve putanje u HTML-u su ispravljene i proverene skriptom: nijedan link ne fali.
- Sajt još **nije vizuelno proveren** u pregledaču.

### 2. Provera podataka o prodavnici ✅
Izvor: javni registar firmi (CompanyWall, podaci iz APR-a). Detalji su u `docs/podaci-o-prodavnici.md`.

| Podatak | Na starom sajtu (pogrešno) | Tačno (registar) |
|---|---|---|
| Ime | Silja Plus | **Šilja Plus** |
| Ulica | Bate Milivoja 1g | **Bate Mirkovića 1g** |
| Mesto | Rajka | **Ralja, 11233, opština Sopot, Beograd** |
| Telefon | +381 69 5753 606 | 069 5575 606 ✅ |
| Mejl | mirosvetlariclol02@gmail.com | mitrovicmarko1602@gmail.com ✅ |

- Pun naziv: Marko Mitrović PR Trgovinska radnja Pet Shop Šilja Plus Ralja
- PIB 115451135, MB 68376351, delatnost 4776, osnovana 23.12.2025.
- U registru je firma zavedena kao **„u mirovanju“ od 2.9.2026.** Proveriti pre objave sajta.
- Koordinate ulice: 44.5695300, 20.5602766
- Na internetu nisu pronađeni Instagram, Facebook ni Google Business profil.

### 3. Katalog proizvoda ✅ (delimično)
- `data/proizvodi.json` ima **59 proizvoda: 38 za pse i 21 za mačke**.
- Za svaki proizvod: naziv, brend, linija, životinja, uzrast, veličina rase, glavni protein, pakovanja, % proteina i masti, kratak opis i izvor.
- Polje `status`: **39 potvrđeno**, **20 proveriti**. Za stavke „proveriti“ brend ima više sličnih proizvoda; razlog piše u polju `napomena`.
- Brendovi: Premil, Josera/JosiDog/JosiCat, Farmina (N&D, Cibau), Purina (Friskies, Cat Chow), Royal Canin, Brit, Monge, Natural Trainer, Pet PRO, Sun Line, Kudo, SmartDog.

## Šta čeka odgovor vlasnika

1. ~~**Telefon i mejl**~~ — ✅ rešeno 28.10.2026: na sajt idu telefon i mejl **iz registra** (vidi `docs/podaci-o-prodavnici.md`).
2. **Stavke kataloga „proveriti“:**
   - Josera Mini Adult (koja od 5 mini varijanti) i Josera Junior (JosiDog Junior ili Junior Sensitive)
   - N&D za pse: linija Prime ili Ancestral Grain, i veličina Mini ili Medium & Maxi
   - Cibau Sensitive jagnjetina: Mini ili Medium & Maxi
   - Royal Canin: Mini Adult ili Mini Light Weight Care
   - Monge jagnjetina: Mini Adult, Puppy ili All Breeds
   - Brit „sens lamb i piletina“: da li je piletina poseban proizvod
   - Premil mačke: da li su to Standard Mix, Poultry, Beef i Fish
   - Cat Chow: koja od 8 varijanti
   - N&D Ocean mačke: haringa ili bakalar, Adult ili Neutered
   - Monge mačke piletina: Adult, Sterilised ili Kitten
   - Pet PRO Mini: 12 kg ili Mini Fresh 3 kg
   - **Kudo:** koje varijante
   - **SmartDog:** nije pronađen; potrebna je fotografija pakovanja
3. **Slike proizvoda:** nisu preuzete. Pitati distributera, slikati u radnji ili dozvoliti preuzimanje sa sajtova proizvođača.
4. **Cene:** nisu unete.
5. **Domen sajta:** potreban za canonical linkove, sitemap.xml i robots.txt.
   - Provereno 28.10.2026 (whois): slobodni su `siljaplus.rs`, `siljaplus.co.rs`, `petshopsiljaplus.rs`, `siljaplus.com`. Preporuka: **siljaplus.rs** (registruje vlasnik kod ovlašćenog registra RNIDS-a, na firmu/PIB).
   - Hosting: predlog **Cloudflare Pages** (besplatno, dozvoljena komercijalna upotreba, sopstveni domen + HTTPS). GitHub Pages po pravilima nije namenjen sajtovima firmi.
   - Logo: predlozi u `docs/logo-predlozi.html` (šapa sa plusom, pas šiljatih ušiju, monogram Š+). Čeka izbor vlasnika.
6. **Radno vreme**, linkovi ka društvenim mrežama (ako postoje).

## SEO plan — sledeće stavke

1. ✅ **Dijakritika, naslovi i meta opisi** (urađeno 2.11.2026): sav vidljiv tekst je sa dijakritikom (provereno skriptom), svaka stranica ima svoj naslov (43–54 znaka) i opis (133–147 znakova) sa ključnim rečima i mestom (Ralja, Sopot). `lang="sr-Latn"`.
2. ✅ **Ukloniti tekst-zamene sa stranica** (urađeno 28.10.2026):
   - `index.html`: natpis „Fotografija psa iz Figme“ zamenjen logotipom u hero bloku; rečenica o „placeholder logotipima“ zamenjena opisom brendova.
   - `brendovi.html`: uvod i dve kartice („Placeholder logotipi“, „Povezivanje sa proizvodima“) zamenjeni stvarnim spiskom brendova hrane za pse i mačke (iz `data/proizvodi.json`).
   - `sve-za-pse.html`: uvod „spremna da kasnije dobije prave slike…“ zamenjen opisom ponude.
   - `o-nama.html`: uklonjeni tekstovi iz faze dizajna (Figma, „koncept sajta“, „pristupačan sajt“, statistike „100% responsive“, „1 stil vodič“); umesto njih lokacija, savet u radnji i kratke činjenice.
   - Novi tekst je pisan sa dijakritikom; ostatak stranica čeka stavku 1.
3. ✅ **Lokalni SEO** (urađeno 28.10.2026, delimično):
   - Futer na svih 8 stranica: ime **Šilja Plus**, tačna adresa u `<address>` elementu, telefon i mejl iz registra, red sa punim nazivom, PIB i MB.
   - `index.html`: schema.org `PetStore` u JSON-LD (ime, pravni naziv, adresa, telefon, mejl, PIB, MB, koordinate, oblast).
   - **Nedostaje:** `openingHours` (radno vreme), `url`, `logo` i `image` (traže domen), `sameAs` (društvene mreže). Dodati kad vlasnik da podatke.
   - **Google Business profil** otvara vlasnik (business.google.com); traži potvrdu adrese. Pre toga rešiti status „u mirovanju“.
4. ✅ **Tehničke osnove** (urađeno 2.11.2026): canonical na svakoj stranici, `sitemap.xml`, `robots.txt`, `404.html` (noindex, sa linkovima nazad), putokaz (breadcrumbs) vidljiv i kao schema `BreadcrumbList`, link „Preskoči na sadržaj“, `aria-current` u meniju.
   - Adresa sajta je za sada `https://maretebra.github.io/silja-plus/` (konstanta `BASE_URL` u `tools/generisi-stranice.rb`). Kad se pređe na domen, promeniti taj red i ponovo pokrenuti skriptu.
   - Na GitHub Pages adresi projekta `robots.txt` nije u korenu domena, pa ga Google ne čita — sitemap zato prijaviti ručno u Google Search Console. Na sopstvenom domenu ovo nestaje.
5. ✅ **Deljenje na mrežama** (urađeno 2.11.2026): Open Graph i Twitter oznake na svim stranicama (slika: logo). Linkovi na Instagram/Facebook koji su vodili na `#` su uklonjeni; kad profili postoje, upisati ih u `SOCIAL` u skripti (idu i u futer i u schema `sameAs`).
6. ✅ **Fontovi, slike i brzina** (urađeno 2.11.2026):
   - Baloo 2 i Bree Serif se učitavaju sa sajta (`assets/fonts/`, woff2, latin + latin-ext za č ć š ž đ, licenca SIL OFL priložena). Nema više zahteva ka Google Fonts. Glavni fontovi su `preload`.
   - Favicon 48/96/192 px, apple-touch-icon 180 px, `site.webmanifest`, `theme-color`.
   - Logo u zaglavlju/futeru je manja verzija (`silja-plus-logo-108.png`, 11 KB umesto 34 KB); sve slike imaju `width`/`height`, futer `loading="lazy"`, ukrasne slike prazan `alt`.
   - JS se učitava sa `defer`. Popravljen padajući meni koji je pravio horizontalno skrolovanje.
   - Naslovi više nemaju lažno podebljanje (Bree Serif ima samo jednu debljinu).
7. ✅ **Sadržaj kategorija** (urađeno 2.11.2026):
   - Stranice za pse (25 proizvoda) i mačke (14) prikazuju katalog iz `data/proizvodi.json`, grupisan po brendu: opis, uzrast, rasa, meso, proteini/masti, pakovanja. Svaki proizvod ima sidro (npr. `sve-za-pse.html#premil-large`).
   - Stavke „proveriti“ se **ne prikazuju**; njihovi brendovi se pominju samo imenom („U ponudi imamo i…“).
   - Svaka kategorija ima tekst sa savetima (izbor hrane po uzrastu, rasi, aktivnosti; ptice, glodari, akvarijum, terarijum) sa unutrašnjim linkovima ka proizvodima.
   - `brendovi.html` ima karticu za svaki brend sa linkovima ka proizvodima.
   - Kartice „Kupujte prema brendu“ (početna i `brendovi.html`, urađeno 2.11.2026): novi dizajn sa trakom u boji brenda, linijama, opisom, brojem potvrđenih proizvoda i rasponom cena. Brendovi, redosled, opis, boja i cene su u `data/brendovi.json` (11 brendova iz kataloga; Nekmar izbačen, SmartDog izostavljen dok se ne potvrdi). Cene su za sada prazne, pa na karticama piše „Cene proverite u radnji“.
   - Početna: H1 i tekst o lokaciji (Ralja, Sopot, Mali Požarevac).
   - Schema: `PetStore` (sa `url`, `logo`, `hasMap`), `WebSite`, `CollectionPage` + `ItemList` sa `Product` (naziv, brend, opis, kategorija).
   - **Nedostaje za Google prikaz proizvoda sa cenom:** cene (`offers`). Dok ih nema, Search Console će za `Product` javljati upozorenje „nedostaje offers“ — to ne kvari rangiranje. Kad vlasnik da cene, dodati ih u JSON i u skriptu.
   - Cene na karticama „Istaknuto“ (npr. „od 3.250,00 RSD“) su sa originalnog sajta — vlasnik da potvrdi da su aktuelne.

## Kako se menjaju stranice

HTML fajlovi u korenu se prave skriptom: `ruby tools/generisi-stranice.rb` (iz foldera `silja-plus`). Tekst se menja u skripti, proizvodi u `data/proizvodi.json`, stil u `assets/css/main.css`. Ručne izmene HTML-a se gube pri sledećem pokretanju.

Najniža i najviša cena po brendu unose se komandom `ruby tools/unesi-cene.rb`. Komanda za svaki brend pita cenu (Enter zadržava staru vrednost, `-` je briše), upisuje `data/brendovi.json` i sama ponovo pravi stranice.

Za pregled u pregledaču: macOS ne dozvoljava lokalnom serveru da čita Desktop, pa se sajt kopira u privremeni folder (vidi `../.claude/launch.json`).

## Šta još utiče na Google, a zavisi od vlasnika

1. **Google Business profil** — najveći uticaj na lokalnu pretragu („pet shop Ralja“). Pre toga rešiti status „u mirovanju“.
2. **Sopstveni domen** (`siljaplus.rs`) i prijava u Google Search Console sa sitemapom.
3. **Radno vreme** (`openingHours`), **fotografije radnje i proizvoda**, **cene**.
4. **Sopstveni logo** — sadašnji prikazuje Disney lik (autorsko pravo); koristi se i kao favicon i slika za deljenje.
5. Potvrda 20 stavki „proveriti“ u katalogu.

## Podela posla

- **Claude Code (VS Code):** kodiranje sajta — sve izmene HTML/CSS/JS, commit i push na GitHub.
- **Claude (aplikacija):** pitanja, istraživanje, pisanje završnog rada.
- Rad na sajtu ide na grani `sredjivanje-sajta`; `main` = živi sajt (GitHub Pages), u njega se spaja tek kad je sve provereno.

## Napomene za nastavak

- Podaci o prodavnici uzimaju se **samo** iz `docs/podaci-o-prodavnici.md`, nikad sa starog sajta.
- Opisi proizvoda su pisani sopstvenim rečima, a ne prepisivani od proizvođača.
- Originalni fajlovi sa GitHuba su sačuvani posebno u `source/original/`, za poređenje.
- Git radi (Xcode Command Line Tools instalirani 2.11.2026). Izmene su commit-ovane na granu `sredjivanje-sajta`; push na GitHub i spajanje u `main` tek uz odobrenje vlasnika.
- Logotip (`silja-plus-logo.png`) prikazuje Disney lik (Šilja/Goofy) — zaštićen autorskim pravom. Pre objave razmisliti o sopstvenom logotipu.
