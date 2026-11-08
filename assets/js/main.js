const siteHeader = document.querySelector(".site-header");
const navToggle = document.querySelector(".nav-toggle");
const navLinks = document.querySelectorAll(".site-nav a");
const dropdowns = document.querySelectorAll(".nav-dropdown");
const carouselRows = document.querySelectorAll("[data-carousel]");

if (navToggle && siteHeader) {
    navToggle.addEventListener("click", () => {
        const isOpen = siteHeader.classList.toggle("menu-open");
        navToggle.setAttribute("aria-expanded", String(isOpen));
    });
}

dropdowns.forEach((dropdown) => {
    const toggle = dropdown.querySelector(".nav-dropdown-toggle");

    toggle?.addEventListener("click", (event) => {
        if (window.innerWidth > 820) {
            event.preventDefault();
        }

        const isOpen = dropdown.classList.toggle("open");
        toggle.setAttribute("aria-expanded", String(isOpen));

        dropdowns.forEach((otherDropdown) => {
            if (otherDropdown !== dropdown) {
                otherDropdown.classList.remove("open");
                otherDropdown.querySelector(".nav-dropdown-toggle")?.setAttribute("aria-expanded", "false");
            }
        });
    });
});

const closeMenu = () => {
    siteHeader?.classList.remove("menu-open");
    navToggle?.setAttribute("aria-expanded", "false");
};

document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && siteHeader?.classList.contains("menu-open")) {
        closeMenu();
        navToggle?.focus();
    }
});

document.addEventListener("click", (event) => {
    // Dodir van zaglavlja zatvara otvoreni meni na telefonu
    if (siteHeader && !siteHeader.contains(event.target)) {
        closeMenu();
    }

    dropdowns.forEach((dropdown) => {
        if (!dropdown.contains(event.target)) {
            dropdown.classList.remove("open");
            dropdown.querySelector(".nav-dropdown-toggle")?.setAttribute("aria-expanded", "false");
        }
    });
});

navLinks.forEach((link) => {
    link.addEventListener("click", () => {
        closeMenu();
        dropdowns.forEach((dropdown) => {
            dropdown.classList.remove("open");
            dropdown.querySelector(".nav-dropdown-toggle")?.setAttribute("aria-expanded", "false");
        });
    });
});

carouselRows.forEach((row) => {
    const parent = row.closest(".carousel-shell");
    const prevButton = parent?.querySelector("[data-carousel-prev]");
    const nextButton = parent?.querySelector("[data-carousel-next]");

    const scrollAmount = () => {
        const firstCard = row.firstElementChild;
        return firstCard ? firstCard.getBoundingClientRect().width + 16 : 260;
    };

    prevButton?.addEventListener("click", () => {
        row.scrollBy({ left: -scrollAmount(), behavior: "smooth" });
    });

    nextButton?.addEventListener("click", () => {
        row.scrollBy({ left: scrollAmount(), behavior: "smooth" });
    });

    // Traka napretka (ako postoji) i strelice se sakrivaju kad ceo red staje na ekran
    const progress = parent?.querySelector(".carousel-progress");
    if (!progress) {
        return;
    }

    const updateProgress = () => {
        const maxScroll = row.scrollWidth - row.clientWidth;
        const scrollable = maxScroll > 1;

        progress.hidden = !scrollable;
        if (prevButton) prevButton.hidden = !scrollable;
        if (nextButton) nextButton.hidden = !scrollable;
        if (!scrollable) {
            return;
        }

        const size = row.clientWidth / row.scrollWidth;
        const ratio = Math.min(Math.max(row.scrollLeft / maxScroll, 0), 1);
        progress.style.setProperty("--progress-size", `${size * 100}%`);
        progress.style.setProperty("--progress-offset", `${ratio * (1 / size - 1) * 100}%`);
    };

    row.addEventListener("scroll", updateProgress, { passive: true });
    window.addEventListener("resize", updateProgress);
    updateProgress();
});
