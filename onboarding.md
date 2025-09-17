# Onboarding Flow 

Splash Screen 

1. Check if user is logged in 
2. If user is not logged in then show the welcome screen with get started button 
3. then after press get started button go to login screen
4. after enter phoner number and otp verification check 
5. If user has completed on_oboarding in user_profiles table 
6. then show the home screen 
7. else show the onboarding screen 
8. in optimized home screen show the pop with message 

Hey {user_name} 
let's plan your your {occasion} on {date}

9. this place holder will be got from user on onbaording screen of 
name_screen.dart -- name 
date_screen.dart -- date 
occasion_screen.dart -- occasion 

10. also add the assets on 

name_screen.dart -- assets/images/name.png
occasion_screen.dart -- assets/images/occasion.png
date_screen.dart -- assets/images/date_picker.png

# user_profiles table schema 

create table public.user_profiles (
  id uuid not null default gen_random_uuid(),
  auth_user_id uuid null,
  app_type text not null,
  created_at timestamp with time zone null default timezone('utc'::text, now()),
  updated_at timestamp with time zone null default timezone('utc'::text, now()),
  full_name text null,
  phone_number text null,
  email text null,
  date_of_birth date null,
  gender text null,
  profile_image_url text null,
  bio text null,
  city text null,
  state text null,
  country text null default 'India'::text,
  postal_code text null,
  emergency_contact_name text null,
  emergency_contact_phone text null,
  celebration_date date null,
  celebration_time time without time zone null,
  fcm_token text null,
  is_onboarding_completed boolean null default false,
  constraint user_profiles_pkey primary key (id),
  constraint user_profiles_auth_user_id_key unique (auth_user_id),
  constraint user_profiles_fcm_token_key unique (fcm_token),
  constraint user_profiles_auth_user_id_fkey foreign key (auth_user_id) references auth.users (id) on delete cascade,
  constraint user_profiles_app_type_check check (
    app_type = any (array['vendor'::text, 'customer'::text, 'user'::text])
  )
);

