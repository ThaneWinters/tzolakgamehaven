-- Allow placeholder value '[encrypted]' in game_messages.sender_email while keeping email-format validation

ALTER TABLE public.game_messages
  DROP CONSTRAINT IF EXISTS check_email_format;

-- Recreate constraint with a safe allowance for the redacted placeholder used by the send-message function
ALTER TABLE public.game_messages
  ADD CONSTRAINT check_email_format
  CHECK (
    sender_email = '[encrypted]'
    OR sender_email ~* '^[A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,}$'
  );
