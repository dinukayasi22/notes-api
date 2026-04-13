-- ============================================
-- Notes API Schema for Supabase
-- ============================================

CREATE TABLE notes (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title      VARCHAR(255) NOT NULL,
  content    TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── Auto-update updated_at ───────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
BEFORE UPDATE ON notes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- ─── Row Level Security ───────────────────────
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all access" ON notes
  FOR ALL USING (true) WITH CHECK (true);

-- ─── Seed Data ────────────────────────────────
INSERT INTO notes (title, content) VALUES
  ('Learn Terraform', 'Provision AWS infrastructure with code using .tf files'),
  ('Learn Jenkins', 'Set up a CI/CD pipeline that triggers on every GitHub push'),
  ('Learn Bash', 'Write scripts to automate server setup and deployments');