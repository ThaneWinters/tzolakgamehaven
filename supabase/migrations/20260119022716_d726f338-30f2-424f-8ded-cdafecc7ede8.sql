-- Fix the policy - admins should still have direct access
DROP POLICY IF EXISTS "Public can view site settings through view" ON public.site_settings;

-- Only admins can directly access the site_settings table
-- The site_settings_public view will handle public access
-- Note: The "Admins can view all site settings" policy already exists and handles admin access