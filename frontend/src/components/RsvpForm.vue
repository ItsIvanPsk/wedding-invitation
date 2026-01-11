<template>
  <div class="rsvp-container">
    <div v-if="familyStore.family" class="family-name">
      <p>Hola, {{ familyStore.family.name }}. <span>Hemos reservado  <span style="padding: 0.5rem; margin: 0; border-radius: 5px; border: 1px solid gold; color: black" >{{ familyStore.family.guests.length }}</span> lugares.</span></p>
    </div>
    <Form @submit="onSubmit" :validation-schema="schema" style="margin-top: 2rem;">
      <div v-for="guest in familyStore.family?.guests" :key="guest.id" class="guest-card-wrapper" v-scroll-reveal>
        <div class="guest-card" :class="{ 'attending': guest.isAttending }">
            <div class="card-header">
                <div class="header-content">
                    <span class="guest-name">{{ guest.name }}</span>
                    <label class="toggle-attendance">
                        <input type="checkbox" v-model="guest.isAttending">
                        <span class="slider"></span>
                        <span class="label-text">{{ guest.isAttending ? 'Asistiré' : 'No asistiré' }}</span>
                    </label>
                </div>
            </div>

            <div v-if="guest.isAttending" class="card-body">
                
                <!-- Menu Options Grid -->
                <div class="menu-options-grid">
                    <!-- Menu Type -->
                    <div class="option-group">
                        <label class="option-label">Tipo de Menú</label>
                        <div class="segment-control">
                            <label :class="{ active: guest.isAdultMenu }">
                                <input type="radio" :value="true" v-model="guest.isAdultMenu" :name="'menuType-' + guest.id" @change="setMenuType(guest, false)">
                                <span>Adulto</span>
                            </label>
                            <label :class="{ active: guest.isChildMenu }">
                                <input type="radio" :value="true" v-model="guest.isChildMenu" :name="'menuType-' + guest.id" @change="setMenuType(guest, true)">
                                <span>Infantil</span>
                            </label>
                        </div>
                    </div>

                    <!-- Portion Size -->
                    <div class="option-group">
                        <label class="option-label">Ración</label>
                         <div class="segment-control">
                            <label :class="{ active: !guest.isHalfPortion }">
                                <input type="radio" :value="false" v-model="guest.isHalfPortion" name="portion" @change="guest.isHalfPortion = false">
                                <span>Completa</span>
                            </label>
                            <label :class="{ active: guest.isHalfPortion }">
                                <input type="radio" :value="true" v-model="guest.isHalfPortion" name="portion" @change="guest.isHalfPortion = true">
                                <span>Media</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Intolerances -->
                <div class="form-group mt-2">
                    <label class="option-label">Alergias / Intolerancias</label>
                    <div class="custom-dropdown">
                        <div class="dropdown-trigger" @click.stop="toggleDropdown(guest.id)">
                            <span v-if="!guest.selectedIntolerances || guest.selectedIntolerances.length === 0" class="placeholder">Seleccionar...</span>
                            <span v-else class="selection">
                                {{ availableIntolerances.filter(i => guest.selectedIntolerances.includes(i.id)).map(i => i.name).join(', ') }}
                            </span>
                            <span class="arrow">▼</span>
                        </div>
                        
                        <div v-if="openDropdowns[guest.id]" class="dropdown-menu">
                            <div 
                                    v-for="opt in availableIntolerances" 
                                    :key="opt.id" 
                                    class="dropdown-item"
                                    @click="toggleIntolerance(guest, opt)"
                                >
                                <div class="checkbox-circle" :class="{ checked: isSelected(guest, opt.id) }"></div>
                                <span>{{ opt.name }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Observations -->
                <div class="form-group mt-2">
                    <label class="option-label">Observaciones</label>
                    <textarea v-model="guest.observations" class="form-input" rows="2" placeholder="Alguna nota para nosotros..."></textarea>
                </div>

                <!-- Message from Couple -->
                <div v-if="guest.funnyComment" class="message-from-couple">
                    <div class="message-icon">💌</div>
                    <div class="message-content">
                        <strong>Mensaje de los novios:</strong>
                        <p>{{ guest.funnyComment }}</p>
                    </div>
                </div>
            </div>
        </div>
      </div>

      <div class="form-actions">
         <button type="submit" class="btn-submit" :disabled="familyStore.loading">
           {{ familyStore.loading ? 'Enviando...' : 'Confirmar Asistencia' }}
         </button>
      </div>
    </Form>

  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useFamilyStore, type Guest } from '../stores/family'
