<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const username = ref('')
const password = ref('')
const error = ref(false)
const router = useRouter()

function login() {
  // Guardamos las credenciales para usarlas en los headers de las peticiones API
  sessionStorage.setItem('admin_user', username.value)
  sessionStorage.setItem('admin_password', password.value)
  
  // Intentamos navegar al admin
  router.push('/admin')
}
</script>

<template>
  <div class="login-container">
    <div class="login-card card">
      <h1>Panel Admin</h1>
      <p>Introduce tus credenciales para acceder</p>
      
      <div class="form-group mt-4">
        <input 
          v-model="username" 
          type="text" 
          placeholder="Usuario" 
          class="input w-full mb-2"
        />
        <input 
          v-model="password" 
          type="password" 
          placeholder="Contraseña" 
          class="input w-full"
          @keyup.enter="login"
        />
        <p v-if="error" class="error-text">Credenciales incorrectas</p>
      </div>
      
      <button @click="login" class="btn btn-primary w-full mt-4">Entrar</button>
    </div>
  </div>
</template>

<style scoped>
.mb-2 { margin-bottom: 0.5rem; }
/* ... existing styles ... */
.login-container {
  height: 80vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
.login-card {
  width: 100%;
  max-width: 400px;
  text-align: center;
}
.error-text {
  color: #e74c3c;
  font-size: 0.8rem;
  margin-top: 0.5rem;
}
.w-full {
  width: 100%;
}
</style>
