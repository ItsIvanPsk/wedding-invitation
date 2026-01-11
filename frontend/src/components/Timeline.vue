<template>
  <div class="timeline-container">
    <div class="timeline-item">
      <div class="time">17:30</div>
      <div class="content">
        <h3>Llegada de los invitados</h3>
        <p>Entrada del hotel</p>
      </div>
    </div>
    <div class="timeline-item">
      <div class="time">18:00</div>
      <div class="content">
        <h3>Inicio de Ceremonia</h3>
        <p>Jardines Principales</p>
      </div>
    </div>
    <div class="timeline-item">
      <div class="time">19:00</div>
      <div class="content">
        <h3>Cocktail</h3>
        <p>Jardín de las Palmeras</p>
      </div>
    </div>
    <div class="timeline-item">
      <div class="time">21:00</div>
      <div class="content">
        <h3>Banquete</h3>
        <p>Salón Principal</p>
      </div>
    </div>
    <div class="timeline-item">
      <div class="time">23:30</div>
      <div class="content">
        <h3>Fin de la Banquete</h3>
        <p>Inicio discoteca privada</p>
      </div>
    </div>
    <div class="timeline-item">
      <div class="time">03:00</div>
      <div class="content">
        <h3>Fin de la Fiesta</h3>
      </div>
    </div>
  </div>
</template>

<style scoped>
.timeline-container {
  position: relative;
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem 0;
}

/* Central Line */
.timeline-container::before {
  content: '';
  position: absolute;
  top: 0;
  bottom: 0;
  left: 50%;
  width: 2px;
  background-image: linear-gradient(to bottom, var(--color-accent) 33%, rgba(255,255,255,0) 0%);
  background-position: right;
  background-size: 2px 10px;
  background-repeat: repeat-y;
  transform: translateX(-50%);
}

.timeline-item {
  position: relative;
  margin-bottom: 3rem;
  width: 50%;
  padding: 0 2rem;
  box-sizing: border-box;
}

/* Left items */
.timeline-item:nth-child(odd) {
  left: 0;
  text-align: right;
}

/* Right items */
.timeline-item:nth-child(even) {
  left: 50%;
  text-align: left;
}

/* Dot on line */
.timeline-item::after {
  content: '';
  position: absolute;
  width: 16px;
  height: 16px;
  background-color: var(--color-primary);
  border: 4px solid var(--color-accent);
  border-radius: 50%;
  top: 0;
  z-index: 1;
}

.timeline-item:nth-child(odd)::after {
  right: -10px; /* Adjust based on dot size to center on line */
}

.timeline-item:nth-child(even)::after {
  left: -10px;
}

.time {
  font-family: var(--font-heading);
  font-size: 1.5rem;
  color: var(--color-accent);
  margin-bottom: 0.5rem;
  font-weight: bold;
}

.content h3 {
  margin: 0;
  font-size: 1.2rem;
  color: var(--color-text-main);
}

.content p {
  color: var(--color-text-light);
  margin: 0.2rem 0 0;
}
</style>
