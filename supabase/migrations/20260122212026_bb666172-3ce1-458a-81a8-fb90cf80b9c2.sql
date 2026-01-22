-- 1. Recreate games_public view to include location fields
DROP VIEW IF EXISTS public.games_public;

CREATE VIEW public.games_public
WITH (security_invoker = on) AS
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
    inserts,
    location_room,
    location_shelf,
    location_misc,
    created_at,
    updated_at
FROM games;

-- 2. Update RLS policies for game_sessions to allow public INSERT
DROP POLICY IF EXISTS "Admins can insert sessions" ON public.game_sessions;

CREATE POLICY "Anyone can insert sessions"
ON public.game_sessions
FOR INSERT
WITH CHECK (true);

-- 3. Update RLS policies for game_session_players to allow public INSERT
DROP POLICY IF EXISTS "Admins can insert session players" ON public.game_session_players;

CREATE POLICY "Anyone can insert session players"
ON public.game_session_players
FOR INSERT
WITH CHECK (true);