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
      component: () => import('../views/AdminView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/LoginView.vue')
    },
    {
      path: '/',
      name: 'home',
      component: () => import('../views/InvitationView.vue')
    }
  ]
})

// Navigation Guard
router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !sessionStorage.getItem('admin_password')) {
    next('/login')
  } else {
    next()
  }
})

export default router
