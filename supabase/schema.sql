-- Supabase schema for Invoice Creator: tables + row level security
-- Create Customers Catalog Table
CREATE TABLE IF NOT EXISTS public.customers (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  billing_address TEXT,
  email TEXT,
  phone TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create Services/Products Catalog Table
CREATE TABLE IF NOT EXISTS public.services (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  default_qty NUMERIC DEFAULT 1,
  default_unit TEXT DEFAULT 'Unit',
  default_cost NUMERIC NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create Invoices & Documents Table
CREATE TABLE IF NOT EXISTS public.invoices (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  invoice_number TEXT NOT NULL,
  customer_name TEXT NOT NULL,
  billing_address TEXT,
  issue_date TEXT,
  due_date TEXT,
  payment_terms TEXT,
  discount NUMERIC DEFAULT 0,
  tax_rate NUMERIC DEFAULT 0,
  notes TEXT,
  status TEXT DEFAULT 'draft',
  subtotal NUMERIC DEFAULT 0,
  tax_amount NUMERIC DEFAULT 0,
  total NUMERIC NOT NULL,
  items JSONB DEFAULT '[]'::jsonb,
  document_type TEXT DEFAULT 'invoice',
  dp_percentage NUMERIC DEFAULT 0,
  dp_paid_amount NUMERIC DEFAULT 0,
  payment_method TEXT DEFAULT 'transfer',
  customer_phone TEXT,
  customer_email TEXT,
  signature_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create Sender / Company Profile Table
CREATE TABLE IF NOT EXISTS public.sender_info (
  id TEXT PRIMARY KEY, -- Maps to user_id
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  company_name TEXT NOT NULL,
  address TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  bank_name TEXT,
  bank_account_name TEXT,
  bank_account_number TEXT,
  logo_url TEXT,
  signature_url TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS) policies
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sender_info ENABLE ROW LEVEL SECURITY;

-- Create Policies to isolate user-specific data
CREATE POLICY "Allow authenticated read/write for owners" ON public.customers 
  FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow authenticated read/write for owners" ON public.services 
  FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow authenticated read/write for owners" ON public.invoices 
  FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow authenticated read/write for owners" ON public.sender_info 
  FOR ALL TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);
