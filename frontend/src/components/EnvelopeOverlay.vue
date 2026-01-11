<script setup lang="ts">
import { ref } from 'vue'

const emit = defineEmits(['opened', 'start-opening'])
const isOpen = ref(false)
const isFinished = ref(false)

const openEnvelope = () => {
  if (isOpen.value) return
  isOpen.value = true
  emit('start-opening')
  
  setTimeout(() => {
    isFinished.value = true
    setTimeout(() => {
      emit('opened')
    }, 1000)
  }, 800)
}
</script>

<template>
  <div class="envelope-overlay" :class="{ 'is-finished': isFinished }">
    <div class="envelope-container" :class="{ 'is-open': isOpen }" @click="openEnvelope">
      <div class="envelope-body">
        <div class="envelope-back"></div>
        <div class="envelope-paper">
           <div class="paper-content">
             <h2>N & I</h2>
           </div>
        </div>
        <div class="envelope-front"></div>
        <div class="envelope-flap">
           <button class="wax-seal-btn" @click.stop="openEnvelope">
             <img src="@/assets/wax-seal.png" alt="Abrir" />
           </button>
        </div>
      </div>
    </div>
    
    <div class="click-hint" v-if="!isOpen">
      <p>Pulsa el sello para abrir</p>
    </div>
  </div>
</template>

<style scoped>
.envelope-overlay {
  position: fixed;
  inset: 0;
  background-color: #f0f4f8;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  transition: transform 1s cubic-bezier(0.7, 0, 0.3, 1), opacity 0.5s ease;
}

.envelope-overlay.is-finished {
  transform: translateY(-100%);
  pointer-events: none;
}

.envelope-container {
  position: relative;
  width: min(90vw, 600px);
  max-width: 600px;
  aspect-ratio: 1.6;
  cursor: pointer;
  perspective: 1500px;
}

.envelope-body {
  position: relative;
  width: 100%;
  height: 100%;
  transform-style: preserve-3d;
}

/* Colors */
:root {
  --envelope-color: #1e3a8a; 
  --envelope-dark: #172554;
  --envelope-light: #2563eb;
}

/* Back of envelope (inside) */
.envelope-back {
  position: absolute;
  inset: 0;
  background-color: #1e3a5f; /* Deep Blue */
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.2);
}

/* Paper/Card inside - subtly visible */
.envelope-paper {
  position: absolute;
  inset: 10px;
  top: 20px;
  background-color: white;
  height: 90%;
  border-radius: 8px;
  z-index: 1;
  transition: transform 0.6s ease 0.6s;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
}

.paper-content h2 {
  font-family: 'Great Vibes', cursive; /* Assuming font exists, or fallback */
  font-size: 3rem;
  color: #333;
  opacity: 0.2;
}

.is-open .envelope-paper {
  transform: translateY(-50px);
  z-index: 4; /* Pop out above front */
}

/* Front Pocket */
.envelope-front {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 0;
  border-bottom: 250px solid #2e4a7d; /* Slightly lighter blue */
  border-left: 300px solid transparent;
  border-right: 300px solid transparent;
  width: 0;
  z-index: 5;
  filter: drop-shadow(0 -5px 10px rgba(0,0,0,0.1));
  /* Responsive triangle requires simplified approach usually, but let's try CSS borders first, or absolute positioning with clip-path */
}

/* Better approach for responsive front pocket */
.envelope-front {
  position: absolute;
  inset: 0;
  border: 0;
  background: transparent;
  z-index: 10;
  pointer-events: none; /* Let click pass through to paper if needed */
  /* Create the V shape pocket */
  clip-path: polygon(0 100%, 100% 100%, 100% 40%, 50% 65%, 0 40%);
  background-color: #2c3e50; /* Blue-Gray/Navy */
  background: linear-gradient(135deg, #2c3e50, #34495e);
  border-bottom-left-radius: 12px;
  border-bottom-right-radius: 12px;
}

/* Flap */
.envelope-flap {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 65%; /* Reaches the middle roughly */
  background-color: #34495e; /* Matching envelope */
  background: linear-gradient(135deg, #34495e, #2c3e50);
  clip-path: polygon(0 0, 100% 0, 50% 100%);
  transform-origin: top;
  transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1), z-index 0s linear 0.4s;
  z-index: 20; /* Above front initially */
  border-top-left-radius: 12px;
  border-top-right-radius: 12px;
  filter: drop-shadow(0 5px 15px rgba(0,0,0,0.3));
}

.is-open .envelope-flap {
  transform: rotateX(180deg);
  z-index: 0; /* Fall behind everything */
  pointer-events: none;
}

/* Wax Seal Button */
.wax-seal-btn {
  position: absolute;
  bottom: 20px; /* Position near the tip of the triangle */
  left: 50%;
  transform: translateX(-50%) translateZ(1px); /* Ensure it sits on top */
  width: 120px;
  height: 120px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  z-index: 25;
  transition: transform 0.3s ease;
  filter: drop-shadow(0 4px 6px rgba(0,0,0,0.3));
}

.wax-seal-btn:hover {
  transform: translateX(-50%) scale(1.1);
}

.wax-seal-btn img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.click-hint {
  margin-top: 3rem;
  color: #333;
  font-size: 1.2rem;
  opacity: 0.7;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 0.7; }
  50% { opacity: 0.3; }
}

/* Responsive adjustments */
@media (max-width: 600px) {
  .envelope-container {
    width: 90vw;
    /* Adjust clip paths for aspect ratio changes if necessary, but polygon % works well */
  }
}
</style>
