import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export interface Guest {
  id: number
  name: string
  isAttending: boolean
  isChildMenu: boolean
  isAdultMenu: boolean
  isHalfPortion: boolean
  intolerances?: string | null
  selectedIntolerances: number[]
  observations?: string | null
  funnyComment?: string | null
}

export interface Family {
  id: string
  name: string
  token: string
  confirmationDate: string | null
  guests: Guest[]
}

export const useFamilyStore = defineStore('family', () => {
  const family = ref<Family | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)
  const confirmationDeadline = ref<string | null>('01/11/2026');
  const isConfirmed = computed(() => !!family.value?.confirmationDate)

  async function fetchFamily(token: string) {
    loading.value = true
    error.value = null
    try {
      const response = await fetch(`/api/families/${token}`)
      if (!response.ok) throw new Error('Token inválido o familia no encontrada')
      family.value = await response.json()
    } catch (e: any) {
      error.value = e.message
      family.value = null
    } finally {
      loading.value = false
    }
  }

  async function confirmAttendance() {
    if (!family.value) return
    loading.value = true
    try {
      const payload = {
        guests: family.value.guests.map(g => ({
          guestId: Number(g.id),
          isAttending: g.isAttending,
          isChildMenu: g.isChildMenu,
          isAdultMenu: g.isAdultMenu,
          isHalfPortion: g.isHalfPortion,
          intolerances: g.intolerances,
          selectedIntolerances: g.selectedIntolerances,
          observations: g.observations,
          funnyComment: g.funnyComment
        }))
      }

      const response = await fetch(`/api/families/${family.value.token}/confirm`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      })

      if (!response.ok) throw new Error('Error al confirmar asistencia')

      // Update local state to reflect confirmation
      family.value.confirmationDate = new Date().toISOString()

    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  return { family, loading, error, isConfirmed, fetchFamily, confirmAttendance, confirmationDeadline }
})
