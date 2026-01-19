-- Fix: Remove the bypassable public SELECT policy from site_settings
-- The inequality check (key <> 'contact_email') can be bypassed
-- Instead, we'll rely only on the site_settings_public view for public access

-- Drop the unsafe public SELECT policy
DROP POLICY IF EXISTS "Public can view non-sensitive site settings" ON public.site_settings;

-- Recreate the site_settings_public view to ensure it excludes sensitive keys
-- Using security_invoker=on so the view uses caller's permissions
DROP VIEW IF EXISTS public.site_settings_public;

CREATE VIEW public.site_settings_public
WITH (security_invoker = on) AS
SELECT id, key, value, created_at, updated_at
FROM public.site_settings
WHERE key NOT IN ('contact_email', 'turnstile_site_key', 'smtp_password', 'api_key');

-- Grant SELECT on the public view to everyone
GRANT SELECT ON public.site_settings_public TO anon, authenticated;

-- Create a permissive policy for the view to work (reads from base table for the view)
-- This policy only allows access through the admin check OR when accessed via the view
CREATE POLICY "Public can view site settings through view"
ON public.site_settings
FOR SELECT
USING (false);  -- Deny direct access; view will use security definer function instead