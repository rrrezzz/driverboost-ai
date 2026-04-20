import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
  ],
  build: {
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes('node_modules/react') || id.includes('react-router-dom')) {
            return 'vendor_react'
          }
          if (id.includes('@supabase/supabase-js')) return 'vendor_supabase'
          if (id.includes('recharts')) return 'vendor_charts'
          if (id.includes('leaflet') || id.includes('react-leaflet')) return 'vendor_map'
          return undefined
        },
      },
    },
  },
})
