# encoding: UTF-8
# Unos najniže i najviše cene po brendu (kartice "Kupujte prema brendu").
#
# Pokretanje (iz foldera silja-plus):
#   ruby tools/unesi-cene.rb
#
# Za svaki brend pita najnižu i najvišu cenu u dinarima:
#   Enter      — zadrži postojeću vrednost
#   broj       — nova cena (može 1490, 1.490 ili 1490 RSD)
#   -          — obriši cenu (na kartici piše "Cene u radnji")
# Na kraju upisuje data/brendovi.json i ponovo pravi stranice.

require "json"

Encoding.default_external = Encoding::UTF_8
ROOT = File.expand_path("..", __dir__)
FILE = File.join(ROOT, "data/brendovi.json")

data = JSON.parse(File.read(FILE))

def show(value)
  value.nil? ? "nema" : value.to_s.reverse.scan(/\d{1,3}/).join(".").reverse + " RSD"
end

# Vraća novu cenu, postojeću (Enter) ili nil (-).
def ask(label, current)
  loop do
    print "  #{label} [#{show(current)}]: "
    line = $stdin.gets
    abort "\nPrekinuto — ništa nije sačuvano." if line.nil?
    line = line.strip
    return current if line.empty?
    return nil if line == "-"
    digits = line.sub(/,\d{1,2}\s*(rsd|din)?\.?\s*\z/i, "").gsub(/[^\d]/, "") # "1.490,00" -> 1490
    return digits.to_i unless digits.empty? || digits.to_i.zero?
    puts "  Upiši broj (npr. 1490), Enter za zadržavanje ili - za brisanje."
  end
end

puts "Cene po brendu (Enter = zadrži, - = obriši)\n\n"
data["brendovi"].each do |b|
  puts b["brend"]
  loop do
    min = ask("najniža cena", b["cena_min"])
    max = ask("najviša cena", b["cena_max"])
    if min && max && min > max
      puts "  Najniža cena je veća od najviše — unesi ponovo."
      next
    end
    b["cena_min"], b["cena_max"] = min, max
    break
  end
end

File.write(FILE, JSON.pretty_generate(data) + "\n")
puts "\nSačuvano u data/brendovi.json.\n\n"
system(RbConfig.ruby, File.join(__dir__, "generisi-stranice.rb")) or abort "Pravljenje stranica nije uspelo."
