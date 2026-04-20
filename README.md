# DriverBoost AI

DriverBoost AI is a startup-style full-stack web app for delivery and gig drivers to forecast earnings, track shifts, find profitable zones, and analyze performance history.

## Stack

- React + Vite + JavaScript
- Tailwind CSS
- Supabase (Auth + PostgreSQL)
- React Router
- Recharts
- React Leaflet + Leaflet

## Features

- Authentication (sign up, log in, logout, protected routes, persistent session)
- Dashboard with KPI cards, weekly trend chart, AI recommendations, and recent shifts
- Earnings Predictor with smart formula-based insights
- Shift Tracker with start/stop workflow and persisted logs
- Profit Zone Map with color-coded demand zones
- History page for shifts, predictions, monthly total, and hourly average
- Profile page for editable driver preferences
- Loading, empty, and toast states
- Responsive desktop sidebar + mobile bottom navigation

## Project Structure

```txt
src/
  components/    # Reusable UI primitives and states
  pages/         # Route pages (Dashboard, Predictor, Tracker, Map, History, Profile, Auth)
  layouts/       # Shared shell and navigation
  lib/           # Supabase client, API layer, seeded data helpers
  hooks/         # Auth and toast context hooks
  utils/         # Predictor and formatting utilities
```

## Major Files (What They Do)

- `src/main.jsx`: App bootstrap, router wrapper, auth provider, toast provider.
- `src/routes.jsx`: Full route tree with protected routes.
- `src/hooks/useAuth.jsx`: Supabase auth integration and local demo fallback.
- `src/lib/api.js`: Data-access layer for profiles, shifts, predictions, and zones.
- `src/layouts/AppLayout.jsx`: Main shell with sidebar and mobile navigation.
- `src/pages/DashboardPage.jsx`: KPI cards, weekly chart, AI insight, and recent shift table.
- `src/pages/EarningsPredictorPage.jsx`: Input form + smart prediction output + persistence.
- `src/pages/ShiftTrackerPage.jsx`: Start/stop shift lifecycle and shift list.
- `src/pages/ProfitMapPage.jsx`: Leaflet map with zone circles and popups.
- `src/pages/HistoryPage.jsx`: Performance summary, charts, and historical records.
- `src/pages/ProfilePage.jsx`: Profile management form.
- `supabase/schema.sql`: Full SQL schema, constraints, RLS, and seed zone rows.

## Supabase Setup

1. Create a Supabase project.
2. In Supabase SQL Editor, run `supabase/schema.sql`.
3. Go to Auth > URL Configuration and set local and production URLs.
4. Copy `.env.example` to `.env` and fill:

```env
VITE_SUPABASE_URL=...
VITE_SUPABASE_ANON_KEY=...
VITE_ENABLE_DEMO_TOUR=false
```

## Local Run

```bash
npm install
npm run dev
```

Then open the local Vite URL.

## Build for Production

```bash
npm run build
npm run preview
```

## Deployment

### Vercel / Netlify

1. Import this repository.
2. Set environment variables:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
   - `VITE_ENABLE_DEMO_TOUR` (set `true` for presentation walkthrough banner)
3. Build command: `npm run build`
4. Output directory: `dist`

### Supabase

- Keep RLS enabled.
- Use policies in `supabase/schema.sql`.
- Add storage buckets later if you decide to support document/image uploads.

## Notes

- If Supabase env vars are missing, the app runs in local demo mode using browser storage.
- This keeps the UI fully testable while backend setup is pending.
- Route-level lazy loading and manual chunking are enabled to reduce initial bundle size.
