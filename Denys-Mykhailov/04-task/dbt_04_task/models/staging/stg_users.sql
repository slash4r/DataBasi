SELECT
    user_id,
    LOWER(email) AS email,  -- Standardize email case
    artist_id
FROM {{ ref('raw_users') }}
WHERE email IS NOT NULL  -- Remove any rows with missing emails
