USE `task_03`;

-- Admin User (full access)
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'AdminPassword123!';
GRANT ALL PRIVILEGES ON task_03.* TO 'admin_user'@'localhost'; -- rwd

FLUSH PRIVILEGES;  -- Apply changes

-- 2. Create Artist User (can only see their own data)
-- This will restrict them to SELECT data related to their `artist_id`
-- In practice, `artist_id` would be handled by the application, passing it dynamically in queries
CREATE USER 'artist_user'@'localhost' IDENTIFIED BY 'ArtistPassword123!';
GRANT SELECT ON task_03.Artists TO 'artist_user'@'localhost';
GRANT SELECT ON task_03.Albums TO 'artist_user'@'localhost';
GRANT SELECT ON task_03.Tracks TO 'artist_user'@'localhost';
GRANT SELECT ON task_03.Royalties TO 'artist_user'@'localhost';

FLUSH PRIVILEGES;

-- 3. Create Channel User (can see and modify agreements and royalties related to their channel)
-- Assuming this user is for a specific channel (e.g., Spotify)
CREATE USER 'channel_user'@'localhost' IDENTIFIED BY 'ChannelPassword123!'; -- rw

-- Grant read and write (SELECT and UPDATE) access to the `Agreements` and `Royalties` tables
GRANT SELECT, UPDATE ON task_03.Agreements TO 'channel_user'@'localhost';
GRANT SELECT, UPDATE ON task_03.Royalties TO 'channel_user'@'localhost';

FLUSH PRIVILEGES;
