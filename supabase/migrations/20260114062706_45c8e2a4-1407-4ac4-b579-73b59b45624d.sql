-- Remove unencrypted PII columns from game_messages table
-- The encrypted versions (sender_email_encrypted, sender_name_encrypted, sender_ip_encrypted, message_encrypted) will be used instead

ALTER TABLE public.game_messages DROP COLUMN IF EXISTS sender_email;
ALTER TABLE public.game_messages DROP COLUMN IF EXISTS sender_name;
ALTER TABLE public.game_messages DROP COLUMN IF EXISTS sender_ip;
ALTER TABLE public.game_messages DROP COLUMN IF EXISTS message;