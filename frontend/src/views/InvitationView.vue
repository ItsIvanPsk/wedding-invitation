<template>
  <EnvelopeOverlay v-if="showEnvelope" @opened="handleEnvelopeOpened" />

  <div v-if="familyStore.loading" class="loading-screen">
    <div class="spinner"></div>
  </div>

  <div v-else-if="familyStore.error" class="error-screen">
    <div class="error-overlay"></div>
    <div class="error-card" v-scroll-reveal>
      <div class="error-icon">
        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M12 17V19" stroke="var(--color-accent)" stroke-width="2" stroke-linecap="round"/>
          <path d="M12 11V13" stroke="var(--color-accent)" stroke-width="2" stroke-linecap="round"/>
          <path d="M19 11H5C3.89543 11 3 11.8954 3 13V19C3 20.1046 3.89543 21 5 21H19C20.1046 21 21 20.1046 21 19V13C21 11.8954 20.1046 11 19 11Z" stroke="var(--color-accent)" stroke-width="1.5"/>
          <path d="M7 11V7C7 4.23858 9.23858 2 12 2C14.7614 2 17 4.23858 17 7V11" stroke="var(--color-accent)" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
      </div>
      <h1 class="error-title">Acceso Restringido</h1>
      <p class="error-message">{{ familyStore.error }}</p>
      <div class="error-divider"></div>
      <p class="error-hint">¿Crees que hay un error? Contacta con nosotros:</p>
      <a href="https://wa.me/34665528630" target="_blank" class="contact-btn error-btn">
        Contactar por WhatsApp
      </a>
    </div>
  </div>

  <template v-else>
    <div class="invitation-container">
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
            Desde aquel 5 de diciembre de 2019, nuestras vidas tomaron un giro inolvidable. Aquella primera mirada dio paso a una sonrisa, luego a una historia compartida y, finalmente, a un amor que nos impulsó a soñar juntos.
            <br><br>
            Después de años de complicidad, risas y momentos que atesoraremos para siempre, hemos decidido dar el siguiente paso. Queremos unir nuestras vidas rodeados de las personas que más queremos y a quienes agradecemos infinitamente por acompañarnos en cada etapa de nuestro viaje.
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

      <!-- Photo 2 Transition -->
      <section class="section photo-transition-section" v-scroll-reveal>
        <div class="container">
          <div class="transition-photo-wrapper">
            <img src="@/assets/2.jpg" alt="Nosotros" class="transition-photo photo-above-itinerary" />
          </div>
        </div>
      </section>

      <!-- 3. Timeline -->
      <section class="section timeline-section" v-scroll-reveal>
        <h3 class="section-title">Itinerario</h3>
        <Timeline />
      </section>
      
      <!-- Photo 7 Transition -->
      <section class="section photo-transition-section" v-scroll-reveal>
        <div class="container">
          <div class="transition-photo-wrapper">
            <img src="@/assets/4.jpg" alt="Nosotros" class="transition-photo" />
          </div>
        </div>
      </section>

      <!-- 4. Dress Code -->
      <section class="section dress-code-section" v-scroll-reveal>
        <div class="container text-center">
          <h2 class="section-title">Código de Vestimenta</h2>
          
          <div class="dress-code-icon-container">
            <svg width="80" height="80" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="dress-code-svg">
              <!-- Traje (Hombre) -->
              <path d="M7 4L10 9L7 14H4L1 9L4 4H7Z" fill="var(--color-accent)" fill-opacity="0.2"/>
              <path d="M4 4H7L10 9L7 14H4L1 9L4 4Z" stroke="var(--color-accent)" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M5.5 4V14" stroke="var(--color-accent)" stroke-width="1"/>
              <path d="M4 4L5.5 7L7 4" stroke="var(--color-accent)" stroke-width="1"/>
              
              <!-- Vestido (Mujer) -->
              <path d="M17 4L20 8L23 20H11L14 8L17 4Z" fill="var(--color-accent)" fill-opacity="0.2"/>
              <path d="M17 4L20 8L23 20H11L14 8L17 4Z" stroke="var(--color-accent)" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M14 8C15.5 8 18.5 8 20 8" stroke="var(--color-accent)" stroke-width="1"/>
            </svg>
          </div>

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

      <!-- Photo 1 Transition -->
      <section class="section photo-transition-section" v-scroll-reveal>
        <div class="container">
          <div class="transition-photo-wrapper">
            <img src="@/assets/3.jpg" alt="Nosotros" class="transition-photo" />
          </div>
        </div>
      </section>

      <!-- 5. RSVP (Conditional only if family loaded) -->
      <section v-if="familyStore.family" class="section rsvp-section" v-scroll-reveal>
        <div class="container">
          <h2 class="section-title text-center">Confirmación de Asistencia</h2>
          <p class="text-center mb-2">Por favor, confirma antes del <strong>1 de Noviembre de 2026</strong></p>
          <RsvpForm :token="route.params.token as string" />
        </div>
      </section>
    </div>

    <footer class="site-footer">
      <div class="footer-content">
        <h3>¿Tienes dudas?</h3>
        <p>Si tienes alguna pregunta, no dudes en contactarnos.</p>
        <a href="https://wa.me/34665528630" target="_blank" class="contact-btn">
          Contactar por WhatsApp
        </a>
      </div>
    </footer>
  </template>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'
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
const showEnvelope = ref(false)

