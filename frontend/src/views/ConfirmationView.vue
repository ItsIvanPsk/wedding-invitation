<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { useFamilyStore } from '../stores/family'

const route = useRoute()
const familyStore = useFamilyStore()
const token = route.params.token as string

interface Intolerance {
  id: number
  name: string
}
const availableIntolerances = ref<Intolerance[]>([])

onMounted(async () => {
  if (!familyStore.family && token) {
    familyStore.fetchFamily(token)
  }
  // Fetch intolerances for display
  try {
    const res = await fetch('/api/intolerances')
    if (res.ok) {
      availableIntolerances.value = await res.json()
    }
  } catch (e) {
    console.error('Failed to load intolerances', e)
  }
  
  // Scroll to top
  window.scrollTo(0, 0)
})

const getIntoleranceNames = (ids: number[]) => {
  if (!ids || !ids.length) return ''
  return availableIntolerances.value
    .filter(i => ids.includes(i.id))
    .map(i => i.name)
    .join(', ')
}

const whatsappUrl = "https://wa.me/34665528630"
</script>

<template>
  <div class="confirmation-page">
    <div v-if="familyStore.loading" class="loading-screen">
      <div class="spinner"></div>
    </div>

    <div v-else-if="familyStore.family" class="container">
      <div class="success-card" v-scroll-reveal>
        <div class="check-icon">✨</div>
        <h1>¡Confirmación Recibida!</h1>
        <p class="subtitle">Gracias por ayudarnos a organizarlo todo.</p>

        <div class="summary-list">
          <div v-for="guest in familyStore.family.guests" :key="guest.id" class="guest-summary">
             <div class="guest-header">
               <span class="guest-name">{{ guest.name }}</span>
               <span class="status-badge" :class="guest.isAttending ? 'attending' : 'not-attending'">
                 {{ guest.isAttending ? 'Asistirá' : 'No asistirá' }}
               </span>
             </div>
             
             <div v-if="guest.isAttending" class="guest-details">
               <div class="detail-row">
                 <span>Menú:</span>
                 <strong>{{ guest.isChildMenu ? 'Infantil' : 'Adulto' }}</strong>
               </div>
               <div v-if="guest.isHalfPortion" class="detail-row">
                 <span>Ración:</span>
                 <strong>Media</strong>
               </div>
               <div v-if="guest.selectedIntolerances && guest.selectedIntolerances.length" class="detail-row alert">
                 <span>Alergias:</span>
                 <strong>{{ getIntoleranceNames(guest.selectedIntolerances) }}</strong>
               </div>
             </div>
          </div>
        </div>

        <div class="contact-section">
          <p>
            Si necesitas realizar algún cambio o tienes alguna duda, 
            por favor contáctanos directamente.
          </p>
          <a :href="whatsappUrl" target="_blank" class="whatsapp-btn">
            Contactar por WhatsApp
          </a>
        </div>
        
        <RouterLink :to="`/confirmacion/${token}`" class="back-link">
          Volver a la invitación
        </RouterLink>
      </div>
    </div>
  </div>
</template>

<style scoped>
.confirmation-page {
  min-height: 100vh;
  background: var(--color-bg-light);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.container {
  max-width: 600px;
  width: 100%;
}

.success-card {
  background: white;
  padding: 3rem;
  border-radius: 20px;
  box-shadow: var(--shadow-card);
  text-align: center;
  border: 1px solid rgba(0,0,0,0.05);
}

.check-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

h1 {
  font-family: var(--font-heading);
  font-size: 3rem;
  color: var(--color-text-main);
  margin-bottom: 0.5rem;
}

.subtitle {
  color: var(--color-text-light);
  margin-bottom: 3rem;
  font-size: 1.1rem;
}

.summary-list {
  text-align: left;
  margin-bottom: 3rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.guest-summary {
  background: #fdfaf4; /* Slight tint matching theme */
  padding: 1.5rem;
  border-radius: 12px;
  border: 1px solid #eee;
}

.guest-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.guest-name {
  font-family: var(--font-heading);
  font-size: 1.5rem;
  color: var(--color-text-main);
}

.status-badge {
  padding: 0.3rem 0.8rem;
  border-radius: 50px;
  font-size: 0.8rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.status-badge.attending {
  background: #e8f5e9;
  color: #2e7d32;
}

.status-badge.not-attending {
  background: #ffebee;
  color: #c62828;
}

.guest-details {
  border-top: 1px solid rgba(0,0,0,0.05);
  padding-top: 0.8rem;
  margin-top: 0.5rem;
  font-size: 0.95rem;
  color: #666;
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}

.detail-row {
  display: flex;
  justify-content: space-between;
}

.detail-row.alert {
  color: #d32f2f;
}

.contact-section {
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 1px solid #eee;
}

.contact-section p {
  color: var(--color-text-light);
  margin-bottom: 1.5rem;
  line-height: 1.6;
}

.whatsapp-btn {
  display: inline-block;
  padding: 1rem 2rem;
  background-color: transparent;
  border: 1px solid var(--color-accent);
  color: var(--color-accent);
  text-decoration: none;
  border-radius: 50px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.whatsapp-btn:hover {
  background-color: var(--color-accent);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(197, 160, 89, 0.4);
}

.back-link {
  display: block;
  margin-top: 2rem;
  color: #999;
  text-decoration: none;
  font-size: 0.9rem;
}

.back-link:hover {
  text-decoration: underline;
}

@media (max-width: 600px) {
  .success-card {
    padding: 1.5rem;
  }
}
</style>
