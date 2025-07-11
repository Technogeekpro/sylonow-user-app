-- Create wallets table
CREATE TABLE IF NOT EXISTS wallets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    balance DECIMAL(10,2) DEFAULT 0.00 CHECK (balance >= 0),
    total_refunds DECIMAL(10,2) DEFAULT 0.00 CHECK (total_refunds >= 0),
    total_cashbacks DECIMAL(10,2) DEFAULT 0.00 CHECK (total_cashbacks >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Create wallet_transactions table
CREATE TABLE IF NOT EXISTS wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('refund', 'payment', 'cashback')),
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    description TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'failed')),
    order_id UUID,
    booking_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_wallets_updated_at
    BEFORE UPDATE ON wallets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_wallet_transactions_updated_at
    BEFORE UPDATE ON wallet_transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create function to update wallet balance
CREATE OR REPLACE FUNCTION update_wallet_balance(user_id UUID, amount DECIMAL)
RETURNS VOID AS $$
BEGIN
    -- Create wallet if it doesn't exist
    INSERT INTO wallets (user_id, balance, total_refunds, total_cashbacks)
    VALUES (user_id, 0, 0, 0)
    ON CONFLICT (user_id) DO NOTHING;
    
    -- Update wallet balance based on transaction type
    UPDATE wallets 
    SET balance = balance + amount,
        total_refunds = CASE 
            WHEN amount > 0 THEN total_refunds + amount 
            ELSE total_refunds 
        END,
        updated_at = NOW()
    WHERE wallets.user_id = update_wallet_balance.user_id;
END;
$$ LANGUAGE plpgsql;

-- Enable RLS
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallet_transactions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for wallets
CREATE POLICY "Users can view their own wallet"
    ON wallets FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own wallet"
    ON wallets FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own wallet"
    ON wallets FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- RLS Policies for wallet_transactions
CREATE POLICY "Users can view their own transactions"
    ON wallet_transactions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions"
    ON wallet_transactions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions"
    ON wallet_transactions FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Insert sample data for testing (optional)
-- Replace 'your-user-id' with an actual user ID from your auth.users table
/*
INSERT INTO wallets (user_id, balance, total_refunds, total_cashbacks)
VALUES ('your-user-id', 150.00, 150.00, 0.00)
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO wallet_transactions (user_id, type, amount, description, status)
VALUES 
    ('your-user-id', 'refund', 50.00, 'Refund for cancelled Birthday Decoration service', 'completed'),
    ('your-user-id', 'refund', 100.00, 'Refund for cancelled Wedding Decoration service', 'completed');
*/