const globalWindow = window as any
if (!globalWindow.__weddingAudio) {
  globalWindow.__weddingAudio = new Audio(musicUrl)
  globalWindow.__weddingAudio.volume = 0.5
  globalWindow.__weddingAudio.playbackRate = 1.5
  globalWindow.__weddingAudio.loop = true

  // Debug loading events
  globalWindow.__weddingAudio.addEventListener('loadstart', () => console.log("🎧 Audio: Cargando..."))
  globalWindow.__weddingAudio.addEventListener('canplay', () => console.log("🎧 Audio: Listo para reproducir (canplay)"))
  globalWindow.__weddingAudio.addEventListener('error', (e: any) => console.error("🎧 Audio: Error de carga", e))
} else {
  // Stop previous play if it was already playing
  globalWindow.__weddingAudio.pause()
  globalWindow.__weddingAudio.currentTime = 0
}

const audio = globalWindow.__weddingAudio

const handleEnvelopeOpened = () => {
  console.log("📨 InvitationView: handleEnvelopeOpened called")
  showEnvelope.value = false
  document.body.classList.remove('no-scroll')
}

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

const playMusic = () => {
  console.log("🎵 Intentando reproducir música...")
  
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
  
  const token = route.params.token as string
  console.log("🎟️ InvitationView: Token detectado:", token)
  
  if (token) {
    document.body.classList.add('no-scroll')
    showEnvelope.value = true
    playMusic()
    familyStore.fetchFamily(token)
  } else {
    console.warn("🎟️ InvitationView: No se encontró token en la URL")
    familyStore.error = "Para acceder a tu invitación, por favor utiliza el enlace personalizado que te hemos enviado. Si tienes problemas, contacta con los novios."
    showEnvelope.value = false
  }
})

onBeforeUnmount(() => {
  console.log("🛑 InvitationView: Deteniendo música antes de desmontar")
  audio.pause()
  audio.currentTime = 0
  document.removeEventListener('click', unlockAudio)
  document.removeEventListener('touchstart', unlockAudio)
})
</script>

<style scoped>
.hero {
  height: 90vh; /* Better for mobile to see there is content below */
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)), url('@/assets/hero.jpg');
  background-size: cover;
  background-position: center;
  color: white;
  text-align: center;
}

.hero-names {
  font-family: var(--font-heading);
  font-size: clamp(3rem, 15vw, 6rem);
  margin-bottom: 0.5rem;
  color: white;
  text-shadow: 0 4px 10px rgba(0,0,0,0.3);
  line-height: 1.1;
}

.hero-date {
  font-size: clamp(1rem, 4vw, 1.5rem);
  font-weight: 300;
  letter-spacing: 2px;
  margin-bottom: 2rem;
  border-top: 1px solid rgba(255,255,255,0.5);
  border-bottom: 1px solid rgba(255,255,255,0.5);
  display: inline-block;
  padding: 0.5rem 1.5rem;
}

@media (max-width: 640px) {
  .hero {
    height: 85vh;
  }
}

/* Timeline specific overrides or additions */
.timeline-section {
  background-color: transparent;
  padding-left: 1rem;
  padding-right: 1rem;
}

.location-section h3.location-name {
  font-family: var(--font-heading);
  font-size: clamp(1.75rem, 8vw, 2.5rem);
  margin-bottom: 0.5rem;
  color: var(--color-accent);
}

.location-address {
  font-size: 1rem;
  opacity: 0.8;
  margin-bottom: 1.5rem;
  padding: 0 1rem;
}

.map-container {
  margin-top: 1.5rem;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-card);
  border: 4px solid white;
}

