<template>
  <div class="countdown">
    <div class="countdown-item">
      <span class="number">{{ timeLeft.days }}</span>
      <span class="label">Días</span>
    </div>
    <div class="separator">:</div>
    <div class="countdown-item">
      <span class="number">{{ timeLeft.hours }}</span>
      <span class="label">Hs</span>
    </div>
    <div class="separator">:</div>
    <div class="countdown-item">
      <span class="number">{{ timeLeft.minutes }}</span>
      <span class="label">Min</span>
    </div>
    <div class="separator">:</div>
    <div class="countdown-item">
      <span class="number">{{ timeLeft.seconds }}</span>
      <span class="label">Seg</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const props = defineProps<{
  targetDate: string
}>()

const timeLeft = ref({ days: 0, hours: 0, minutes: 0, seconds: 0 })
let timer: ReturnType<typeof setInterval>

function calculateTime() {
  const diff = new Date(props.targetDate).getTime() - new Date().getTime()
  
  if (diff <= 0) return

  timeLeft.value = {
    days: Math.floor(diff / (1000 * 60 * 60 * 24)),
    hours: Math.floor((diff / (1000 * 60 * 60)) % 24),
    minutes: Math.floor((diff / 1000 / 60) % 60),
    seconds: Math.floor((diff / 1000) % 60)
  }
}

onMounted(() => {
  calculateTime()
  timer = setInterval(calculateTime, 1000)
})

onUnmounted(() => clearInterval(timer))
</script>


<style scoped>
.countdown {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-top: -3rem;
  font-family: var(--font-heading);
}

.countdown-item {
  text-align: center;
}

.number {
  font-size: 2rem;
  color: inherit; /* Inherit from parent (white in Hero) */
  font-weight: 700;
  display: block;
}

.label {
  font-size: 0.75rem;
  text-transform: uppercase;
  color: var(--color-text-dark);
  font-family: var(--font-body);
}

.separator {
  font-size: 2rem;
  color: var(--color-accent);
}
</style>
