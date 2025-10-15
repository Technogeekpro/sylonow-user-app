-- Create user wallet transactions table
CREATE TABLE IF NOT EXISTS user_wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('refund', 'payment', 'cashback')),
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'failed')),
    description TEXT,
    reference_id UUID,
    reference_type VARCHAR(50),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Create updated_at trigger function if it doesn't exist
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create updated_at trigger for user wallet transactions
CREATE TRIGGER update_user_wallet_transactions_updated_at
    BEFORE UPDATE ON user_wallet_transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE user_wallet_transactions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_wallet_transactions
CREATE POLICY "Users can view their own wallet transactions"
    ON user_wallet_transactions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own wallet transactions"
    ON user_wallet_transactions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own wallet transactions"
    ON user_wallet_transactions FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Insert some sample data for testing (replace with your actual user ID)
-- You can get your user ID from auth.users table
INSERT INTO user_wallet_transactions (user_id, transaction_type, amount, status, description, reference_type)
SELECT 
    id,
    'refund',
    50.00,
    'completed',
    'Refund for cancelled Birthday Decoration service',
    'booking'
FROM auth.users 
WHERE email IS NOT NULL 
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO user_wallet_transactions (user_id, transaction_type, amount, status, description, reference_type)
SELECT 
    id,
    'cashback',
    25.00,
    'completed',
    'Cashback for completing first booking',
    'booking'
FROM auth.users 
WHERE email IS NOT NULL 
LIMIT 1
ON CONFLICT DO NOTHING;

-- Update wallet balance for the user
INSERT INTO wallets (user_id, balance, total_refunds, total_cashbacks)
SELECT 
    id,
    75.00,
    50.00,
    25.00
FROM auth.users 
WHERE email IS NOT NULL 
LIMIT 1
ON CONFLICT (user_id) DO UPDATE SET
    balance = EXCLUDED.balance,
    total_refunds = EXCLUDED.total_refunds,
    total_cashbacks = EXCLUDED.total_cashbacks;