# Revenue Leak Scan — Deployment Checklist

## What You Built
A 4-page Russell Brunson-style funnel at `audit.structtek.com`:
1. **index.html** — Hook page (FB ads landing page, no nav, single CTA)
2. **scan.html** — 11-question diagnostic (crew size + 10 scored questions, auto-advances)
3. **results.html** — Score reveal + email gate (blurred 3rd leak, AI report tease)
4. **bridge.html** — Thank you + fake generating bar + strategy call CTA

Data flows: localStorage → results → Make.com webhook + Supabase `audit_leads` table.

---

## Step 1: GitHub Repo (15 min)

1. Go to github.com → New repository
2. Name it: `structtech-audit`
3. Set to **Public**
4. Upload all files from this folder
5. Go to **Settings → Pages**
6. Source: Deploy from branch → `main` → `/ (root)`
7. Custom domain: `audit.structtek.com`
8. ✓ Enforce HTTPS

---

## Step 2: DNS (5 min)

In your DNS provider (where structtek.com is managed):

```
Type:   CNAME
Name:   audit
Value:  jacobaw1995.github.io
TTL:    300
```

GitHub Pages auto-generates the SSL cert. Takes 5–30 min to propagate.

---

## Step 3: Supabase Table (5 min)

1. Go to supabase.com → Project: `structtech` (ejlhrykcdfcyeooooodx)
2. **SQL Editor** → New Query
3. Paste the contents of `supabase_migration.sql`
4. Run it ✓

This creates the `audit_leads` table with RLS allowing anonymous inserts.
Every scan submission auto-appears in your Supabase dashboard.

---

## Step 4: Make.com Webhook + Claude API (30 min)

### Create the Make.com Scenario

1. New scenario in Make.com
2. **Trigger:** Webhooks → Custom Webhook → Copy the URL
3. **Replace** `YOUR_MAKE_WEBHOOK_URL_HERE` in `results.html` line ~145 with this URL
4. Add module: **HTTP → Make a request** (calls Claude API)
   - URL: `https://api.anthropic.com/v1/messages`
   - Method: POST
   - Headers: `x-api-key: YOUR_ANTHROPIC_KEY`, `anthropic-version: 2023-06-01`, `Content-Type: application/json`
   - Body (JSON):
```json
{
  "model": "claude-opus-4-8",
  "max_tokens": 2000,
  "messages": [{
    "role": "user",
    "content": "You are Jacob Walker, founder of StructTech LLC — a construction workflow automation consulting firm. Write a personalized Revenue Leak Report for {{name}} at {{company}} ({{trade}}, crew of {{crew_size}}).\n\nTheir scan results:\n- Score: {{score}}/100 ({{risk_level}})\n- Estimated monthly revenue leak: ${{revenue_leak_monthly}}\n- Top problem areas: {{top_leaks}}\n- Full answer breakdown: {{answers_by_q}}\n\nWrite in Jacob's voice: direct, no-fluff, construction-industry-savvy. Include:\n1. A honest assessment of their situation (2-3 sentences, name them by name)\n2. The 3 specific revenue leaks costing them the most (with dollar impact context)\n3. A concrete 90-Day Attack Plan:\n   - Phase 1 (Days 1-30): Quick wins — what to fix immediately\n   - Phase 2 (Days 31-60): Systems — what to build\n   - Phase 3 (Days 61-90): Scale — what to optimize\n4. Closing line inviting them to book a free strategy call at structtek.com/operational-audit\n\nFormat as clean plain text. No markdown headers (this goes into an email)."
  }]
}
```

5. Add module: **Email (Gmail) → Send an Email**
   - To: `{{email}}`
   - Subject: `Your StructTech Revenue Leak Report — {{name}}`
   - Body: The Claude API response from step 4
   - From: your business Gmail

6. **Activate** the scenario.

---

## Step 5: Meta Pixel + GA4 (10 min)

### Meta Pixel
1. Go to Meta Business Suite → Events Manager → Create Pixel
2. Copy your Pixel ID
3. Replace `YOUR_PIXEL_ID` in all 4 HTML files (Ctrl+F → Replace All)

### GA4
1. Go to analytics.google.com → Create Property → Get Measurement ID (G-XXXXXXXX)
2. Replace `YOUR_GA4_ID` in all 4 HTML files

---

## Step 6: Update structtek.com (10 min)

Add a primary CTA button on the Wix homepage pointing to `audit.structtek.com`:

**Button text:** "GET YOUR FREE REVENUE LEAK SCAN →"  
**Link:** `https://audit.structtek.com`

Also add to:
- Services page (below each service description)
- Operational Audit page (as an inline CTA)
- Navigation (top right, orange button)

---

## Running Ads to This Funnel

### Facebook Ad Copy (hook)
**Headline:** "Is your construction business leaking money?"  
**Primary text:** "Most 1-9 person construction companies lose $2,000+ a month to bad systems. Find out exactly where yours is leaking — and get a free personalized plan to fix it. Takes 90 seconds."  
**CTA Button:** Learn More  
**Landing page:** https://audit.structtek.com

### Targeting
- Location: Your service area (or nationwide if scaling)
- Interests: Construction, Home Improvement, HVAC, Roofing, Small Business
- Job titles: Owner, Founder, Contractor
- Business size: 1–9 employees (if using LinkedIn)
- Exclude: Already customers (upload email list)

---

## Files in This Folder

```
structtech-audit/
├── index.html              ← Hook landing page
├── scan.html               ← 11-question diagnostic
├── results.html            ← Score reveal + email gate
├── bridge.html             ← Thank you / bridge to call
├── style.css               ← Shared design system
├── CNAME                   ← GitHub Pages custom domain
├── supabase_migration.sql  ← Run once in Supabase SQL Editor
└── SETUP.md                ← This file
```

---

## Viewing Leads

After deployment, view leads in two places:

1. **Supabase:** supabase.com → structtech project → Table Editor → `audit_leads`
2. **Your inbox:** Make.com delivers the AI-generated report email to each lead

Eventually we'll add these leads to your OPS Center dashboard pipeline view.

---

## Questions?

All placeholders to replace before going live:
- [ ] `YOUR_PIXEL_ID` (4 files)
- [ ] `YOUR_GA4_ID` (2 files)
- [ ] `YOUR_MAKE_WEBHOOK_URL_HERE` (results.html)
- [ ] `hello@structtek.com` (bridge.html — update if different)
