--In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string
--Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account
--Add a field for the Country Code (GB)
--Create IBAN: country code+check digits+bank code+sort code+ account number
--Fields to keep: transaction ID, IBAN
SELECT 
    t.transaction_id,
    CONCAT('GB',s.check_digits, s.swift_code, REPLACE(t.sort_code, '-', ''), t.account_number) AS IBAN
FROM PD2023_WK02_TRANSACTIONS as t
LEFT JOIN PD2023_WK02_SWIFT_CODES AS s ON s.bank=t.bank;
