-- Create necessary indexes for better performance
CREATE INDEX idx_customers_birth_date ON customers(birth_date);
CREATE INDEX idx_accounts_customer_id ON accounts(customer_id);
CREATE INDEX idx_loans_customer_id ON loans(customer_id);
CREATE INDEX idx_payments_loan_id ON payments(loan_id);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_transaction_date ON transactions(transaction_date);

-- Optimized SELECT query using CTEs
# WITH filtered_customers AS (
#     -- Get active customers born after 1990 and having '@example.com' email addresses
#     SELECT
#         customer_id,
#         first_name,
#         last_name,
#         email
#     FROM
#         customers
#     WHERE
#         birth_date > '1990-01-01'
#         AND email LIKE '%@example.com'
# ),
# filtered_accounts AS (
#     -- Get accounts for the filtered customers
#     SELECT
#         account_id,
#         customer_id,
#         account_type,
#         balance
#     FROM
#         accounts
#     WHERE
#         balance > 0 -- Only active accounts with a positive balance
# ),
# filtered_loans AS (
#     -- Get loans for the filtered customers
#     SELECT
#         loan_id,
#         customer_id,
#         loan_amount,
#         loan_type
#     FROM
#         loans
# ),
# filtered_transactions AS (
#     -- Get recent transactions (from 2023 onward) for the filtered customers
#     SELECT
#         t.account_id,
#         t.transaction_type,
#         t.amount,
#         t.transaction_date
#     FROM
#         transactions t
#     JOIN filtered_accounts fa ON t.account_id = fa.account_id
#     WHERE
#         t.transaction_date >= '2023-01-01'
# )
# -- Now select the final data from the filtered tables
# SELECT
#     fc.first_name,
#     fc.last_name,
#     fc.email,
#     fa.account_type,
#     fa.balance,
#     fl.loan_amount,
#     fl.loan_type,
#     ft.transaction_type,
#     ft.amount AS transaction_amount,
#     ft.transaction_date
# FROM
#     filtered_customers fc
# JOIN filtered_accounts fa ON fc.customer_id = fa.customer_id
# LEFT JOIN filtered_loans fl ON fc.customer_id = fl.customer_id
# LEFT JOIN filtered_transactions ft ON fa.account_id = ft.account_id
# ORDER BY
#     ft.transaction_date DESC;
