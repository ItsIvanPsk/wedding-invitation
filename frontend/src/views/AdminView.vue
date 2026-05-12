<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

interface Guest {
  id: number
  name: string
  isAttending: boolean
  isChildMenu: boolean
  isHalfPortion: boolean
  intolerances: string | null
  observations: string | null
  funnyComment: string | null
}

interface Family {
  id: string
  name: string
  token: string
  confirmationDate: string | null
  guests: Guest[]
}

const families = ref<Family[]>([])
const loading = ref(false)
const selectedFamily = ref<Family | null>(null)
const showModal = ref(false)

// New Family Form
const newFamilyName = ref('')
const newGuestNames = ref('') // Comma separated

const getHeaders = () => ({
  'Content-Type': 'application/json',
  'X-Admin-User': sessionStorage.getItem('admin_user') || '',
  'X-Admin-Password': sessionStorage.getItem('admin_password') || ''
})

async function fetchFamilies() {
  loading.value = true
  try {
    const res = await fetch('/api/families', {
      headers: getHeaders()
    })
    
    if (res.status === 401) {
      sessionStorage.removeItem('admin_password')
      router.push('/login')
      return
    }

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
      headers: getHeaders(),
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
  alert('Enlace copiado al portapapeles')
}

function openLink(token: string) {
  const url = `${window.location.origin}/confirmacion/${token}`
  window.open(url, '_blank')
}

function viewDetails(family: Family) {
  selectedFamily.value = family
  showModal.value = true
}

async function saveComment(guest: Guest) {
    try {
        const res = await fetch(`/api/families/guests/${guest.id}`, {
            method: 'PATCH',
            headers: getHeaders(),
            body: JSON.stringify({
                funnyComment: guest.funnyComment
            })
        })
        
        if (res.ok) {
            alert('¡Comentario guardado!')
        } else {
            alert('Error al guardar el comentario')
        }
    } catch (e) {
        console.error(e)
        alert('Error de conexión')
    }
}

const isCeliacOnlyGuest = (name: string) => {
  if (!name) return false
  const normalized = name.toLowerCase().trim()
  return normalized === 'javi' || normalized === 'nil'
}

onMounted(fetchFamilies)
</script>

<template>
  <div class="container section">
    <h1>Panel de Administración</h1>

    <div class="card mt-4">
      <h2>Nueva Familia</h2>
      <div class="form-row">
        <input v-model="newFamilyName" placeholder="Nombre Familia (ej: Familia Pérez)" class="input flex-1" />
        <input v-model="newGuestNames" placeholder="Invitados (separados por coma)" class="input flex-1" />
        <button @click="createFamily" class="btn btn-primary">Crear Familia</button>
      </div>
    </div>

    <div class="card mt-4 overflow-hidden">
      <div class="flex justify-between items-center mb-4">
        <h2>Familias Invitadas</h2>
        <button @click="fetchFamilies" class="btn btn-outline btn-sm">Refrescar</button>
      </div>

      <div v-if="loading">Cargando...</div>
      
      <!-- Responsive Table Container -->
      <div v-else class="overflow-x-auto">
        <table class="table min-w-full">
          <thead>
            <tr class="hidden-mobile-table">
              <th>Familia</th>
              <th>Estado</th>
              <th>Invitados</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="family in families" :key="family.id" class="mobile-row">
              <td class="family-cell">
                <strong>{{ family.name }}</strong>
                <div class="text-xs text-gray-500">{{ family.token }}</div>
              </td>
              <td class="status-cell">
                <span v-if="family.confirmationDate" class="badge-success">Confirmado</span>
                <span v-else class="badge-pending">Pendiente</span>
              </td>
              <td class="guests-cell">
                <div class="guest-list">
                  <span v-for="g in family.guests" :key="g.id" :class="{ 'confirmed': g.isAttending, 'declined': !g.isAttending && family.confirmationDate }">
                    {{ g.name }}
                  </span>
                </div>
              </td>
            <td class="action-buttons-cell">
                <div class="flex gap-2">
                  <button @click="viewDetails(family)" class="btn btn-outline btn-sm flex-1" title="Ver Detalles">
                    🔍 Detalles
                  </button>
                  <button @click="copyLink(family.token)" class="btn btn-outline btn-sm" title="Copiar Enlace">
                    📋
                  </button>
                  <button @click="openLink(family.token)" class="btn btn-outline btn-sm" title="Abrir Invitación">
                    🔗
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal de Detalles -->
    <div v-if="showModal" class="modal-overlay" @click="showModal = false">
      <div class="modal-content card" @click.stop>
        <div class="flex justify-between items-start mb-4">
          <div>
            <h2>Detalles: {{ selectedFamily?.name }}</h2>
            <p v-if="selectedFamily?.token" class="text-xs text-gray-400">Token: {{ selectedFamily.token }}</p>
          </div>
          <button @click="showModal = false" class="close-btn">&times;</button>
        </div>
        
        <div v-if="selectedFamily" class="details-body">
          <p v-if="selectedFamily.confirmationDate" class="mb-4">
            <strong>Fecha de confirmación:</strong> {{ new Date(selectedFamily.confirmationDate).toLocaleString() }}
          </p>

          <div v-for="g in selectedFamily.guests" :key="g.id" class="guest-detail-card mb-4">
            <div class="flex justify-between items-center mb-2">
                <h3>{{ g.name }}</h3>
                <span :class="g.isAttending ? 'badge-success' : 'badge-pending'">
                    {{ g.isAttending ? '✅ Asistirá' : '⏳ Pendiente/No' }}
                </span>
            </div>
            
            <div class="guest-info-grid">
                <p><strong>Menú:</strong> {{ isCeliacOnlyGuest(g.name) ? 'Celíaco' : (g.isChildMenu ? 'Niño' : 'Adulto') }} {{ g.isHalfPortion ? '(Media)' : '' }}</p>
                <p><strong>Alergias:</strong> {{ g.intolerances || 'Ninguna' }}</p>
            </div>
            <p class="mt-2"><strong>Observaciones:</strong> {{ g.observations || '-' }}</p>
            
            <!-- Funny Comment Editor -->
            <div class="comment-editor mt-4">
                <label class="option-label">Comentario gracioso (Personalizable)</label>
                <div class="flex gap-2">
                    <textarea 
                        v-model="g.funnyComment" 
                        class="input flex-1 text-sm" 
                        rows="2"
                        placeholder="Escribe algo divertido para este invitado..."
                    ></textarea>
                    <button @click="saveComment(g)" class="btn btn-primary btn-sm self-end">
                        Guardar
                    </button>
                </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.card {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.form-row {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}

.flex-1 { flex: 1; }

.table {
  width: 100%;
  border-collapse: collapse;
}

.table th {
  text-align: left;
  padding: 1rem;
  border-bottom: 2px solid #f3f4f6;
  color: #6b7280;
  font-size: 0.875rem;
  text-transform: uppercase;
}

.table td {
  padding: 1rem;
  border-bottom: 1px solid #f3f4f6;
}

.guest-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.guest-list span {
  font-size: 0.85rem;
  padding: 2px 8px;
  background: #f3f4f6;
  border-radius: 4px;
}

.guest-list span.confirmed {
  background: #dcfce7;
  color: #166534;
  font-weight: 600;
}

.guest-list span.declined {
  background: #fee2e2;
  color: #991b1b;
  text-decoration: line-through;
}

.badge-success {
  background: #dcfce7;
  color: #166534;
  padding: 4px 8px;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 600;
}

.badge-pending {
  background: #f3f4f6;
  color: #4b5563;
  padding: 4px 8px;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 600;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  width: 90%;
  max-width: 600px;
  max-height: 80vh;
  overflow-y: auto;
}

.close-btn {
  background: none;
  border: none;
  font-size: 2rem;
  cursor: pointer;
  line-height: 1;
}

.guest-detail-card {
  padding: 1rem;
  background: #f9fafb;
  border-radius: 8px;
  border-left: 4px solid var(--color-accent);
}

.guest-detail-card h3 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  color: var(--color-accent);
}

.guest-info-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.5rem;
    font-size: 0.9rem;
}

.comment-editor textarea {
    border: 1px solid #ddd;
    background: white;
}

.text-xs { font-size: 0.75rem; }
.text-sm { font-size: 0.85rem; }
.text-gray-400 { color: #9ca3af; }
.self-end { align-self: flex-end; }
.mt-4 { margin-top: 1rem; }

@media (max-width: 768px) {
  .hidden-mobile-table {
    display: none;
  }
  
  .mobile-row {
    display: flex;
    flex-direction: column;
    padding: 1rem 0;
    border-bottom: 2px solid #f3f4f6;
  }
  
  .mobile-row td {
    border: none;
    padding: 0.5rem 0;
  }
  
  .status-cell {
    order: -1;
    margin-bottom: 0.5rem;
  }
  
  .action-buttons-cell {
    margin-top: 0.5rem;
  }
}

.min-w-full { min-width: 100%; }
.overflow-hidden { overflow: hidden; }
.gap-2 { gap: 0.5rem; }
</style>
