-- Move unaccent out of public schema to satisfy linter warning
CREATE SCHEMA IF NOT EXISTS extensions;

DO $$
BEGIN
  -- Move extension only if it's currently in public
  IF EXISTS (
    SELECT 1
    FROM pg_extension e
    JOIN pg_namespace n ON n.oid = e.extnamespace
    WHERE e.extname = 'unaccent' AND n.nspname = 'public'
  ) THEN
    ALTER EXTENSION unaccent SET SCHEMA extensions;
  END IF;
END $$;

-- Update slugify to reference extensions.unaccent and include it in search_path
CREATE OR REPLACE FUNCTION public.slugify(input text)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path TO 'public, extensions'
AS $$
  SELECT trim(both '-' from regexp_replace(
    regexp_replace(lower(extensions.unaccent(coalesce(input, ''))), '[^a-z0-9]+', '-', 'g'),
    '-{2,}', '-', 'g'
  ));
$$;
