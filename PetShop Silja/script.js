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

document.addEventListener("click", (event) => {
    dropdowns.forEach((dropdown) => {
        if (!dropdown.contains(event.target)) {
            dropdown.classList.remove("open");
            dropdown.querySelector(".nav-dropdown-toggle")?.setAttribute("aria-expanded", "false");
        }
    });
});

navLinks.forEach((link) => {
    link.addEventListener("click", () => {
        siteHeader?.classList.remove("menu-open");
        navToggle?.setAttribute("aria-expanded", "false");
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
        const firstCard = row.querySelector(".product-card");
        return firstCard ? firstCard.getBoundingClientRect().width + 16 : 260;
    };

    prevButton?.addEventListener("click", () => {
        row.scrollBy({ left: -scrollAmount(), behavior: "smooth" });
    });

    nextButton?.addEventListener("click", () => {
        row.scrollBy({ left: scrollAmount(), behavior: "smooth" });
    });
});
