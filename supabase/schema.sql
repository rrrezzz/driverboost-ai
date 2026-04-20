-- DriverBoost AI schema and RLS

create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  city text,
  preferred_platform text check (preferred_platform in ('rapido', 'blinkit', 'zomato')) default 'zomato',
  vehicle_type text check (vehicle_type in ('bike', 'scooter', 'cycle', 'electric')) default 'bike',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.shifts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  start_time timestamptz not null,
  end_time timestamptz not null,
  duration_minutes int not null check (duration_minutes >= 0),
  earnings numeric(10,2) not null default 0,
  orders_completed int not null default 0,
  distance_km numeric(8,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.predictions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  input jsonb not null,
  predicted_hourly numeric(10,2) not null,
  predicted_total numeric(10,2) not null,
  best_time text not null,
  confidence_percent int not null check (confidence_percent between 0 and 100),
  recommended_zone text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.zones (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  level text not null check (level in ('high', 'medium', 'low')),
  avg_earning_per_hour numeric(10,2) not null,
  demand_level text not null,
  recommended_time text not null,
  lat numeric(10,6) not null,
  lng numeric(10,6) not null,
  radius_km numeric(6,2) not null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.shifts enable row level security;
alter table public.predictions enable row level security;
alter table public.zones enable row level security;

create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);
create policy "profiles_insert_own" on public.profiles
  for insert with check (auth.uid() = id);
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id);

create policy "shifts_select_own" on public.shifts
  for select using (auth.uid() = user_id);
create policy "shifts_insert_own" on public.shifts
  for insert with check (auth.uid() = user_id);
create policy "shifts_update_own" on public.shifts
  for update using (auth.uid() = user_id);
create policy "shifts_delete_own" on public.shifts
  for delete using (auth.uid() = user_id);

create policy "predictions_select_own" on public.predictions
  for select using (auth.uid() = user_id);
create policy "predictions_insert_own" on public.predictions
  for insert with check (auth.uid() = user_id);
create policy "predictions_delete_own" on public.predictions
  for delete using (auth.uid() = user_id);

create policy "zones_read_all" on public.zones
  for select using (true);

create or replace function public.update_timestamp()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists set_profile_updated_at on public.profiles;
create trigger set_profile_updated_at
before update on public.profiles
for each row execute function public.update_timestamp();

insert into public.zones (name, level, avg_earning_per_hour, demand_level, recommended_time, lat, lng, radius_km)
values
  ('City Center', 'high', 320, 'Very High', '7 PM - 10 PM', 28.613900, 77.209000, 2.2),
  ('Tech Park Belt', 'medium', 235, 'High', '1 PM - 4 PM', 28.535500, 77.391000, 1.8),
  ('Outer Residential Ring', 'low', 160, 'Moderate', '8 AM - 10 AM', 28.459500, 77.026600, 2.6)
on conflict (name) do nothing;