/* Story Section */
.story-text {
  max-width: 700px;
  margin: 0 auto 2rem auto;
  font-size: 1.1rem;
  line-height: 1.8;
  color: var(--color-text-light);
  text-align: center;
  padding: 2.5rem 2rem;
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 16px;
  box-shadow: var(--shadow-card);
  border: 1px solid rgba(255, 255, 255, 0.4);
}

.story-gallery {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
  margin-top: 2rem;
}

.story-photo {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: var(--shadow-card);
  height: 200px;
}

.story-photo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.8s ease;
}

.story-photo:hover img {
  transform: scale(1.05);
}

@media (max-width: 768px) {
  .story-gallery {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  .story-photo {
    height: 350px;
  }
}

/* Photo Transition Styles */
.transition-photo-wrapper {
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
  height: 500px;
  border-radius: 24px;
  overflow: hidden;
  box-shadow: var(--shadow-card);
  border: 8px solid white;
}

.transition-photo {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 1.2s ease;
}

.photo-above-itinerary {
  object-position: 40% center;
}

.transition-photo-wrapper:hover .transition-photo {
  transform: scale(1.05);
}

@media (max-width: 768px) {
  .transition-photo-wrapper {
    height: 400px;
    border-radius: 16px;
    border-width: 4px;
  }
}

/* Dress Code Styles */
.dress-code-main {
  font-family: var(--font-heading);
  font-size: clamp(1.75rem, 8vw, 3rem);
  color: var(--color-text-main);
  margin-bottom: 0.5rem;
}

.dress-code-content {
  margin-top: 1.5rem;
  padding: 1.5rem;
  background-color: var(--color-bg-light);
  border-radius: 20px;
  box-shadow: var(--shadow-card);
  max-width: 600px;
  margin-left: 1rem;
  margin-right: 1rem;
}

@media (min-width: 768px) {
  .dress-code-content {
    margin-left: auto;
    margin-right: auto;
    padding: 2.5rem;
  }
}

/* RSVP Section */
.rsvp-section {
  padding: 2rem 1rem 6rem 1rem;
}

/* Error Screen Styles */
.error-screen {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 2rem;
  background: var(--color-bg-light);
}

.error-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url('@/assets/hero.jpg');
  background-size: cover;
  background-position: center;
  filter: blur(10px) brightness(0.6);
  opacity: 0.3;
}

.error-card {
  position: relative;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  padding: 3rem 2rem;
  border-radius: 24px;
  max-width: 500px;
  width: 100%;
  text-align: center;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.error-icon {
  margin-bottom: 1.5rem;
  display: flex;
  justify-content: center;
  animation: float 3s ease-in-out infinite;
}

.error-title {
  font-family: var(--font-heading);
  font-size: 2.5rem;
  color: var(--color-text-main);
  margin-bottom: 1rem;
}

.error-message {
  font-size: 1.1rem;
  color: var(--color-text-light);
  line-height: 1.6;
  margin-bottom: 2rem;
}

.error-divider {
  width: 60px;
  height: 2px;
  background: var(--color-accent);
  margin: 0 auto 2rem auto;
  opacity: 0.5;
}

.error-hint {
  font-size: 0.9rem;
  color: var(--color-text-light);
  margin-bottom: 1rem;
  font-style: italic;
}

.error-btn {
  width: 100%;
  margin-top: 0.5rem !important;
}

@keyframes float {
  0% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
  100% { transform: translateY(0px); }
}

@media (max-width: 480px) {
  .error-card {
    padding: 2.5rem 1.5rem;
  }
  .error-title {
    font-size: 2rem;
  }
}

/* Footer layout */
.site-footer {
  background-color: var(--color-text-main);
  color: var(--color-bg-light);
  padding: 4rem 2rem;
  text-align: center;
}

.site-footer h3 {
  color: white;
  margin-bottom: 0.5rem;
}

.site-footer p {
  opacity: 0.8;
  margin-bottom: 1.5rem;
}

.contact-btn {
  display: inline-block;
  padding: 1rem 2rem;
  background-color: var(--color-accent);
  border: 1px solid var(--color-accent);
  color: white;
  text-decoration: none;
  border-radius: 50px;
  font-weight: 500;
  letter-spacing: 1px;
  transition: all 0.4s ease;
}

.contact-btn:hover {
  background-color: var(--color-accent-dark);
  color: white;
  transform: translateY(-3px);
  box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.2), 0 8px 20px rgba(128, 0, 32, 0.4);
  border-color: rgba(255, 255, 255, 0.5);
}
</style>
