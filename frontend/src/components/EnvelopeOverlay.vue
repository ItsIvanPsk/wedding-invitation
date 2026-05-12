<script setup lang="ts">
import { ref } from 'vue'
import logoEstampado from '@/assets/LogoEstampado.png'

const emit = defineEmits(['opened'])

const isOpen = ref(false)
const showWhite = ref(false)

const openEnvelope = () => {
  if (isOpen.value) return
  isOpen.value = true

  // Start white fade a bit earlier as the opening is now faster at start
  setTimeout(() => {
    showWhite.value = true
  }, 1300)

  // Emit after fade completes
  setTimeout(() => {
    console.log("📨 EnvelopeOverlay: Emitting 'opened' event");
    emit('opened')
  }, 3600)
  
  // Safety fallback
  setTimeout(() => {
    emit('opened')
  }, 5000)
}
</script>

<template>
  <div class="scene">
    <!-- White fade to transition -->
    <div class="white-fade" :class="{ active: showWhite }"></div>

    <!-- The envelope is the full screen. 4 triangular flaps meet at center. -->

    <!-- Static flaps (left, right, bottom) -->
    <div class="flap flap-left"></div>
    <div class="flap flap-right"></div>
    <div class="flap flap-bottom"></div>

    <!-- Top flap + seal move together as one unit -->
    <div class="top-unit" :class="{ open: isOpen }">
      <!-- Black interior lining -->
      <div class="flap flap-top-inner"></div>
      <div class="flap flap-top"></div>

      <button
        class="seal"
        :class="{ open: isOpen }"
        @click="openEnvelope"
        aria-label="Abrir el sobre pulsando el sello"
      >
        <div>
          <img :src="logoEstampado" alt="Logo Estampado" class="seal-logo" />
        </div>
      </button>
    </div>

    <!-- Hint -->
    <div class="envelope-hints" v-if="!isOpen">
      <p class="hint">Pulsa el sello para abrir</p>
      <p class="audio-hint">🔊 Se recomienda subir el volumen de tu dispositivo</p>
    </div>
  </div>
</template>

<style scoped>
/* ── Scene (full screen = the envelope body back) ───── */
.scene {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background: #000; /* Black interior revealed when opening */
  overflow: hidden;
  /* perspective for 3-D flap opening */
  perspective: 1800px;
  perspective-origin: 50% 0%;
}

/* ── White fade overlay ────────────────────────────── */
.white-fade {
  position: absolute;
  inset: 0;
  background: #fff;
  opacity: 0;
  pointer-events: none;
  z-index: 100;
  transition: opacity 2s ease-in-out;
}
.white-fade.active { opacity: 1; }

/* ── Shared flap base ────────────────────────────────  */
.flap {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

/* LEFT */
.flap-left {
  clip-path: polygon(0% 0%, 0% 100%, 50% 50%);
  background-color: #8a001c;
  z-index: 2;
  width: 140%;
  left: -20%;
  box-shadow: inset -8px 0 24px rgba(0,0,0,0.4);
}

/* RIGHT */
.flap-right {
  clip-path: polygon(100% 0%, 100% 100%, 50% 50%);
  background-color: #8a001c;
  z-index: 2;
  width: 140%;
  left: -20%;
}

/* BOTTOM */
.flap-bottom {
  clip-path: polygon(0% 100%, 100% 100%, 50% 50%);
  background-color: #6a0016;
  z-index: 3;
  width: 140%;
  left: -20%;
  filter: drop-shadow(0 -4px 12px rgba(0,0,0,0.5));
}

/* ── Top unit (flap + seal animate together) ─────────── */
.top-unit {
  position: absolute;
  inset: 0;
  width: 140%;
  left: -20%;
  transform-origin: 50% 0%;
  transition: transform 3.5s cubic-bezier(0.3, 0, 0.2, 1);
  z-index: 10;
}

.top-unit.open {
  transform: rotateX(-25deg);
}

/* TOP */
.flap-top {
  position: absolute;
  inset: 0;
  clip-path: polygon(0% 0%, 100% 0%, 50% 50%);
  background-color: #a00020;
  z-index: 2;
  filter: drop-shadow(0 6px 16px rgba(0,0,0,0.6));
}

/* Interior lining of top flap (black) */
.flap-top-inner {
  clip-path: polygon(0% 0%, 100% 0%, 50% 50%);
  background: #000;
  z-index: 1;
}

/* ── Wax seal button ─────────────────────────────────── */
/*   Sits exactly where all 4 triangles meet: 50% / 50%  */
.seal {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);

  width: clamp(90px, 22vw, 130px);
  height: clamp(90px, 22vw, 130px);

  background: none;
  border: none;
  padding: 0;
  cursor: pointer;
  z-index: 20;
  transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), filter 0.4s ease;
}

.seal-inner {
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at 35% 35%, #8b2034 0%, #5a1422 100%);
  border-radius: 48% 52% 50% 50% / 51% 48% 52% 49%; /* Irregular organic shape */
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  box-shadow: 
    inset 0 0 15px rgba(0,0,0,0.4),
    0 10px 25px rgba(0,0,0,0.5);
  border: 2px solid rgba(0,0,0,0.1);
}

/* Raised edge effect */
.seal-inner::after {
  content: '';
  position: absolute;
  inset: 10%;
  border-radius: inherit;
  border: 4px solid rgba(0,0,0,0.15);
  box-shadow: inset 0 0 10px rgba(0,0,0,0.2);
}

.seal-logo {
  width: 100%;
  height: 100%;
  object-fit: contain;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
  z-index: 2;
}

/* Hover pulse when not yet opened */
.seal:not(.open):hover {
  transform: translate(-50%, -50%) scale(1.1) rotate(3deg);
}

/* Disable interaction once opened */
.seal.open {
  pointer-events: none;
}

/* ── Edge lines to reinforce envelope shape ─────────── */
/* Thin inner stroke around each diagonal (pure CSS) */
.scene::before {
  content: '';
  position: absolute;
  inset: 0;
  width: 140%;
  left: -20%;
  /* The diagonal fold lines: X pattern from corners to center */
  background:
    linear-gradient(to bottom right, transparent calc(50% - 1px), rgba(255,180,160,0.18) calc(50% - 1px), rgba(255,180,160,0.18) calc(50% + 1px), transparent calc(50% + 1px)),
    linear-gradient(to bottom left,  transparent calc(50% - 1px), rgba(255,180,160,0.18) calc(50% - 1px), rgba(255,180,160,0.18) calc(50% + 1px), transparent calc(50% + 1px));
  pointer-events: none;
  z-index: 4;
}

/* ── Hint text ────────────────────────────────────────── */
.envelope-hints {
  position: absolute;
  bottom: 6%;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.6rem;
  z-index: 15;
  pointer-events: none;
  text-align: center;
  width: 90%;
}

.hint {
  color: rgba(255, 215, 200, 0.95);
  font-family: 'Cormorant Garamond', 'Georgia', serif;
  font-size: clamp(0.9rem, 4vw, 1.3rem);
  letter-spacing: 2px;
  white-space: nowrap;
  animation: breathe 2.5s ease-in-out infinite;
}

.audio-hint {
  color: rgba(255, 255, 255, 0.75);
  font-family: 'Montserrat', sans-serif;
  font-size: clamp(0.7rem, 3vw, 0.85rem);
  letter-spacing: 1px;
  animation: breathe 2.5s ease-in-out infinite;
  animation-delay: 0.6s;
}

@keyframes breathe {
  0%, 100% { opacity: 0.85; }
  50%       { opacity: 0.35; }
}
</style>
