import { createRouter, createWebHistory } from 'vue-router'
import InvitationView from '../views/InvitationView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/confirmacion/:token',
      name: 'invitation',
      component: InvitationView
    },
    {
      path: '/confirmacion-exito/:token',
      name: 'confirmation-success',
      component: () => import('../views/ConfirmationView.vue')
    },
    {
      path: '/admin',
      name: 'admin',
      component: () => import('../views/AdminView.vue')
    },
    {
      path: '/',
      name: 'home',
      // For now, redirect to a demo token or show a landing. 
      // Redirecting to a generic landing is safer.
      component: () => import('../views/InvitationView.vue') // Placeholder
    }
  ]
})

export default router
