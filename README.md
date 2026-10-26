# Invoice Creator

A web app for freelancers and small businesses in Indonesia to make invoices and related billing documents, see an exact A4 preview while typing, and send the result as a PDF or straight to WhatsApp.

I built it around how small vendors here actually bill: a quotation first, then a down-payment invoice, then a settlement (pelunasan) for the remaining balance, and a receipt (kwitansi) once paid. The app keeps the math between those documents consistent so the DP and the remaining balance always add up.

## Features

- **Five document types** — invoice, quotation, down payment (DP), settlement (pelunasan) and receipt (kwitansi)
- **Automatic totals** — line items, discounts, PPN (11% by default), DP percentage and remaining balance, formatted in Rupiah
- **Live A4 preview** — the preview is the same element that gets exported, so the PDF matches what's on screen
- **Export and share** — download as PDF (jsPDF) or PNG, or open WhatsApp with a pre-filled billing message (phone numbers like `08xx` are converted to `628xx`)
- **Customer and service catalog** — save clients and services once, reuse them in new documents
- **Company profile** — logo, bank account details and signature shown on every document
- **Reports** — total billed, cash received, outstanding receivables and discounts, exportable to Excel/CSV
- **Works offline** — data is saved to `localStorage` first; if Supabase is configured, it syncs to the cloud after login, with row level security so each user only sees their own records

## Stack

React 19, TypeScript, Vite, Tailwind CSS, Supabase (auth + Postgres), jsPDF, html-to-image

## Running locally

```bash
npm install
cp .env.example .env   # optional: add Supabase URL and anon key for cloud sync
npm run dev            # http://localhost:3000
```

Without Supabase keys the app runs in local-only mode. To enable sync, run [`supabase/schema.sql`](supabase/schema.sql) in the Supabase SQL editor; it creates the tables and the row level security policies.

## Project structure

```
src/App.tsx                    # app state, tabs, local + cloud sync
src/utils.ts                   # totals, PPN/DP math, Rupiah formatting
src/components/InvoiceForm.tsx     # document editor
src/components/InvoicePreview.tsx  # A4 preview + PDF/PNG export + WhatsApp share
src/components/ReportsView.tsx     # summary numbers + Excel/CSV export
supabase/schema.sql            # database tables and RLS policies
```