import { Form, Field, ErrorMessage } from 'vee-validate'
import * as yup from 'yup'

const familyStore = useFamilyStore()
const props = defineProps<{ token: string }>()

interface Intolerance {
  id: number
  name: string
}

const availableIntolerances = ref<Intolerance[]>([])
const openDropdowns = ref<Record<number, boolean>>({}) // guest.id -> boolean

// Load family data if not already loaded (though View handles it mostly)
if (!familyStore.family) {
  familyStore.fetchFamily(props.token)
}

onMounted(async () => {
    document.addEventListener('click', closeAllDropdowns)
    try {
        const res = await fetch('/api/intolerances')
        if (res.ok) {
            availableIntolerances.value = await res.json()
        }
    } catch (e) {
        console.error('Failed to load intolerances', e)
    }
})

onUnmounted(() => {
    document.removeEventListener('click', closeAllDropdowns)
})

const closeAllDropdowns = (e: Event) => {
    // Check if click is inside a dropdown
    const target = e.target as HTMLElement
    if (target.closest('.custom-dropdown')) return
    
    openDropdowns.value = {}
}

const toggleDropdown = (guestId: number) => {
    const current = openDropdowns.value[guestId]
    openDropdowns.value = {} // Close others
    openDropdowns.value[guestId] = !current
}

// Validation Schema
const schema = yup.object().shape({
})

const router = useRouter() // Import useRouter
const onSubmit = async () => {
  await familyStore.confirmAttendance()
  if (!familyStore.error) {
    router.push({ name: 'confirmation-success', params: { token: props.token } })
  }
}

const toggleIntolerance = (guest: Guest, option: Intolerance) => {
    if (!guest.selectedIntolerances) guest.selectedIntolerances = []
    const index = guest.selectedIntolerances.indexOf(option.id)
    
    if (index === -1) {
        guest.selectedIntolerances.push(option.id)
    } else {
        guest.selectedIntolerances.splice(index, 1)
    }
}

const isSelected = (guest: Guest, optionId: number) => {
    return guest.selectedIntolerances?.includes(optionId)
}

const setMenuType = (guest: Guest, isChild: boolean) => {
    guest.isChildMenu = isChild
    guest.isAdultMenu = !isChild
}
</script>

<style scoped>
.guest-card-wrapper {
    margin-bottom: 2rem;
}

.guest-card {
    background: white;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    border: 1px solid rgba(0,0,0,0.05);
    transition: all 0.3s ease;
}

.guest-card.attending {
    border-color: var(--color-accent);
    box-shadow: 0 10px 30px rgba(197, 160, 89, 0.15);
}

.card-header {
    padding: 1.5rem;
    background: #fafafa;
    border-bottom: 1px solid #f0f0f0;
}

.header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.guest-name {
    font-family: var(--font-heading);
    font-size: 1.4rem;
    color: var(--color-text-main);
}

/* Toggle Switch */
.toggle-attendance {
    display: flex;
    align-items: center;
    cursor: pointer;
    position: relative;
    padding-left: 50px;
    user-select: none;
}

.toggle-attendance input {
    display: none;
}

.slider {
    position: absolute;
    left: 0;
    top: 50%;
    transform: translateY(-50%);
    width: 40px;
    height: 22px;
    background-color: #ddd;
    border-radius: 22px;
    transition: .4s;
}

.slider:before {
    position: absolute;
    content: "";
    height: 16px;
    width: 16px;
    left: 3px;
    bottom: 3px;
    background-color: white;
    border-radius: 50%;
    transition: .4s;
}

