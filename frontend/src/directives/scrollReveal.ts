import type { DirectiveBinding } from 'vue'

const scrollReveal = {
    mounted: (el: HTMLElement, binding: DirectiveBinding) => {
        // Add base class for styling
        el.classList.add('reveal-on-scroll')

        const options = {
            root: null,
            threshold: 0.15, // Trigger when 15% visible
            rootMargin: "0px" // Can adjust to trigger earlier/later
        }

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    el.classList.add('visible')
                } else {
                    // Remove class to allow re-animating when scrolling back/forth
                    el.classList.remove('visible')
                }
            })
        }, options)

        observer.observe(el)

            // Store observer on element for cleanup
            ; (el as any)._observer = observer
    },
    unmounted: (el: HTMLElement) => {
        if ((el as any)._observer) {
            (el as any)._observer.disconnect()
        }
    }
}

export default scrollReveal
