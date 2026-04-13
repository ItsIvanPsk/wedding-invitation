<script setup lang="ts">
import { ref } from 'vue'

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
        <div class="seal-inner">
          <span class="initials">N & I</span>
        </div>
      </button>
    </div>

    <!-- Hint -->
    <p class="hint" v-if="!isOpen">Pulsa el sello para abrir</p>
  </div>
</template>

<style scoped>
/* ── Variables ──────────────────────────────────────── */
:root {
  --burg-base:    #6b1a2a;
  --burg-dark:    #4e1220;
  --burg-mid:     #7d2033;
  --burg-light:   #9b2a41;
  --burg-top:     #8c2239;
}

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
/*  Every flap is a full-cover div clipped to a triangle */
.flap {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

/* LEFT  — triangle: top-left → bottom-left → center */
.flap-left {
  clip-path: polygon(0% 0%, 0% 100%, 50% 50%);
  background: linear-gradient(135deg, #7d2033 0%, #5e1826 100%);
  z-index: 2;
  /* subtle inner shadow toward center */
  box-shadow: inset -8px 0 24px rgba(0,0,0,0.25);
}

/* RIGHT — triangle: top-right → bottom-right → center */
.flap-right {
  clip-path: polygon(100% 0%, 100% 100%, 50% 50%);
  background: linear-gradient(225deg, #7d2033 0%, #5e1826 100%);
  z-index: 2;
}

/* BOTTOM — triangle: bottom-left → bottom-right → center */
.flap-bottom {
  clip-path: polygon(0% 100%, 100% 100%, 50% 50%);
  background: linear-gradient(0deg, #4e1220 0%, #6b1a2a 100%);
  z-index: 3;
  /* drop shadow upward to separate from back */
  filter: drop-shadow(0 -4px 12px rgba(0,0,0,0.35));
}

/* ── Top unit (flap + seal animate together) ─────────── */
.top-unit {
  position: absolute;
  inset: 0;
  transform-origin: 50% 0%;           /* hinge at top edge */
  /* Faster start, medium-slow smooth finish */
  transition: transform 3.5s cubic-bezier(0.3, 0, 0.2, 1);
  z-index: 10;
}

/* When open: only lift slightly before fading to white */
.top-unit.open {
  transform: rotateX(-25deg);
}

/* TOP — triangle: top-left → top-right → center */
.flap-top {
  position: absolute;
  inset: 0;
  clip-path: polygon(0% 0%, 100% 0%, 50% 50%);
  background: linear-gradient(180deg, #a0293f 0%, #7d2033 100%);
  z-index: 2;
  filter: drop-shadow(0 6px 16px rgba(0,0,0,0.4));
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

.initials {
  font-family: 'Playfair Display', serif;
  font-size: clamp(2.2rem, 5vw, 3.2rem);
  color: rgba(255, 215, 200, 0.85);
  text-shadow: 0px 2px 3px rgba(0,0,0,0.5), 0 0 1px rgba(255,255,255,0.2);
  user-select: none;
  font-style: italic;
  font-weight: 700;
  z-index: 2;
  letter-spacing: -2px;
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
  /* The diagonal fold lines: X pattern from corners to center */
  background:
    linear-gradient(to bottom right, transparent calc(50% - 1px), rgba(255,180,160,0.18) calc(50% - 1px), rgba(255,180,160,0.18) calc(50% + 1px), transparent calc(50% + 1px)),
    linear-gradient(to bottom left,  transparent calc(50% - 1px), rgba(255,180,160,0.18) calc(50% - 1px), rgba(255,180,160,0.18) calc(50% + 1px), transparent calc(50% + 1px));
  pointer-events: none;
  z-index: 4;
}

/* ── Hint text ────────────────────────────────────────── */
.hint {
  position: absolute;
  bottom: 7%;
  left: 50%;
  transform: translateX(-50%);
  color: rgba(255, 215, 200, 0.8);
  font-family: 'Cormorant Garamond', 'Georgia', serif;
  font-size: clamp(0.85rem, 3.5vw, 1.2rem);
  letter-spacing: 2px;
  text-align: center;
  white-space: nowrap;
  pointer-events: none;
  z-index: 15;
  animation: breathe 2.5s ease-in-out infinite;
}

@keyframes breathe {
  0%, 100% { opacity: 0.8; }
  50%       { opacity: 0.3; }
}
</style>
