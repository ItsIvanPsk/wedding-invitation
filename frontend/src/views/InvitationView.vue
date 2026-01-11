<template>
  <EnvelopeOverlay v-if="showEnvelope" @opened="handleEnvelopeOpened" />

  <div v-if="familyStore.loading" class="loading-screen">
    <div class="spinner"></div>
  </div>

  <div v-else-if="familyStore.error" class="error-screen">
    <h1>Lo sentimos</h1>
    <p>{{ familyStore.error }}</p>
  </div>

  <div v-else-if="familyStore.family" class="invitation-container">
    
    <!-- 1. Nos Casamos (Hero) -->
    <section class="hero section">
      <div class="container text-center">
        <h1 class="hero-names">Nerea & Ivan</h1>
        <p class="hero-date">5 de Diciembre de 2026</p>
        <Countdown targetDate="2026-12-05T17:30:00" />
      </div>
    </section>

    <!-- 1.5 Nuestra Historia -->
    <section class="section story-section" v-scroll-reveal>
      <div class="container text-center">
        <h2 class="section-title">Nuestra Historia</h2>
        <p class="story-text">
          Todo comenzó el 5 de diciembre de 2019, con una mirada.
          Siguió con una sonrisa y se convirtió en una aventura inolvidable.
          Después de tantos momentos compartidos, risas y sueños cumplidos,
          queremos dar el siguiente paso rodeados de las personas que más queremos.
        </p>
        <div class="story-gallery">
          <div class="story-photo delay-100">
            <img src="@/assets/we/1.jpg" alt="Nosotros 1" />
          </div>
          <div class="story-photo delay-200">
            <img src="@/assets/we/2.jpg" alt="Nosotros 2" />
          </div>
          <div class="story-photo delay-300">
            <img src="@/assets/we/7.jpg" alt="Nosotros 3" />
          </div>
        </div>
      </div>
    </section>

    <!-- 2. Celebración (Lugar) -->
    <section class="section location-section" v-scroll-reveal>
      <div class="container text-center">
        <h2 class="section-title">Celebración</h2>
        <h3 class="location-name">Hotel El Castell</h3>
        <p class="location-address">Carrer del Castell, 1, Sant Boi de Llobregat</p>

        <div class="map-container">
          <iframe
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2995.3348918484658!2d2.0417461764381244!3d41.34507409861815!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x12a49b8baad582db%3A0x7f17aa4e79451854!2sHotel%20El%20Castell!5e0!3m2!1ses!2ses!4v1767905885528!5m2!1ses!2ses"
            width="100%"
            height="400"
            style="border: 0"
            allowfullscreen="true"
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade"
          />
        </div>
      </div>
    </section>

    <!-- 3. Timeline -->
    <section class="section timeline-section" v-scroll-reveal>
      <h3 class="section-title">Itinerario</h3>
      <Timeline />
    </section>
    
    <!-- 4. Dress Code -->
    <section class="section dress-code-section" v-scroll-reveal>
      <div class="container text-center">
        <h2 class="section-title">Código de Vestimenta</h2>
        <div class="dress-code-content">
          <p class="dress-code-main">Formal, pero sé tú mismo</p>
          <p class="dress-code-note">
            Recordad que es Diciembre y estaremos al aire libre durante la ceremonia y el cóctel.
            ¡Venid bien abrigados!
            <br>
            (Si el clima no acompaña, tenemos un cálido Plan B interior)
          </p>
          <div class="dress-code-divider"></div>
        </div>
      </div>
    </section>

    <!-- 5. RSVP -->
    <section class="section rsvp-section" v-scroll-reveal>
      <div class="container">
        <h2 class="section-title text-center">Confirmación de Asistencia</h2>
        <p class="text-center mb-2">Por favor, confirma antes del <strong>1 de Noviembre de 2026</strong></p>
        <RsvpForm :token="route.params.token as string" />
      </div>
    </section>

    <footer class="site-footer">
      <div class="footer-content">
        <h3>¿Tienes dudas?</h3>
        <p>Si tienes alguna pregunta, no dudes en contactarnos.</p>
        <a href="https://wa.me/34665528630" target="_blank" class="contact-btn"
          >Contactar por WhatsApp</a
        >
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useFamilyStore } from '../stores/family'
import RsvpForm from '../components/RsvpForm.vue'
import Countdown from '../components/Countdown.vue'
import Timeline from '../components/Timeline.vue'
import EnvelopeOverlay from '../components/EnvelopeOverlay.vue'
import musicUrl from '@/assets/music.mp3'

console.log("🚀 InvitationView: Script Setup iniciado")
console.log("🎵 URL Musica:", musicUrl)

const route = useRoute()
const familyStore = useFamilyStore()
const showEnvelope = ref(true)

// Create audio instance globally in component
const audio = new Audio(musicUrl)
audio.volume = 0.5
audio.playbackRate = 1.5
audio.loop = true

// Debug loading events
audio.addEventListener('loadstart', () => console.log("🎧 Audio: Cargando..."))
audio.addEventListener('canplay', () => console.log("🎧 Audio: Listo para reproducir (canplay)"))
audio.addEventListener('error', (e) => console.error("🎧 Audio: Error de carga", e))

const handleEnvelopeOpened = () => {
  showEnvelope.value = false
  document.body.classList.remove('no-scroll')
}

