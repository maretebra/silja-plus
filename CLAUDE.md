# Pet Shop Šilja Plus — statički sajt

Pre bilo kakvog rada pročitaj:
- `docs/sazetak-rada.md` — šta je urađeno, šta čeka odgovor vlasnika, SEO plan (stavku po stavku)
- `docs/podaci-o-prodavnici.md` — JEDINI izvor za ime, adresu, telefon, mejl, PIB/MB. Nikad ne uzimaj podatke sa starog sajta.

Pravila:
- Ime je **Šilja Plus** (ne „Silja“), adresa **Bate Mirkovića 1g, 11233 Ralja, Sopot, Beograd**.
- Telefon i mejl: oni iz registra (+381 69 5575 606, mitrovicmarko1602@gmail.com).
- Tekst na sajtu je na srpskom latinici, sa dijakritikom (č, ć, š, ž, đ).
- Katalog proizvoda: `data/proizvodi.json`. Stavke sa `status: "proveriti"` ne objavljivati dok ih vlasnik ne potvrdi.
- Radi na grani `sredjivanje-sajta`. `main` je živi sajt (GitHub Pages) — ne menjati ga bez pitanja.
- HTML stranice se prave skriptom `ruby tools/generisi-stranice.rb` — ne menjati HTML ručno, nego skriptu.
- Originalni fajlovi sa GitHuba su u `../source/original/` za poređenje.
