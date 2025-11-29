-- Create app_versions table for managing app updates
CREATE TABLE IF NOT EXISTS app_versions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  platform TEXT NOT NULL CHECK (platform IN ('android', 'ios')),
  version TEXT NOT NULL,
  force_update BOOLEAN DEFAULT false NOT NULL,
  update_message TEXT,
  store_url TEXT,
  is_active BOOLEAN DEFAULT true NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

  -- Ensure unique active versions per platform
  UNIQUE (platform, version)
);

-- Add index for faster queries
CREATE INDEX idx_app_versions_platform_active ON app_versions(platform, is_active, created_at DESC);

-- Add updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = timezone('utc'::text, now());
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_app_versions_updated_at
  BEFORE UPDATE ON app_versions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Add comment
COMMENT ON TABLE app_versions IS 'Stores app version information for update management';

-- Insert sample data for testing (optional - comment out for production)
-- INSERT INTO app_versions (platform, version, force_update, update_message, store_url, is_active)
-- VALUES
--   ('android', '1.0.0', false, 'A new version of Sylonow is available with bug fixes and improvements.', 'https://play.google.com/store/apps/details?id=com.sylonowusr.sylonow_user', true),
--   ('ios', '1.0.0', false, 'A new version of Sylonow is available with bug fixes and improvements.', 'https://apps.apple.com/app/sylonow/idXXXXXXXXXX', true);