const playMusic = () => {
  console.log("🎵 Intentando reproducir música...")
  
  const unlockAudio = () => {
    console.log("👆 Interacción detectada. Reintentando...")
    audio.play()
      .then(() => {
        console.log("✅ Música iniciada por interacción")
        document.removeEventListener('click', unlockAudio)
        document.removeEventListener('touchstart', unlockAudio)
      })
      .catch(err => console.error("❌ Fallo tras interacción", err))
  }

  audio.play()
    .then(() => console.log("✅ Música reproduciéndose (Autoplay exitoso)"))
    .catch((e) => {
      console.warn("⚠️ Autoplay bloqueado o pendiente. Esperando clic...", e)
      document.addEventListener('click', unlockAudio)
      document.addEventListener('touchstart', unlockAudio)
    })
}

onMounted(() => {
  console.log("🏁 InvitationView: onMounted ejecutado")
  document.body.classList.add('no-scroll')
  playMusic()
  const token = route.params.token as string
  if (token) {
    familyStore.fetchFamily(token)
  }
})
</script>

<style scoped>
.hero {
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  padding-top: 25vh;
  background: linear-gradient(rgba(44, 62, 80, 0.4), rgba(44, 62, 80, 0.4)), url('@/assets/hero.jpg');
  background-size: cover;
  background-position: center;
  color: white;
  text-align: center;
}

.hero-names {
  font-family: var(--font-heading);
  font-size: 5rem;
  margin-bottom: 1rem;
  color: white;
  text-shadow: 0 4px 10px rgba(0,0,0,0.2);
}

.hero-date {
  font-size: 1.5rem;
  font-weight: 300;
  letter-spacing: 2px;
  margin-bottom: 3rem;
  border-top: 1px solid white;
  border-bottom: 1px solid white;
  display: inline-block;
  padding: 0.5rem 2rem;
}

/* Timeline specific overrides or additions */
.timeline-section {
  background-color: white;
}

.location-section h3.location-name {
  font-family: var(--font-heading);
  font-size: 2.25rem;
  margin-bottom: 0.5rem;
  color: var(--color-accent);
}

.location-address {
  font-size: 1.1rem;
  opacity: 0.8;
  margin-bottom: 2rem;
}

.location-description {
  max-width: 600px;
  margin: 0 auto 2rem auto;
  font-size: 1.1rem;
  line-height: 1.6;
}

.map-container {
  margin-top: 2rem;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-card);
  border: 4px solid white;
}

/* Story Section */
.story-text {
  max-width: 700px;
  margin: 0 auto 3rem auto;
  font-size: 1.2rem;
  line-height: 1.8;
  color: var(--color-text-light);
}

.story-gallery {
  display: flex;
  flex-direction: row;
  justify-content: center;
  gap: 1.5rem;
  margin-top: 2rem;
}

.story-photo {
  flex: 1;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-card);
  height: 250px;
  transition: transform 0.3s ease;
}

.story-photo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.8s ease;
}

.story-photo:hover {
  transform: translateY(-5px);
}

.story-photo:hover img {
  transform: scale(1.1);
}

@media (max-width: 768px) {
  .story-gallery {
    flex-direction: column;
  }
  .story-photo {
    height: 300px;
  }
}

/* Photo Collage Styles */
.collage-section {
  padding: 4rem 1rem;
  background-color: var(--color-bg-light);
}

.collage-grid {
  max-width: 1000px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1.5fr 1fr;
  grid-template-rows: repeat(2, 300px);
  gap: 1.5rem;
}

.collage-item {
  overflow: hidden;
  border-radius: 16px;
  box-shadow: var(--shadow-card);
  transition: transform 0.5s ease;
}

.collage-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.8s ease;
}

.collage-item:hover img {
  transform: scale(1.05);
}

.collage-item.large {
  grid-row: span 2;
}

/* Mobile responsive collage */
@media (max-width: 768px) {
  .collage-grid {
    grid-template-columns: 1fr;
    grid-template-rows: auto;
    height: auto;
  }
  
  .collage-item {
    height: 350px;
  }
  
  .collage-item.large {
    grid-row: auto;
  }
}

/* Footer layout */
.site-footer {
  background-color: var(--color-text-main);
  color: var(--color-bg-light);
  padding: 4rem 2rem;
  text-align: center;
}

.contact-btn {
  display: inline-block;
  margin-top: 1.5rem;
  padding: 1rem 2rem;
  background-color: transparent;
  border: 1px solid var(--color-accent);
  color: var(--color-accent);
  text-decoration: none;
  border-radius: 50px;
  font-weight: 500;
  letter-spacing: 1px;
  transition: all 0.3s ease;
}

.contact-btn:hover {
  background-color: var(--color-accent);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(197, 160, 89, 0.4);
}

/* Dress Code Styles */
.dress-code-section {
  background-color: white;
}

.dress-code-content {
  margin-top: 2rem;
  padding: 2rem;
  background-color: var(--color-bg-light);
  border-radius: 20px;
  box-shadow: var(--shadow-card);
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

.dress-code-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.dress-code-main {
  font-family: var(--font-heading);
  font-size: 2.5rem;
  color: var(--color-text-main);
  margin-bottom: 0.5rem;
}

.dress-code-note {
  font-size: 1.1rem;
  color: var(--color-text-light);
  margin-bottom: 2rem;
  line-height: 1.6;
}

.dress-code-divider {
  width: 50px;
  height: 2px;
  background-color: var(--color-accent);
  margin: 0 auto;
}

/* NSFW Section adjustments */
.rsvp-section {
  background-color: var(--color-bg-light);
  padding-bottom: 6rem;
}

.mb-2 {
  margin-bottom: 2rem;
  color: var(--color-text-light);
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .hero-names {
    font-size: 3rem;
  }
  .dress-code-main {
    font-size: 2rem;
  }
}
</style>
