USE `task_04`;

-- `Users` table
-- The `user_id` is already the primary key
-- The `artist_id` column should be indexed for foreign key lookups
CREATE INDEX idx_users_artist_id ON Users (artist_id);
-- The `email` column is  unique and likely used in searches, so it should be indexed
CREATE INDEX idx_users_email ON Users (email);

-- `Artists` table
-- The `artist_id` is already the primary key
-- The `user_id` is a foreign key, so it should be indexed
CREATE INDEX idx_artists_user_id ON Artists (user_id);
-- The 'country' column is likely used in searches or grouping, so it should be indexed
CREATE INDEX idx_artists_country ON Artists (country);

-- `Albums` table
-- The `album_id` is already the primary key
-- The `artist_id` is a foreign key and used in queries, so it should be indexed
CREATE INDEX idx_albums_artist_id ON Albums (artist_id);
-- The 'release_date' column is date type and likely used in searches or ordering, so it should be indexed
CREATE INDEX idx_albums_release_date ON Albums (release_date);

-- `Tracks` table
-- The `track_id` is already the primary key
-- The `album_id` and `genre_id` are foreign keys and likely used in joins, so they should be indexed
CREATE INDEX idx_tracks_album_id ON Tracks (album_id);
CREATE INDEX idx_tracks_genre_id ON Tracks (genre_id);

-- `Agreements` table
-- The `agreement_id` is already the primary key
-- The `artist_id` and `channel_id` are foreign keys, so they should be indexed for joins
CREATE INDEX idx_agreements_artist_id ON Agreements (artist_id);
CREATE INDEX idx_agreements_channel_id ON Agreements (channel_id);
-- The `agreement_date` column has a date type and likely used in searches or ordering, so it should be indexed
CREATE INDEX idx_agreements_agreement_date ON Agreements (agreement_date);

-- `Tracks_Channels` table (many-to-many relationship)
-- The `PRIMARY KEY (track_id, channel_id)` automatically creates a composite index on both columns
-- No further indexes are necessary

-- Adding indexes for `Tracks_Artists` table (many-to-many relationship)
-- The `PRIMARY KEY (track_id, artist_id)` automatically creates a composite index on both columns
-- No further indexes are necessary

-- `Royalties` table
-- The `payment_id` is already the primary key
-- The `artist_id`, `track_id`, and `channel_id` are foreign keys, so they should be indexed
CREATE INDEX idx_royalties_artist_id ON Royalties (artist_id);
CREATE INDEX idx_royalties_track_id ON Royalties (track_id);
CREATE INDEX idx_royalties_channel_id ON Royalties (channel_id);
-- The `payment_date` column has a date type and likely used in searches or ordering, so it should be indexed
CREATE INDEX idx_royalties_payment_date ON Royalties (payment_date);
