SELECT
    amount,
    CAST(payment_date as DATE) as payment_date,  -- Ensure that the payment date is in the correct format
    artist_id,
    track_id,
    channel_id
FROM {{ ref('raw_royalties') }}
WHERE amount IS NOT NULL