input:checked + .slider {
    background-color: var(--color-accent);
}

input:checked + .slider:before {
    transform: translateX(18px);
}

.label-text {
    margin-left: 10px;
    font-weight: 500;
    font-size: 0.9rem;
    color: #666;
}

input:checked ~ .label-text {
    color: var(--color-accent);
}

.card-body {
    padding: 2rem;
    background: white;
    animation: slideDown 0.4s ease-out;
}

/* Menu Grid */
.menu-options-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
    margin-bottom: 2rem;
}

@media (max-width: 600px) {
    .menu-options-grid {
        grid-template-columns: 1fr;
    }
}

.option-group {
    display: flex;
    flex-direction: column;
}

.option-label {
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: #888;
    margin-bottom: 0.8rem;
    font-weight: 600;
}

/* Segmented Control */
.segment-control {
    display: flex;
    background: #f5f5f5;
    border-radius: 8px;
    padding: 4px;
}

.segment-control label {
    flex: 1;
    text-align: center;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.9rem;
    color: #666;
    transition: all 0.2s;
    position: relative;
}

.segment-control input {
    display: none;
}

.segment-control label.active {
    background: white;
    color: var(--color-text-main);
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    font-weight: 600;
}


/* Dropdown */
.custom-dropdown {
    position: relative;
}

.dropdown-trigger {
    width: 100%;
    padding: 12px;
    border: 1px solid #eee;
    background: #fafafa;
    border-radius: 8px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    transition: all 0.2s;
}

.dropdown-trigger:hover {
    border-color: #ddd;
    background: white;
}

.placeholder { color: #999; }
.selection { color: var(--color-text-main); font-weight: 500; }

.dropdown-menu {
    position: absolute;
    width: 100%;
    background: white;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    border-radius: 12px;
    bottom: 100%; /* Position above */
    margin-bottom: 8px; /* Space between trigger and menu */
    z-index: 100;
    padding: 8px;
    border: 1px solid #eee;
    max-height: 200px; /* Limit height */
    overflow-y: auto; /* Enable scroll */
}

.dropdown-item {
    padding: 10px;
    border-radius: 6px;
    display: flex;
    align-items: center;
    cursor: pointer;
    transition: background 0.2s;
}

.dropdown-item:hover {
    background: #f9f9f9;
}

.checkbox-circle {
    width: 18px;
    height: 18px;
    border: 2px solid #ddd;
    border-radius: 50%;
    margin-right: 12px;
    transition: all 0.2s;
}

.checkbox-circle.checked {
    border-color: var(--color-accent);
    background: var(--color-accent);
}

.form-input {
    width: 100%;
    padding: 12px;
    border: 1px solid #eee;
    border-radius: 8px;
    background: #fafafa;
    font-family: var(--font-body);
}

.form-input:focus {
    background: white;
    border-color: var(--color-accent);
    outline: none;
}

/* Funny Comment Message */
.message-from-couple {
    margin-top: 2rem;
    padding: 1.5rem;
    background: #fdfaf4;
    border: 1px dashed var(--color-accent);
    border-radius: 12px;
    display: flex;
    gap: 1rem;
}

.message-icon {
    font-size: 1.5rem;
}

.message-content strong {
    display: block;
    color: var(--color-accent);
    margin-bottom: 0.5rem;
    font-family: var(--font-heading);
}

.message-content p {
    font-style: italic;
    color: #666;
    margin: 0;
}

.btn-submit {
    width: 100%;
    padding: 1.2rem;
    background-color: transparent;
    border: 1px solid var(--color-accent);
    color: var(--color-accent);
    font-size: 1.1rem;
    letter-spacing: 1px;
    border-radius: 50px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
}

.btn-submit:hover {
    background-color: var(--color-accent);
    color: white;
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(197, 160, 89, 0.4);
}

.rsvp-container {
    max-width: 800px; /* Wider container */
    margin: 0 auto;
}

</style>
