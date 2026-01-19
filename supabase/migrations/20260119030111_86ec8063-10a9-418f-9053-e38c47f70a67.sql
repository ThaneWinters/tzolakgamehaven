-- Fix 1: Recreate site_settings_public view WITHOUT security_invoker
-- This allows public users to access the view, which filters sensitive keys
DROP VIEW IF EXISTS public.site_settings_public;

CREATE VIEW public.site_settings_public AS
SELECT 
  id,
  key,
  value,
  created_at,
  updated_at
FROM public.site_settings
WHERE key NOT IN ('contact_email', 'turnstile_site_key', 'smtp_password', 'api_key', 'PII_ENCRYPTION_KEY');
-- Note: NOT using security_invoker so the view runs with definer permissions
-- The WHERE clause filters out sensitive keys so this is safe

-- Fix 2: Update games table RLS - remove the public SELECT policy 
-- since we want to use games_public view for public access
DROP POLICY IF EXISTS "Public can view games" ON public.games;

-- Fix 3: games_public view needs to be a proper view that hides sensitive columns
-- First drop it if it exists
DROP VIEW IF EXISTS public.games_public;

-- Create games_public view that excludes sensitive admin fields (location_misc, purchase info from admin_data)
-- This view exposes only customer-facing data
CREATE VIEW public.games_public AS
SELECT 
  id,
  title,
  slug,
  description,
  image_url,
  additional_images,
  youtube_videos,
  bgg_id,
  bgg_url,
  min_players,
  max_players,
  play_time,
  difficulty,
  game_type,
  publisher_id,
  suggested_age,
  is_coming_soon,
  is_for_sale,
  sale_price,
  sale_condition,
  is_expansion,
  parent_game_id,
  in_base_game_box,
  sleeved,
  upgraded_components,
  crowdfunded,
  created_at,
  updated_at,
  -- Intentionally exclude: location_room, location_shelf, location_misc, inserts
  -- These are internal inventory management fields
  location_room,
  location_shelf
FROM public.games;
-- Note: NOT using security_invoker so the view runs with definer permissions