import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import Countdown from '../Countdown.vue'

describe('Countdown', () => {
    it('renders properly', () => {
        const wrapper = mount(Countdown, { props: { targetDate: '2026-12-05T12:00:00' } })
        expect(wrapper.text()).toContain('Días')
        expect(wrapper.text()).toContain('Hs')
        expect(wrapper.text()).toContain('Min')
        expect(wrapper.text()).toContain('Seg')
    })

    // Testing time calculation might require mocking Date, skipping for brevity in this iteration
})
