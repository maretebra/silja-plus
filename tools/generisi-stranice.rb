# encoding: UTF-8
# Pravi sve HTML stranice sajta, sitemap.xml, robots.txt i site.webmanifest.
#
# Pokretanje (iz foldera silja-plus):
#   ruby tools/generisi-stranice.rb
#
# HTML fajlove u korenu ne menjati ručno — izmene se gube pri sledećem pokretanju.
# Tekst stranica je ovde, katalog hrane u data/proizvodi.json (objavljuju se samo
# stavke sa status: "potvrđeno"), podaci o firmi prate docs/podaci-o-prodavnici.md.

require "json"
require "cgi"

Encoding.default_external = Encoding::UTF_8
ROOT = File.expand_path("..", __dir__)

# Adresa sajta. Kad se pređe na sopstveni domen (npr. https://siljaplus.rs/),
# promeni samo ovaj red i ponovo pokreni skriptu.
BASE_URL = "https://maretebra.github.io/silja-plus/"
LASTMOD = "2026-11-02"

SHOP = {
  name: "Pet Shop Šilja Plus",
  short: "Šilja Plus",
  legal: "Marko Mitrović PR Trgovinska radnja Pet Shop Šilja Plus Ralja",
  street: "Bate Mirkovića 1g",
  postal: "11233",
  city: "Ralja",
  municipality: "Sopot",
  region: "Beograd",
  phone: "+381695575606",
  phone_label: "+381 69 5575 606",
  email: "mitrovicmarko1602@gmail.com",
  pib: "115451135",
  mb: "68376351",
  lat: 44.5695300,
  lng: 20.5602766
}

# Linkovi ka profilima na mrežama. Prazno dok vlasnik ne otvori profile —
# link koji vodi na "#" Google vidi kao pokvaren.
SOCIAL = [] # npr. [["Instagram", "https://www.instagram.com/..."]]

LOGO = "assets/images/logo/silja-plus-logo.png"
LOGO_SMALL = "assets/images/logo/silja-plus-logo-108.png"

CATALOG = JSON.parse(File.read(File.join(ROOT, "data/proizvodi.json")))["proizvodi"]
CONFIRMED = CATALOG.select { |p| p["status"] == "potvrđeno" }

def h(text)
  CGI.escapeHTML(text.to_s)
end
def abs(path)
  BASE_URL + (path == "index.html" ? "" : path)
end
def slug(text)
  text.downcase.tr("čćšžđ", "ccszd").gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
end
def pct(value)
  value.nil? ? nil : "#{value.to_s.sub(".", ",")} %"
end

