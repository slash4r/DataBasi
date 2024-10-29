WITH ChannelRoyalties AS (
    SELECT
        dc.channel_id,
        ANY_VALUE(dc.channel_name) AS channel_name,
        SUM(r.amount) AS total_royalties
    FROM
        {{ ref('stg_distributionchannels') }} dc
        JOIN {{ ref('stg_royalties') }} r ON dc.channel_id = r.channel_id
    WHERE
        r.payment_date >= CURRENT_DATE - INTERVAL '1 YEAR'
    GROUP BY
        dc.channel_id
)
SELECT
    channel_name,
    total_royalties
FROM
    ChannelRoyalties
ORDER BY
    total_royalties DESC
