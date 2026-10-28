# Sažetak rada — sajt Pet Shop Šilja Plus

Stanje na dan 28.10.2026. Ovaj fajl služi da se rad nastavi u novoj sesiji bez ponavljanja.

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
6. **Radno vreme**, linkovi ka društvenim mrežama (ako postoje).

## SEO plan — sledeće stavke

1. **Dijakritika, naslovi i meta opisi:** svuda piše „macke“, „Pocetna“, „vase“; treba „mačke“, „Početna“, „vaše“. Treba jedinstven naslov i opis za svaku stranicu. Uz to ispraviti ime, adresu i kontakt prema `docs/podaci-o-prodavnici.md`.
2. **Ukloniti tekst-zamene sa stranica:** „Fotografija psa iz Figme“, „Placeholder logotipi…“, „spremna da kasnije dobije prave slike…“.
3. **Lokalni SEO:** schema.org `PetStore` (ime, adresa, telefon, koordinate, radno vreme), PIB i MB u futeru i otvaranje Google Business profila.
4. **Tehničke osnove:** canonical, `sitemap.xml`, `robots.txt`, stranica 404.
5. **Deljenje na mrežama:** Open Graph i Twitter oznake; popraviti linkove na društvene mreže koji sada vode na `#`.
6. **Slike i brzina:** favicon u više veličina, alt tekstovi, `width` i `height` na slikama, fontovi učitani sa samog sajta umesto sa Google Fonts.
7. **Sadržaj kategorija:** popuniti stranice proizvodima iz `data/proizvodi.json` i dodati koristan tekst; schema.org `Product` za proizvode.

## Podela posla

- **Claude Code (VS Code):** kodiranje sajta — sve izmene HTML/CSS/JS, commit i push na GitHub.
- **Claude (aplikacija):** pitanja, istraživanje, pisanje završnog rada.
- Rad na sajtu ide na grani `sredjivanje-sajta`; `main` = živi sajt (GitHub Pages), u njega se spaja tek kad je sve provereno.

## Napomene za nastavak

- Podaci o prodavnici uzimaju se **samo** iz `docs/podaci-o-prodavnici.md`, nikad sa starog sajta.
- Opisi proizvoda su pisani sopstvenim rečima, a ne prepisivani od proizvođača.
- Originalni fajlovi sa GitHuba su sačuvani posebno u `source/original/`, za poređenje.
