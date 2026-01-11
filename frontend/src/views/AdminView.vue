<script setup lang="ts">
import { ref, onMounted } from 'vue'

interface Guest {
  name: string
  isAttending: boolean
}

interface Family {
  id: string
  name: string
  token: string
  guests: Guest[]
}

const families = ref<Family[]>([])
const loading = ref(false)

// New Family Form
const newFamilyName = ref('')
const newGuestNames = ref('') // Comma separated

async function fetchFamilies() {
  loading.value = true
  try {
    const res = await fetch('/api/families')
    if (res.ok) {
      families.value = await res.json()
    }
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

async function createFamily() {
  if (!newFamilyName.value) return
  
  const guests = newGuestNames.value.split(',').map(s => s.trim()).filter(Boolean)
  
  try {
    const res = await fetch('/api/families', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        name: newFamilyName.value,
        guestNames: guests
      })
    })
    
    if (res.ok) {
      newFamilyName.value = ''
      newGuestNames.value = ''
      await fetchFamilies()
    }
  } catch (e) {
    console.error(e)
  }
}

function copyLink(token: string) {
  const url = `${window.location.origin}/confirmacion/${token}`
  navigator.clipboard.writeText(url)
  alert('Enlace copiado: ' + url)
}

onMounted(fetchFamilies)
</script>

<template>
  <div class="container section">
    <h1>Panel de Administración</h1>

    <div class="card mt-4">
      <h2>Nueva Familia</h2>
      <div class="form-row">
        <input v-model="newFamilyName" placeholder="Nombre Familia (ej: Familia Pérez)" class="input" />
        <input v-model="newGuestNames" placeholder="Invitados (separados por coma)" class="input" />
        <button @click="createFamily" class="btn btn-primary">Crear</button>
      </div>
    </div>

    <div class="card mt-4">
      <h2>Familias Invitadas</h2>
      <div v-if="loading">Cargando...</div>
      <table v-else class="table">
        <thead>
          <tr>
            <th>Familia</th>
            <th>Invitados</th>
            <th>Token</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="family in families" :key="family.id">
            <td>{{ family.name }}</td>
            <td>
              <span v-for="(g, index) in family.guests" :key="g.name" :class="{ 'confirmed': g.isAttending }">
                {{ g.name }}<span v-if="index < family.guests.length - 1"> | </span>
              </span>
            </td>
            <td><code>{{ family.token }}</code></td>
            <td class="action-buttons">
              <button @click="copyLink(family.token)" class="btn btn-outline btn-sm">Copiar Link</button>
              <a :href="`/confirmacion/${family.token}`" target="_blank" class="btn btn-primary btn-sm ml-2">Ir a Invitación</a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.card {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: var(--shadow-card);
}

.table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 1rem;
}

.table th, .table td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.input {
  padding: 0.5rem;
  margin-right: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.confirmed {
  color: green;
  font-weight: bold;
}

.btn-sm {
  padding: 0.25rem 0.5rem;
  font-size: 0.75rem;
}
</style>