def json_ld(data)
  %(<script type="application/ld+json">\n#{JSON.pretty_generate(data).gsub("</", "<\\/")}\n</script>)
end

NAV_CATEGORIES = [
  ["sve-za-pse.html", "Sve za pse"],
  ["sve-za-macke.html", "Sve za mačke"],
  ["sve-za-ptice.html", "Sve za ptice"],
  ["sve-za-glodare.html", "Sve za glodare"],
  ["akvaristika-teraristika.html", "Akvaristika i teraristika"],
  ["brendovi.html", "Brendovi"]
]

STORE_ID = BASE_URL + "#prodavnica"

def store_schema
  {
    "@context" => "https://schema.org",
    "@type" => "PetStore",
    "@id" => STORE_ID,
    "name" => SHOP[:name],
    "legalName" => SHOP[:legal],
    "description" => "Pet shop u Ralji (Sopot, Beograd): hrana, poslastice i oprema za pse, mačke, ptice, glodare, akvaristiku i teraristiku.",
    "url" => BASE_URL,
    "logo" => abs(LOGO),
    "image" => abs(LOGO),
    "telephone" => SHOP[:phone],
    "email" => SHOP[:email],
    "taxID" => SHOP[:pib],
    "identifier" => { "@type" => "PropertyValue", "propertyID" => "Matični broj", "value" => SHOP[:mb] },
    "address" => {
      "@type" => "PostalAddress",
      "streetAddress" => SHOP[:street],
      "postalCode" => SHOP[:postal],
      "addressLocality" => SHOP[:city],
      "addressRegion" => SHOP[:region],
      "addressCountry" => "RS"
    },
    "geo" => { "@type" => "GeoCoordinates", "latitude" => SHOP[:lat], "longitude" => SHOP[:lng] },
    "hasMap" => "https://www.openstreetmap.org/?mlat=#{SHOP[:lat]}&mlon=#{SHOP[:lng]}#map=17/#{SHOP[:lat]}/#{SHOP[:lng]}",
    "areaServed" => ["Ralja", "Sopot", "Mali Požarevac", "Beograd"],
    "currenciesAccepted" => "RSD"
  }.tap { |s| s["sameAs"] = SOCIAL.map(&:last) unless SOCIAL.empty? }
end

def breadcrumb_schema(crumbs)
  {
    "@context" => "https://schema.org",
    "@type" => "BreadcrumbList",
    "itemListElement" => crumbs.each_with_index.map do |(path, name), i|
      { "@type" => "ListItem", "position" => i + 1, "name" => name, "item" => abs(path) }
    end
  }
end

def head(page)
  url = abs(page[:path])
  robots = page[:noindex] ? %(\n    <meta name="robots" content="noindex">) : ""
  canonical = page[:noindex] ? "" : %(\n    <link rel="canonical" href="#{url}">)
  # Stranica 404 se prikazuje na bilo kojoj adresi, pa koristi pune putanje.
  pre = page[:absolute] ? BASE_URL : "./"
  schemas = (page[:schema] || []).map { |s| "    " + json_ld(s).gsub("\n", "\n    ") }.join("\n")
  <<~HTML
    <!DOCTYPE html>
    <html lang="sr-Latn">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>#{h page[:title]}</title>
        <meta name="description" content="#{h page[:description]}">#{robots}#{canonical}
        <meta name="theme-color" content="#222553">
        <meta property="og:type" content="website">
        <meta property="og:locale" content="sr_RS">
        <meta property="og:site_name" content="#{h SHOP[:name]}">
        <meta property="og:title" content="#{h page[:title]}">
        <meta property="og:description" content="#{h page[:description]}">
        <meta property="og:url" content="#{url}">
        <meta property="og:image" content="#{abs(LOGO)}">
        <meta property="og:image:width" content="239">
        <meta property="og:image:height" content="308">
        <meta property="og:image:alt" content="Logo prodavnice #{h SHOP[:name]}">
        <meta name="twitter:card" content="summary">
        <meta name="twitter:title" content="#{h page[:title]}">
        <meta name="twitter:description" content="#{h page[:description]}">
        <meta name="twitter:image" content="#{abs(LOGO)}">
        <link rel="icon" type="image/png" sizes="48x48" href="#{pre}assets/images/icons/favicon-48.png">
        <link rel="icon" type="image/png" sizes="96x96" href="#{pre}assets/images/icons/favicon-96.png">
        <link rel="icon" type="image/png" sizes="192x192" href="#{pre}assets/images/icons/favicon-192.png">
        <link rel="apple-touch-icon" href="#{pre}assets/images/icons/apple-touch-icon.png">
        <link rel="manifest" href="#{pre}site.webmanifest">
        <link rel="preload" href="#{pre}assets/fonts/baloo-2-latin.woff2" as="font" type="font/woff2" crossorigin>
        <link rel="preload" href="#{pre}assets/fonts/bree-serif-latin.woff2" as="font" type="font/woff2" crossorigin>
        <link rel="stylesheet" href="#{pre}assets/css/main.css">
    #{schemas}
    </head>
  HTML
end

def header(page)
  pre = page[:absolute] ? BASE_URL : "./"
  cur = ->(path) { page[:path] == path ? " current" : "" }
  in_category = NAV_CATEGORIES.any? { |path, _| path == page[:path] }
  aria = ->(path) { page[:path] == path ? %( aria-current="page") : "" }
  items = NAV_CATEGORIES.map do |path, name|
    cls = page[:path] == path ? %( class="current") : ""
    %(                        <a#{cls} href="#{pre}#{path}"#{aria.(path)}>#{name}</a>)
  end.join("\n")
  <<~HTML
    <body>
        <a class="sr-only" href="#sadrzaj">Preskoči na sadržaj</a>
        <header class="site-header">
            <div class="container header-inner">
                <a class="brand" href="#{pre}index.html" aria-label="#{h SHOP[:name]} — početna">
                    <span class="brand-mark"><img class="brand-logo" src="#{pre}#{LOGO_SMALL}" alt="" width="84" height="108"></span>
                    <span class="brand-copy"><strong>Pet Shop</strong><span>#{h SHOP[:short]}</span></span>
                </a>
                <button class="nav-toggle" type="button" aria-expanded="false" aria-controls="site-nav"><span></span><span></span><span></span><span class="sr-only">Otvori meni</span></button>
                <nav class="site-nav" id="site-nav" aria-label="Glavna navigacija">
                    <a class="nav-link#{cur.("index.html")}" href="#{pre}index.html"#{aria.("index.html")}>Početna</a>
                    <a class="nav-link#{cur.("o-nama.html")}" href="#{pre}o-nama.html"#{aria.("o-nama.html")}>O nama</a>
                    <div class="nav-dropdown">
                        <button class="nav-dropdown-toggle#{in_category ? " current" : ""}" type="button" aria-expanded="false">Kategorije</button>
                        <div class="dropdown-menu">
    #{items}
                        </div>
                    </div>
                </nav>
            </div>
        </header>
  HTML
end

def footer(page)
  pre = page[:absolute] ? BASE_URL : "./"
  socials = SOCIAL.empty? ? "" : %(\n            <div class="socials">#{SOCIAL.map { |n, u| %(<a href="#{h u}" rel="noopener">#{n}</a>) }.join}</div>)
  <<~HTML
        <footer class="site-footer">
            <div class="container footer-grid">
                <div class="footer-brand">
                    <div class="footer-logo"><img class="brand-logo" src="#{pre}#{LOGO_SMALL}" alt="" width="84" height="108" loading="lazy"></div>
                    <div>
                        <h2>#{h SHOP[:short]}</h2>
                        <p>Pet shop u Ralji: hrana, poslastice i oprema za pse, mačke, ptice, glodare i ribice.</p>
                    </div>
                </div>
                <div class="contact-list">
                    <div class="contact-item"><span class="contact-label">Lokacija</span><address>#{h SHOP[:street]}<br>#{SHOP[:postal]} #{SHOP[:city]}, #{SHOP[:municipality]}, #{SHOP[:region]}</address></div>
                    <div class="contact-item"><span class="contact-label">Telefon</span><a href="tel:#{SHOP[:phone]}">#{SHOP[:phone_label]}</a></div>
                    <div class="contact-item"><span class="contact-label">Mejl</span><a href="mailto:#{SHOP[:email]}">#{SHOP[:email]}</a></div>
                </div>#{socials}
            </div>
            <p class="container footer-legal">#{h SHOP[:legal]} · PIB #{SHOP[:pib]} · MB #{SHOP[:mb]}</p>
        </footer>

        <script src="#{pre}assets/js/main.js" defer></script>
    </body>
    </html>
  HTML
end

def page_hero(kicker, title, text, crumbs = nil)
  nav = ""
  if crumbs
    items = crumbs.each_with_index.map do |(path, name), i|
      i == crumbs.size - 1 ? %(<li aria-current="page">#{h name}</li>) : %(<li><a href="./#{path}">#{h name}</a></li>)
    end.join
    nav = %(\n                <nav class="breadcrumbs" aria-label="Putokaz"><ol>#{items}</ol></nav>)
  end
  <<~HTML
            <section class="page-hero">
                <div class="container page-hero-inner">#{nav}
                    <p class="eyebrow">#{h kicker}</p>
                    <h1>#{h title}</h1>
                    <p>#{text}</p>
                </div>
            </section>
  HTML
end

def simple_card(thumb_class, thumb, title, text, price)
  %(<article class="product-card"><div class="product-thumb #{thumb_class}" aria-hidden="true">#{h thumb}</div><h3>#{h title}</h3><p>#{h text}</p><strong>#{h price}</strong></article>)
end

def write(path, html)
  File.write(File.join(ROOT, path), html)
  puts "  #{path}"
end

def to_list(items)
  items.size > 1 ? items[0..-2].join(", ") + " i " + items[-1] : items.join
end

# ---------- Katalog hrane ----------

def food_card(p)
  facts = []
  facts << ["Uzrast", p["uzrast"]]
  facts << ["Rasa", p["velicina_rase"]] unless p["velicina_rase"].to_s.empty?
  facts << ["Meso", p["glavni_protein"]] unless p["glavni_protein"].to_s.empty?
  pm = [pct(p["protein_pct"]) && "proteini #{pct(p["protein_pct"])}", pct(p["mast_pct"]) && "masti #{pct(p["mast_pct"])}"].compact
  facts << ["Sastav", pm.join(", ")] unless pm.empty?
  facts << ["Pakovanja", p["pakovanja"].join(", ")] unless p["pakovanja"].empty?
  dl = facts.map { |k, v| "<dt>#{k}</dt><dd>#{h v}</dd>" }.join
  <<~HTML.chomp
    <article class="food-card" id="#{p["id"]}">
                            <h4>#{h p["naziv"]}</h4>
                            <span class="food-line">#{h p["brend"]} · #{h p["linija"]}</span>
                            <p>#{h p["kratak_opis"]}</p>
                            <dl class="food-facts">#{dl}</dl>
                        </article>
  HTML
end

def food_catalog(animal)
  CONFIRMED.select { |p| p["zivotinja"] == animal }.group_by { |p| p["brend"] }.map do |brand, items|
    <<~HTML
                    <div class="brand-group" id="#{slug(brand)}">
                        <h3 class="brand-group-title">#{h brand}</h3>
                        <div class="food-grid">
                            #{items.map { |p| food_card(p) }.join("\n                            ")}
                        </div>
                    </div>
    HTML
  end.join
end

# Brendovi čije tačne varijante vlasnik još nije potvrdio — pominju se samo imenom.
def other_brands_sentence(animal)
  shown = CONFIRMED.select { |p| p["zivotinja"] == animal }.map { |p| p["brend"] }.uniq
  pending = CATALOG.select { |p| p["zivotinja"] == animal && p["status"] != "potvrđeno" }
                   .map { |p| p["brend"] }.uniq.reject { |b| b == "SmartDog" }
  more, other = pending.partition { |b| shown.include?(b) }
  parts = []
  parts << "još proizvoda brendova #{to_list(more)}" if more.size > 1
  parts << "još proizvoda brenda #{more.first}" if more.size == 1
  parts << "hranu #{to_list(other)}" unless other.empty?
  "U ponudi imamo i #{parts.join(", kao i ")}."
end

def catalog_schema(page, animal, label)
  items = CONFIRMED.select { |p| p["zivotinja"] == animal }
  {
    "@context" => "https://schema.org",
    "@type" => "CollectionPage",
    "name" => page[:title],
    "url" => abs(page[:path]),
    "inLanguage" => "sr-Latn",
    "isPartOf" => { "@type" => "WebSite", "name" => SHOP[:name], "url" => BASE_URL },
    "about" => { "@id" => STORE_ID },
    "mainEntity" => {
      "@type" => "ItemList",
      "name" => label,
      "numberOfItems" => items.size,
      "itemListElement" => items.each_with_index.map do |p, i|
        {
          "@type" => "ListItem",
          "position" => i + 1,
          "item" => {
            "@type" => "Product",
            "name" => p["naziv"],
            "url" => abs(page[:path]) + "##{p["id"]}",
            "brand" => { "@type" => "Brand", "name" => p["brend"] },
            "category" => label,
            "description" => p["kratak_opis"]
          }
        }
      end
    }
  }
end


puts "Pravim stranice:"

# ---------- index.html ----------
page = {
  path: "index.html",
  title: "Pet Shop Šilja Plus Ralja | Hrana i oprema za ljubimce",
  description: "Pet shop u Ralji (Sopot): hrana za pse i mačke Premil, Josera, Farmina, Monge, Brit i druge, poslastice i oprema za ptice, glodare i akvarijume.",
  schema: [store_schema, { "@context" => "https://schema.org", "@type" => "WebSite", "name" => SHOP[:name], "url" => BASE_URL, "inLanguage" => "sr-Latn", "publisher" => { "@id" => STORE_ID } }]
}
write "index.html", head(page) + header(page) + <<~HTML + footer(page)
    <main id="sadrzaj">
        <section class="hero">
            <div class="container hero-grid">
                <div class="hero-copy">
                    <p class="eyebrow">Pet shop u Ralji, opština Sopot</p>
                    <h1>Sve za vaše ljubimce na jednom mestu</h1>
                    <p class="hero-text">
                        Pet Shop Šilja Plus u Ralji: hrana, poslastice, oprema i pažljivo birani brendovi
                        za pse, mačke, glodare, ptice, akvaristiku i teraristiku — uz savet pri svakoj kupovini.
                    </p>
                    <div class="hero-actions">
                        <a class="btn btn-primary" href="./sve-za-pse.html">Hrana za pse</a>
                        <a class="btn btn-secondary" href="./sve-za-macke.html">Hrana za mačke</a>
                    </div>
                </div>
                <div class="hero-visual" aria-hidden="true">
                    <div class="hero-bubble hero-bubble-top"></div>
                    <div class="hero-bubble hero-bubble-bottom"></div>
                    <div class="dog-card">
                        <div class="dog-portrait">
                            <img src="./#{LOGO}" alt="" width="239" height="308" fetchpriority="high">
                        </div>
                    </div>
                </div>
            </div>
            <div class="hero-wave" aria-hidden="true">
                <svg viewBox="0 0 1440 170" preserveAspectRatio="none">
                    <path d="M0,78 C120,125 260,10 380,60 C520,118 645,143 760,96 C882,45 1020,7 1140,45 C1262,82 1365,150 1440,105 L1440,170 L0,170 Z"></path>
                    <path d="M0,110 C120,155 230,65 360,98 C490,132 585,164 742,112 C900,58 1028,58 1165,97 C1299,135 1375,118 1440,90"></path>
                </svg>
            </div>
        </section>

        <section class="catalog-section">
            <div class="container">
                <div class="section-heading">
                    <div>
                        <p class="section-kicker">Najtraženiji izbor</p>
                        <h2>Najprodavanije</h2>
                    </div>
                    <p>Hrana i oprema koju kupci najčešće biraju za svakodnevnu negu i ishranu ljubimaca.</p>
                </div>
                <div class="carousel-shell">
                    <button class="carousel-btn" type="button" data-carousel-prev aria-label="Prethodni proizvodi">&#8249;</button>
                    <div class="card-row" data-carousel>
                        #{simple_card("thumb-premil", "Premil Dog", "Premil Special 15 kg", "Jagnjetina i pirinač za odrasle pse svih rasa.", "5.400,00 RSD")}
                        #{simple_card("thumb-premil", "Premil Cat", "Premil Mix 10 kg", "Kompletna hrana za mačke.", "5.100,00 RSD")}
                        #{simple_card("thumb-bowl", "Činija", "Činija za pse", "Nerđajući čelik, više dimenzija.", "300,00 RSD")}
                        #{simple_card("thumb-rope", "Igračka", "Konopac za igru", "Za zabavu i trening pasa.", "300,00 RSD")}
                        #{simple_card("thumb-aqua", "Akvarijum", "Osnovna oprema za akvarijum", "Za uređenje i održavanje vode.", "od 1.990,00 RSD")}
                    </div>
                    <button class="carousel-btn" type="button" data-carousel-next aria-label="Sledeći proizvodi">&#8250;</button>
                </div>
            </div>
        </section>

        <section class="pet-types">
            <div class="container">
                <div class="section-heading">
                    <div>
                        <p class="section-kicker">Brza pretraga</p>
                        <h2>Kupujte prema vrsti ljubimca</h2>
                    </div>
                    <p>Za svaku vrstu ljubimca postoji posebna stranica sa ponudom i savetima za izbor.</p>
                </div>
                <div class="pet-grid">
                    <a class="pet-card" href="./sve-za-macke.html"><div class="pet-icon pet-icon-cat" aria-hidden="true">M</div><h3>Sve za mačke</h3></a>
                    <a class="pet-card" href="./sve-za-pse.html"><div class="pet-icon pet-icon-dog" aria-hidden="true">P</div><h3>Sve za pse</h3></a>
                    <a class="pet-card" href="./sve-za-glodare.html"><div class="pet-icon pet-icon-bunny" aria-hidden="true">G</div><h3>Sve za glodare</h3></a>
                    <a class="pet-card" href="./sve-za-ptice.html"><div class="pet-icon pet-icon-bird" aria-hidden="true">Pt</div><h3>Sve za ptice</h3></a>
                    <a class="pet-card" href="./akvaristika-teraristika.html"><div class="pet-icon pet-icon-fish" aria-hidden="true">A</div><h3>Akvaristika i teraristika</h3></a>
                </div>
            </div>
        </section>

        <section class="brand-section">
            <div class="container">
                <div class="section-heading">
                    <div>
                        <p class="section-kicker">Pouzdani partneri</p>
                        <h2>Kupujte prema brendu</h2>
                    </div>
                    <p>Hrana za pse i mačke proverenih proizvođača, u pakovanjima za svaki dan i za veće ljubimce.</p>
                </div>
                <div class="brand-grid">
                    <a class="brand-card brand-premil" href="./brendovi.html#premil">PREMIL</a>
                    <a class="brand-card brand-josera" href="./brendovi.html#josera">Josera</a>
                    <a class="brand-card brand-nekmar" href="./brendovi.html">Nekmar</a>
                    <a class="brand-card brand-monge" href="./brendovi.html#monge">monge</a>
                    <a class="brand-card brand-farmina" href="./brendovi.html#farmina">farmina</a>
                </div>
            </div>
        </section>

        <section class="page-section">
            <div class="container text-block">
                <p class="section-kicker">Gde se nalazimo</p>
                <h2 class="section-title">Pet shop u Ralji, za Sopot i okolinu</h2>
                <p>
                    Pet Shop Šilja Plus nalazi se u ulici #{SHOP[:street]} u Ralji (#{SHOP[:postal]}), u gradskoj opštini Sopot.
                    Kod nas kupuju vlasnici ljubimaca iz Ralje, Sopota, Malog Požarevca i okolnih sela, kojima je
                    bliže da hranu i opremu kupe u komšiluku nego da idu do velikih prodavnica u gradu.
                </p>
                <p>
                    U ponudi je suva hrana za pse i mačke domaćih i stranih proizvođača — od ekonomičnih pakovanja
                    od 10 do 15 kg do superpremium hrane za osetljive ljubimce — kao i poslastice, posude, igračke,
                    hrana i oprema za ptice, glodare, ribice i terarijume. Pre kupovine nas možete pozvati na
                    <a href="tel:#{SHOP[:phone]}">#{SHOP[:phone_label]}</a> da proverite da li je željeno pakovanje na stanju.
                </p>
            </div>
        </section>
    </main>

HTML

# ---------- o-nama.html ----------
crumbs = [["index.html", "Početna"], ["o-nama.html", "O nama"]]
page = {
  path: "o-nama.html",
  title: "O nama | Pet Shop Šilja Plus, Ralja (Sopot)",
  description: "Pet Shop Šilja Plus je lokalna prodavnica za kućne ljubimce u Ralji, Bate Mirkovića 1g. Proverena hrana, oprema i iskren savet pri izboru.",
  schema: [breadcrumb_schema(crumbs), {
    "@context" => "https://schema.org", "@type" => "AboutPage", "name" => "O nama", "url" => abs("o-nama.html"),
    "inLanguage" => "sr-Latn", "about" => { "@id" => STORE_ID }
  }]
}
write "o-nama.html", head(page) + header(page) + <<~HTML + footer(page)
    <main id="sadrzaj">
#{page_hero("Ko smo mi", "Prodavnica koja bira proizvode kao da ih kupuje za svoje ljubimce", "Šilja Plus je lokalni pet shop u Ralji u kome brzo nalazite proverenu hranu, kvalitetnu opremu i iskren savet, bez komplikacija.", crumbs)}
        <section class="story-section">
            <div class="container">
                <p class="section-kicker">Naša priča</p>
                <h2 class="section-title">Ljubav prema životinjama kao osnova svakog izbora</h2>
                <p class="section-intro">
                    Kupac kod nas treba brzo da pronađe ono što mu treba, da dobije iskren savet i da
                    zna da je hrana koju nosi kući proverena.
                </p>
                <div class="content-grid">
                    <article class="info-card">
                        <h3>Proveren asortiman</h3>
                        <p>Biramo hranu, poslastice i opremu koji odgovaraju svakodnevnim potrebama ljubimaca.</p>
                    </article>
                    <article class="info-card">
                        <h3>Jasne kategorije</h3>
                        <p>Posebne stranice za pse, mačke, ptice, glodare i akvaristiku olakšavaju pretragu.</p>
                    </article>
                    <article class="info-card">
                        <h3>Savet u radnji</h3>
                        <p>Pomažemo pri izboru hrane prema uzrastu, veličini i osetljivosti vašeg ljubimca.</p>
                    </article>
                </div>
            </div>
        </section>

        <section class="page-section">
            <div class="container">
                <p class="section-kicker">Zašto Šilja Plus</p>
                <h2 class="section-title">Lokalna prodavnica za ljubimce u Ralji</h2>
                <p class="section-intro">
                    Nalazimo se u ulici #{SHOP[:street]} u Ralji, opština Sopot. Za pitanja o ponudi i
                    pakovanjima pozovite nas na <a href="tel:#{SHOP[:phone]}">#{SHOP[:phone_label]}</a> ili pošaljite mejl na
                    <a href="mailto:#{SHOP[:email]}">#{SHOP[:email]}</a>.
                </p>
                <div class="stats-grid">
                    <div class="stat-card"><div><strong>5</strong><span>vrsta ljubimaca</span></div></div>
                    <div class="stat-card"><div><strong>10+</strong><span>brendova hrane</span></div></div>
                    <div class="stat-card"><div><strong>Ralja</strong><span>Sopot, Beograd</span></div></div>
                    <div class="stat-card"><div><strong>Savet</strong><span>pri svakoj kupovini</span></div></div>
                </div>
                <div class="cta-row">
                    <a class="btn btn-primary" href="./sve-za-pse.html">Hrana i oprema za pse</a>
                    <a class="btn btn-primary" href="./sve-za-macke.html">Hrana i oprema za mačke</a>
                </div>
            </div>
        </section>
    </main>

HTML

# ---------- sve-za-pse.html ----------
crumbs = [["index.html", "Početna"], ["sve-za-pse.html", "Sve za pse"]]
page = {
  path: "sve-za-pse.html",
  title: "Hrana i oprema za pse u Ralji | Pet Shop Šilja Plus",
  description: "Granule za štence, odrasle i starije pse: Premil, Josera, JosiDog, Natural Trainer, Pet PRO, Friskies. Posude, igračke i oprema za šetnju u Ralji."
}
page[:schema] = [breadcrumb_schema(crumbs), catalog_schema(page, "pas", "Hrana za pse")]
write "sve-za-pse.html", head(page) + header(page) + <<~HTML + footer(page)
    <main id="sadrzaj">
#{page_hero("Kategorije", "Hrana i oprema za pse", "Suva hrana za štence, odrasle i starije pse, posude, igračke i oprema za šetnju — u Ralji, uz savet za izbor prave hrane.", crumbs)}
        <section class="page-section">
            <div class="container">
                <p class="section-kicker">Istaknuto</p>
                <h2 class="section-title">Osnovna ponuda za pse</h2>
                <p class="section-intro">Granule za štence, odrasle i starije pse, posude, igračke i oprema za šetnju. Za trenutnu ponudu i pakovanja pozovite nas ili svratite u radnju.</p>
                <div class="content-grid">
                    #{simple_card("thumb-premil", "Hrana", "Granule za odrasle pse", "Kompletna svakodnevna ishrana za male, srednje i velike rase.", "od 3.250,00 RSD")}
                    #{simple_card("thumb-bowl", "Činije", "Posude i činije", "Metalne, plastične i protiv klizanja.", "od 300,00 RSD")}
                    #{simple_card("thumb-rope", "Igračke", "Konopci i loptice", "Za igru, trening i svakodnevnu aktivnost.", "od 250,00 RSD")}
                </div>
            </div>
        </section>

        <section class="page-section" aria-labelledby="hrana-za-pse">
            <div class="container">
                <p class="section-kicker">Katalog</p>
                <h2 class="section-title" id="hrana-za-pse">Hrana za pse koju držimo</h2>
                <p class="section-intro">Podaci o sastavu i pakovanjima preuzeti su od proizvođača. Cene i trenutno stanje proverite telefonom ili u radnji.</p>
#{food_catalog("pas")}
                <p class="note-box">#{h other_brands_sentence("pas")} Pitajte nas koje varijante su trenutno na stanju: <a href="tel:#{SHOP[:phone]}">#{SHOP[:phone_label]}</a>.</p>
            </div>
        </section>

        <section class="page-section">
            <div class="container text-block">
                <p class="section-kicker">Saveti</p>
                <h2>Kako izabrati hranu za psa</h2>
                <p>Ne postoji jedna hrana koja odgovara svakom psu. Pri izboru gledamo četiri stvari: uzrast, veličinu, aktivnost i to da li pas ima osetljiv stomak ili kožu.</p>
                <h3>Uzrast: štene, odrastao ili stariji pas</h3>
                <p>Štencima treba hrana za rast, sa više proteina i energije — na primer <a href="#premil-maxi-puppy-junior">Premil Maxi Puppy Junior</a>, <a href="#premil-junior">Premil Junior</a> ili <a href="#josera-kids">Josera Kids</a> za srednje i velike rase. Male rase uglavnom prelaze na hranu za odrasle oko prve godine, a velike kasnije, i do druge godine. Stariji i manje aktivni psi bolje podnose hranu sa manje masti, kao što su <a href="#josera-balance">Josera Balance</a> i <a href="#premil-maxi-basic">Premil Maxi Basic</a>.</p>
                <h3>Veličina rase</h3>
                <p>Mali psi imaju mala usta i brži metabolizam, pa im odgovaraju sitnije granule, kao u hrani <a href="#premil-mini">Premil Mini</a> ili <a href="#natural-trainer-sensitive-small-toy-jagnjetina">Natural Trainer Small &amp; Toy</a>. Za velike rase postoji posebna hrana, kao <a href="#premil-large">Premil Large</a>.</p>
                <h3>Koliko je pas aktivan</h3>
                <p>Lovački, radni i sportski psi troše mnogo više energije od psa koji je ceo dan u dvorištu. Za njih je hrana sa više masti: <a href="#premil-super-sport">Premil Super Sport</a>, <a href="#premil-maxi-athletic">Premil Maxi Athletic</a> ili <a href="#josidog-active">JosiDog Active</a>. Sterilisanim i gojaznim psima treba manje kalorija.</p>
                <h3>Osetljiv stomak ili koža</h3>
                <p>Ako se pas često češe ili ima mekšu stolicu, pomaže hrana sa jednim izvorom mesa, najčešće jagnjetinom ili ribom: <a href="#josera-lamb-rice">Josera Lamb &amp; Rice</a>, <a href="#josera-sensiplus">Josera SensiPlus</a>, <a href="#premil-sunrise">Premil Sunrise</a> ili <a href="#petpro-fish">Pet PRO Fish</a>. Kod jačih tegoba prvo se posavetujte sa veterinarom.</p>
                <h3>Prelazak na novu hranu</h3>
                <ul>
                    <li>Novu hranu uvodite postepeno, tokom 7 do 10 dana, mešajući je sa starom.</li>
                    <li>Dnevnu količinu odredite prema tabeli na pakovanju i prilagodite je kondiciji psa.</li>
                    <li>Pas uvek treba da ima svežu vodu, posebno uz suvu hranu.</li>
                </ul>
            </div>
        </section>
    </main>

HTML

# ---------- sve-za-macke.html ----------
crumbs = [["index.html", "Početna"], ["sve-za-macke.html", "Sve za mačke"]]
page = {
  path: "sve-za-macke.html",
  title: "Hrana i oprema za mačke u Ralji | Pet Shop Šilja Plus",
  description: "Hrana za mačiće, odrasle i sterilisane mačke: Josera, JosiCat, Friskies, Brit, Farmina N&D, Pet PRO. Posude, igračke i oprema za mačke u Ralji."
}
page[:schema] = [breadcrumb_schema(crumbs), catalog_schema(page, "mačka", "Hrana za mačke")]
write "sve-za-macke.html", head(page) + header(page) + <<~HTML + footer(page)
    <main id="sadrzaj">
#{page_hero("Kategorije", "Hrana i oprema za mačke", "Hrana za mačiće, odrasle i sterilisane mačke, činije, igračke i oprema za udoban život mačke u stanu ili kući.", crumbs)}
        <section class="page-section">
            <div class="container">
                <p class="section-kicker">Istaknuto</p>
                <h2 class="section-title">Ponuda za mačke</h2>
                <div class="content-grid">
                    #{simple_card("thumb-cat", "Hrana", "Suva hrana za mačke", "Za mačiće i odrasle mačke sa različitim nutritivnim potrebama.", "od 490,00 RSD")}
                    #{simple_card("thumb-bowl", "Činije", "Činije i podloge", "Praktična oprema za svakodnevnu ishranu.", "od 300,00 RSD")}
                    #{simple_card("thumb-rope", "Igra", "Igračke za mačke", "Štapići, loptice i zabavne viseće igračke.", "od 220,00 RSD")}
                </div>
            </div>
        </section>

        <section class="page-section" aria-labelledby="hrana-za-macke">
            <div class="container">
                <p class="section-kicker">Katalog</p>
                <h2 class="section-title" id="hrana-za-macke">Hrana za mačke koju držimo</h2>
                <p class="section-intro">Podaci o sastavu i pakovanjima preuzeti su od proizvođača. Cene i trenutno stanje proverite telefonom ili u radnji.</p>
#{food_catalog("mačka")}
                <p class="note-box">#{h other_brands_sentence("mačka")} Pitajte nas koje varijante su trenutno na stanju: <a href="tel:#{SHOP[:phone]}">#{SHOP[:phone_label]}</a>.</p>
            </div>
        </section>

        <section class="page-section">
            <div class="container text-block">
                <p class="section-kicker">Saveti</p>
                <h2>Kako izabrati hranu za mačku</h2>
                <p>Mačke su mesojedi i probirljive su, pa je dobra hrana ona koja ima dovoljno mesa i koju će mačka rado jesti. Najvažnije je uskladiti hranu sa uzrastom i načinom života.</p>
                <h3>Mačići</h3>
                <p>Do prve godine mačiću treba hrana za rast, bogatija proteinima i mastima, kao što je <a href="#josera-kitten">Josera Kitten</a>. Mačići jedu češće i u manjim obrocima.</p>
                <h3>Sterilisane i manje aktivne mačke</h3>
                <p>Posle sterilizacije mačke lakše dobijaju na težini. Hrana sa manje masti, kao <a href="#josera-leger">Josera Léger</a>, pomaže da mačka ostane u dobroj kondiciji.</p>
                <h3>Probirljive mačke i osetljiv stomak</h3>
                <p>Za mačke koje biraju hranu dobar izbor su ukusi sa lososom i pačetinom (<a href="#josera-culinesse">Josera Culinesse</a>, <a href="#josera-catelux">Josera Catelux</a>), a za osetljiv stomak lako svarljiva <a href="#josera-sensicat">Josera SensiCat</a>. Za svakodnevnu ishranu po pristupačnoj ceni tu su <a href="#josicat-crunchy-chicken">JosiCat</a> i <a href="#friskies-adult-piletina-macka">Friskies</a>.</p>
                <h3>Voda i navike</h3>
                <ul>
                    <li>Mačke uz suvu hranu piju premalo vode — držite činiju sa svežom vodom dalje od hrane i peska.</li>
                    <li>Novu hranu uvodite postepeno, tokom 7 do 10 dana.</li>
                    <li>Ako mačka odbija hranu duže od dan-dva, javite se veterinaru.</li>
                </ul>
            </div>
        </section>
    </main>

HTML

# ---------- Kategorije bez kataloga ----------
small_pages = [
  {
    path: "sve-za-ptice.html", name: "Sve za ptice",
    title: "Hrana i oprema za ptice | Pet Shop Šilja Plus Ralja",
    description: "Mešavine semena za tigrice, kanarince i papagaje, vitamini, kamen za kljun i oprema za kavez. Pet Shop Šilja Plus u Ralji, opština Sopot.",
    h1: "Hrana i oprema za ptice",
    lead: "Mešavine hrane, oprema za kaveze, poslastice i dodaci za veselu i zdravu pticu.",
    heading: "Ponuda za ptice",
    cards: [
      ["thumb-bird", "Hrana", "Mešavine za ptice", "Za tigrice, kanarince i druge male kućne ptice.", "od 180,00 RSD"],
      ["thumb-bird", "Dodaci", "Vitamini i kamen za kljun", "Dodaci za negu i pravilnu ishranu.", "od 150,00 RSD"],
      ["thumb-bird", "Kavez", "Oprema za kavez", "Prečke, hranilice i male igračke za aktivnost.", "od 240,00 RSD"]
    ],
    text: <<~T
      <h2>Saveti za ishranu i negu ptica</h2>
      <p>Tigrice, kanarinci, nimfe i agapornisi imaju različite potrebe, zato za svaku vrstu postoji posebna mešavina semena. Mešavina za tigrice nije ista kao mešavina za kanarince, pa uvek birajte hranu prema vrsti ptice.</p>
      <h3>Osnova ishrane</h3>
      <ul>
        <li>Mešavina semena za vrstu ptice, u čistoj hranilici, svaki dan.</li>
        <li>Sveže voće i povrće u malim količinama (jabuka, šargarepa, zelena salata), dobro oprano.</li>
        <li>Sveža voda koja se menja svakog dana.</li>
      </ul>
      <h3>Dodaci</h3>
      <p>Sipina kost i kamen za kljun daju kalcijum i pomažu da se kljun prirodno troši. Vitamini u vodi korisni su u vreme mitarenja i kod ptica koje se pare.</p>
      <h3>Kavez</h3>
      <p>Ptici treba dovoljno prostora da raširi krila, nekoliko prečki različite debljine i poneka igračka. Kavez držite na svetlom mestu, ali ne na direktnom suncu i promaji.</p>
    T
  },
  {
    path: "sve-za-glodare.html", name: "Sve za glodare",
    title: "Hrana i oprema za glodare | Pet Shop Šilja Plus Ralja",
    description: "Hrana, seno, piljevina, poslastice i oprema za hrčke, zamorce, kuniće i činčile. Pet Shop Šilja Plus u Ralji, opština Sopot, Beograd.",
    h1: "Hrana i oprema za glodare",
    lead: "Hrana, piljevina, poslastice i sitna oprema za hrčke, zamorce, kuniće i druge male ljubimce.",
    heading: "Ponuda za glodare",
    cards: [
      ["thumb-cat", "Hrana", "Mešavine i peleti", "Za kuniće, zamorce, hrčke i druge male životinje.", "od 260,00 RSD"],
      ["thumb-bowl", "Oprema", "Pojilice i posude", "Praktični dodaci za svakodnevnu negu i hranjenje.", "od 350,00 RSD"],
      ["thumb-rope", "Poslastice", "Grickalice i seno", "Za zanimaciju, trošenje zuba i ishranu.", "od 190,00 RSD"]
    ],
    text: <<~T
      <h2>Saveti za ishranu glodara</h2>
      <p>Zubi glodara rastu celog života, zato im je potrebna hrana koju moraju da grizu. Ishrana se razlikuje od vrste do vrste.</p>
      <h3>Kunići i zamorci</h3>
      <p>Osnova ishrane je kvalitetno seno, koje treba da im bude dostupno stalno. Uz seno daju se peleti i malo svežeg povrća. Zamorci ne mogu sami da stvaraju vitamin C, pa ga moraju dobijati hranom.</p>
      <h3>Hrčci, miševi i gerbili</h3>
      <p>Njima odgovara mešavina semena, žitarica i peleta, uz povremenu poslasticu. Hrčci su aktivni noću i vole da imaju točak i kućicu u kojoj mogu da se sakriju.</p>
      <h3>Kavez i higijena</h3>
      <ul>
        <li>Piljevinu ili drugu prostirku menjajte redovno, da kavez ne bi mirisao.</li>
        <li>Pojilica sa svežom vodom treba da bude puna svakog dana.</li>
        <li>Grickalice od drveta i seno pomažu da se zubi pravilno troše.</li>
      </ul>
    T
  },
  {
    path: "akvaristika-teraristika.html", name: "Akvaristika i teraristika",
    title: "Akvaristika i teraristika | Pet Shop Šilja Plus Ralja",
    description: "Hrana za ribice, sredstva za vodu, mrežice, termometri, dekoracija i oprema za terarijume. Pet Shop Šilja Plus u Ralji, opština Sopot.",
    h1: "Akvaristika i teraristika",
    lead: "Hrana, oprema i osnovni dodaci za ribice, akvarijume, terarijume i njihovo održavanje.",
    heading: "Ponuda za akvarijume i terarijume",
    cards: [
      ["thumb-aqua", "Akvarijum", "Osnovna oprema", "Mrežice, termometri, sredstva za vodu i dekoracija.", "od 290,00 RSD"],
      ["thumb-aqua", "Hrana", "Hrana za ribice", "Pahuljice, granule i dodatna ishrana za akvarijumske vrste.", "od 180,00 RSD"],
      ["thumb-aqua", "Terarijum", "Dodaci za teraristiku", "Podloge, posude i osnovna oprema za uređenje prostora.", "od 390,00 RSD"]
    ],
    text: <<~T
      <h2>Saveti za akvarijum i terarijum</h2>
      <h3>Pokretanje akvarijuma</h3>
      <p>Novi akvarijum treba da radi sa filterom nekoliko nedelja pre nego što se u njega puste ribice, da bi se u vodi razvile korisne bakterije. Voda iz česme se pre upotrebe tretira sredstvom za uklanjanje hlora.</p>
      <h3>Hranjenje ribica</h3>
      <ul>
        <li>Hranite jednom do dva puta dnevno, onoliko koliko ribice pojedu za par minuta.</li>
        <li>Višak hrane kvari vodu — bolje je dati manje nego previše.</li>
        <li>Pahuljice su za ribice koje jedu na površini, a granule i tablete za one koje se hrane pri dnu.</li>
      </ul>
      <h3>Održavanje</h3>
      <p>Deo vode (oko 20 do 30 procenata) menja se jednom nedeljno, a temperatura se prati termometrom. Filter se ispira u vodi iz akvarijuma, ne pod česmom.</p>
      <h3>Terarijum</h3>
      <p>Kornjačama, gušterima i drugim gmizavcima potrebni su odgovarajuća podloga, posuda za vodu i izvor toplote. Pre kupovine nam recite koju životinju imate, pa ćemo vam pomoći da izaberete opremu.</p>
    T
  }
]

small_pages.each do |sp|
  crumbs = [["index.html", "Početna"], [sp[:path], sp[:name]]]
  page = {
    path: sp[:path], title: sp[:title], description: sp[:description],
    schema: [breadcrumb_schema(crumbs), {
      "@context" => "https://schema.org", "@type" => "CollectionPage", "name" => sp[:title], "url" => abs(sp[:path]),
      "inLanguage" => "sr-Latn", "about" => { "@id" => STORE_ID }
    }]
  }
  cards = sp[:cards].map { |c| simple_card(*c) }.join("\n                    ")
  text = sp[:text].gsub(/^/, "                ").rstrip
  write sp[:path], head(page) + header(page) + <<~HTML + footer(page)
    <main id="sadrzaj">
#{page_hero("Kategorije", sp[:h1], sp[:lead], crumbs)}
        <section class="page-section">
            <div class="container">
                <p class="section-kicker">Istaknuto</p>
                <h2 class="section-title">#{sp[:heading]}</h2>
                <p class="section-intro">Ponuda se menja tokom godine. Za trenutno stanje i pakovanja pozovite nas na <a href="tel:#{SHOP[:phone]}">#{SHOP[:phone_label]}</a> ili svratite u radnju.</p>
                <div class="content-grid">
                    #{cards}
                </div>
            </div>
        </section>

        <section class="page-section">
            <div class="container text-block">
                <p class="section-kicker">Saveti</p>
#{text}
            </div>
        </section>
    </main>

  HTML
end

# ---------- brendovi.html ----------
crumbs = [["index.html", "Početna"], ["brendovi.html", "Brendovi"]]
page = {
  path: "brendovi.html",
  title: "Brendovi hrane za pse i mačke | Pet Shop Šilja Plus",
  description: "Brendovi hrane za pse i mačke u Pet Shop Šilja Plus, Ralja: Premil, Josera, Farmina N&D i Cibau, Royal Canin, Brit, Monge, Purina, Pet PRO i drugi.",
  schema: [breadcrumb_schema(crumbs)]
}
animal_page = { "pas" => ["sve-za-pse.html", "psi"], "mačka" => ["sve-za-macke.html", "mačke"] }
brand_cards = CATALOG.map { |p| p["brend"] }.uniq.reject { |b| b == "SmartDog" }.map do |brand|
  items = CONFIRMED.select { |p| p["brend"] == brand }
  pending = CATALOG.select { |p| p["brend"] == brand && p["status"] != "potvrđeno" }.map { |p| p["zivotinja"] }.uniq
  list = items.map do |p|
    file, = animal_page[p["zivotinja"]]
    %(<li><a href="./#{file}##{p["id"]}">#{h p["naziv"]}</a></li>)
  end
  pending.each { |a| list << "<li>hrana za #{animal_page[a][1]} — varijante proverite u radnji</li>" }
  %(<article class="feature-card brand-list-card" id="#{slug(brand)}"><h3>#{h brand}</h3><ul>#{list.join}</ul></article>)
end
write "brendovi.html", head(page) + header(page) + <<~HTML + footer(page)
    <main id="sadrzaj">
#{page_hero("Kategorije", "Brendovi hrane za pse i mačke", "Proizvođači hrane za pse i mačke koje držimo u ponudi u Ralji — od domaćih ekonomičnih pakovanja do superpremium hrane.", crumbs)}
        <section class="page-section">
            <div class="container">
                <p class="section-kicker">Partneri</p>
                <h2 class="section-title">Izdvojeni brendovi</h2>
                <div class="brand-grid">
                    <a class="brand-card brand-premil" href="#premil">PREMIL</a>
                    <a class="brand-card brand-josera" href="#josera">Josera</a>
                    <div class="brand-card brand-nekmar">Nekmar</div>
                    <a class="brand-card brand-monge" href="#monge">monge</a>
                    <a class="brand-card brand-farmina" href="#farmina">farmina</a>
                </div>
            </div>
        </section>

        <section class="page-section">
            <div class="container">
                <p class="section-kicker">Ponuda po brendu</p>
                <h2 class="section-title">Šta držimo od kog proizvođača</h2>
                <p class="section-intro">Klik na proizvod vodi do opisa, sastava i pakovanja na stranici za pse ili mačke.</p>
                <div class="feature-grid" style="margin-top: 1.5rem;">
                    #{brand_cards.join("\n                    ")}
                </div>
            </div>
        </section>
    </main>

HTML

# ---------- 404.html ----------
page = {
  path: "404.html", absolute: true, noindex: true,
  title: "Stranica nije pronađena | Pet Shop Šilja Plus",
  description: "Tražena stranica ne postoji. Vratite se na početnu stranicu prodavnice Pet Shop Šilja Plus u Ralji."
}
write "404.html", head(page) + header(page) + <<~HTML + footer(page)
    <main id="sadrzaj">
        <section class="page-section not-found">
            <div class="container text-block" style="margin: 0 auto;">
                <p class="section-kicker">Greška 404</p>
                <h1 class="section-title">Ova stranica ne postoji</h1>
                <p>Možda je adresa pogrešno upisana ili je stranica premeštena. Izaberite gde želite da nastavite:</p>
                <div class="cta-row">
                    <a class="btn btn-primary" style="background: var(--color-primary); color: #fff;" href="#{BASE_URL}">Početna</a>
                    <a class="btn btn-primary" style="background: var(--color-primary); color: #fff;" href="#{BASE_URL}sve-za-pse.html">Sve za pse</a>
                    <a class="btn btn-primary" style="background: var(--color-primary); color: #fff;" href="#{BASE_URL}sve-za-macke.html">Sve za mačke</a>
                </div>
            </div>
        </section>
    </main>

HTML

# ---------- sitemap.xml, robots.txt, site.webmanifest ----------
sitemap_pages = %w[index.html o-nama.html sve-za-pse.html sve-za-macke.html sve-za-ptice.html sve-za-glodare.html akvaristika-teraristika.html brendovi.html]
urls = sitemap_pages.map { |p| "  <url>\n    <loc>#{abs(p)}</loc>\n    <lastmod>#{LASTMOD}</lastmod>\n  </url>" }.join("\n")
write "sitemap.xml", %(<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n#{urls}\n</urlset>\n)
write "robots.txt", "User-agent: *\nAllow: /\n\nSitemap: #{abs("sitemap.xml")}\n"
write "site.webmanifest", JSON.pretty_generate(
  "name" => SHOP[:name], "short_name" => SHOP[:short], "lang" => "sr-Latn", "start_url" => "./", "display" => "browser",
  "background_color" => "#fbfdff", "theme_color" => "#222553",
  "icons" => [
    { "src" => "assets/images/icons/favicon-192.png", "sizes" => "192x192", "type" => "image/png" },
    { "src" => "assets/images/icons/favicon-96.png", "sizes" => "96x96", "type" => "image/png" },
    { "src" => "assets/images/icons/favicon-48.png", "sizes" => "48x48", "type" => "image/png" }
  ]
) + "\n"
puts "Gotovo."
