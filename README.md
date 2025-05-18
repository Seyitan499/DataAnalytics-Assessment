---

## ✅ Assessment Breakdown

### 1. Customers with Funded Savings and Investment Accounts

**Approach:**

- Joined `savings_savingsaccount` with `plans_plan` and filtered by `confirmed_amount > 0` to identify funded accounts.
- Built two subqueries: one for funded savings, one for funded investments because of the way the output is expected to be.
- I Inner Joined the subqueries on `owner_id` to find customers with both account types.
- I used Count to get the total active accounts and summed deposits.
- I added customer details by joining with `users_customuser`.

**Challenges:**

- There was no explicit field for “funded”, i was expecting like a field for status type, but `confirmed_amount` was subtituted for that.
- I had a bit of confusion there with the count when i was doing some test but i realized some customers had multiple accounts under the same plan, leading to potential overcounting. I chose to count all funded accounts to reflect actual user activity.

---

### 2. Customer Transaction Frequency Categories

**Approach:**

- I used a nested subquery approach here because of the way the Finance team wants the report represented , i grouped confirmed transactions per customer by month using `DATE_FORMAT`.
- I counted monthly transactions and calculated each customer’s average.
- I used a `CASE` statement to categorize customers into:
  - **High Frequency:** ≥ 10/month
  - **Medium Frequency:** 5–9/month
  - **Low Frequency:** < 5/month
- I then aggregated the final results by category.

**Challenges:**

- Initially used a CTE (`WITH`) for better readability but I got into an error that had to do with compatibility.
- I rewrote the process using subqueries to ensure SQL engine compatibility and also  match the assessment instructions.

---

### 3. Inactive Accounts (No Inflow in 12+ Months)

**Approach:**

- I joined `savings_savingsaccount` with `plans_plan` to extract account types.
- I used `MAX(transaction_date)` to find the last activity date.
- Calculated inactivity in days with `DATEDIFF`.
- I grouped by `plan_id`, `owner_id`, and account type to handle scenarios of  multiple accounts.
- After my calculations I wrapped logic in a subquery to filter only users with inactivity > 365 days.

**Challenges:**

- I considered using `HAVING` but i chose a subquery for better expression reuse , readability and control over filtering .

---

### 4. Customer Lifetime Value (CLV) Estimation

**Approach:**

- I Joined `users_customuser` with `savings_savingsaccount` to gather transaction data.
- I Calculated:
  - `tenure_months` using `TIMESTAMPDIFF`.
  - `total_transactions` using `COUNT`.
  - `total_transaction_value` using `SUM(confirmed_amount)`.
- Applied the given formula:

  ```sql(this was gotten after a number of calculations has beeen done based off the data we have and embedding profit logic)
  CLV = ((total_transaction_value * 0.001) / tenure_months) * 12

**Challenges:**
I initially misapplied the formula by mixing up transaction count and values count for the calculation of the CLV , as well as the profit logic but i was able to balance accuracy with readability by embedding profit logic directly.
I handled division by zero by excluding 0-month tenures.

