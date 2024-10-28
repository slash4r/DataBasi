SELECT
    channel_id,
    name AS channel_name
FROM {{ ref('raw_distributionchannels') }}
WHERE name IS NOT NULL  -- Ensure that each channel has a name