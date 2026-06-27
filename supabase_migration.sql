-- ============================================================
-- StructTech Audit Leads Table
-- Run this in Supabase SQL Editor on the structtech project
-- (ejlhrykcdfcyeooooodx)
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_leads (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at   TIMESTAMPTZ DEFAULT now(),
  name         TEXT,
  email        TEXT NOT NULL,
  company      TEXT,
  trade        TEXT,
  score        INT,
  risk_level   TEXT,  -- OPTIMIZED / MODERATE / HIGH RISK / CRITICAL
  monthly_leak INT,   -- estimated dollars per month
  crew_size    INT,
  top_leaks    TEXT[], -- array of question IDs (q1, q4, q6, etc.)
  answers      JSONB,  -- { q1: 0, q2: 6, q3: 2, ... }
  source       TEXT DEFAULT 'audit.structtek.com',
  contacted    BOOLEAN DEFAULT false,
  notes        TEXT
);

-- Allow anonymous inserts (funnel runs on the frontend)
ALTER TABLE audit_leads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anon insert" ON audit_leads
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "Allow authenticated read" ON audit_leads
  FOR SELECT TO authenticated USING (true);

-- Index for dashboard queries
CREATE INDEX idx_audit_leads_created ON audit_leads (created_at DESC);
CREATE INDEX idx_audit_leads_risk    ON audit_leads (risk_level);
CREATE INDEX idx_audit_leads_email   ON audit_leads (email);
