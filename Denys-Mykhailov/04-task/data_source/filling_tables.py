import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv
from faker import Faker
import random

# Load environment variables
load_dotenv()

# Connection settings
HOST = os.getenv('HOST')
USER = os.getenv('USER')
PASSWORD = os.getenv('PASSWORD')
DATABASE = os.getenv('DATABASE')

# Set the volume globally based on user input
volume = int(input("Enter the number of records to insert (e.g., number of users, artists, etc.): "))


def log_error(text: str) -> None:
    # print in red color
    print(f"\033[91m{text}\033[0m")


def log_success(text: str) -> None:
    # print in green color
    print(f"\033[92m{text}\033[0m")


def create_connection():
    """Create a database connection."""
    try:
        connection = mysql.connector.connect(
            host=HOST,
            user=USER,
            password=PASSWORD,
            database=DATABASE
        )
        if connection.is_connected():
            print("Connection to MySQL DB successful")
        return connection
    except Error as e:
        print(f"The error '{e}' occurred")
        return None


def execute_query(connection, query, data=None, retries=3):
    """Execute a single query and return cursor for fetching lastrowid."""
    cursor = connection.cursor()
    try:
        if data:
            cursor.execute(query, data)
        else:
            cursor.execute(query)
        connection.commit()
        # print("Query executed successfully")
        return cursor
    except mysql.connector.IntegrityError as e:
        if "1062" in str(e) and retries > 0:
            return None
        else:
            print(f"Integrity Error: {e}")
            return None
    except Error as e:
        print(f"The error '{e}' occurred")
    return None


def insert_data():
    connection = create_connection()
    if connection is None:
        raise Exception
    log_success(DATABASE)
    fake = Faker()

    genres = ['Pop', 'Rock', 'Jazz', 'Classical', 'Electronic', 'Hip-Hop', 'Rap', 'Reggae', 'Country', 'Blues', 'Folk',
              'Metal', 'Punk']
    for genre in genres:
        genre_query = "INSERT INTO Genres (name) VALUES (%s)"
        execute_query(connection, genre_query, (genre,))

    print("Genres inserted successfully")

    channels = [('YouTube Music', 'https://music.youtube.com/'),
                ('Spotify', 'https://www.spotify.com/'),
                ('Apple Music', 'https://www.apple.com/music/'),
                ('Amazon Music', 'https://music.amazon.com/'),
                ('SoundCloud', 'https://soundcloud.com/'),
                ('Deezer', 'https://www.deezer.com/'),
                ('Tidal', 'https://tidal.com/'),
                ('VK Music', 'https://vk.com/music'),
                ('Yandex Music', 'https://music.yandex.com/'),
                ('Zaycev.net', 'https://zaycev.net/'),
                ('Pandora', 'https://www.pandora.com/'),
                ('Google Play Music', 'https://play.google.com/music/'),
                ('Napster', 'https://us.napster.com/'),
                ('iHeartRadio', 'https://www.iheart.com/')]
    for name, website in channels:
        channel_query = "INSERT INTO DistributionChannels (name, website) VALUES (%s, %s)"
        execute_query(connection, channel_query, (name, website))

    print("Channels inserted successfully")

    # Users and Artists
    artist_ids = []
    for _ in range(volume):  # Use the volume variable for the number of records
        user_email = fake.email()
        user_query = "INSERT INTO Users (email, artist_id) VALUES (%s, %s)"
        user_cursor = None

        # Retry logic for email generation in case of duplicates
        for i in range(3):  # Try 3 different emails before giving up
            user_cursor = execute_query(connection, user_query, (user_email, 0))
            if user_cursor:  # If insert was successful, break out of the retry loop
                break
            # print(f"Duplicate {user_email} detected. Generating a {i + 2}'th email...")
            user_email = fake.email()  # Generate a new email if there's a duplicate

        if user_cursor is None:
            log_error(f"Failed to insert user after multiple attempts.")
            continue

        user_id = user_cursor.lastrowid  # Get the last inserted user ID

        artist_query = "INSERT INTO Artists (name, bio, country, profile_picture, user_id) VALUES (%s, %s, %s, %s, %s)"
        artist_data = (
            fake.name(),
            fake.text(),
            fake.country(),
            fake.binary(length=2048),
            user_id
        )
        artist_cursor = execute_query(connection, artist_query, artist_data)
        if artist_cursor:
            artist_id = artist_cursor.lastrowid  # Get the last inserted artist ID
            artist_ids.append(artist_id)

            # Update user with artist_id
            execute_query(connection, "UPDATE Users SET artist_id=%s WHERE user_id=%s", (artist_id, user_id))

    print("Users and Artists inserted successfully")

    # Albums
    album_ids = []
    for artist_id in artist_ids:
        for _ in range(random.randint(1, 3)):
            album_query = "INSERT INTO Albums (title, release_date, artist_id) VALUES (%s, %s, %s)"
            album_data = (
                fake.sentence(nb_words=5),
                fake.date_between(start_date='-10y', end_date='today'),
                artist_id
            )
            album_cursor = execute_query(connection, album_query, album_data)
            if album_cursor:
                album_ids.append(album_cursor.lastrowid)

    print("Albums inserted successfully")

    # Tracks
    track_ids = []
    for album_id in album_ids:
        # Randomly generate from 1 to 5 tracks per album
        for _ in range(random.randint(1, 5)):
            genre_id = random.randint(1, len(genres))
            track_query = "INSERT INTO Tracks (title, duration_sec, lyrics, album_id, genre_id, status) VALUES (%s, %s, %s, %s, %s, %s)"
            track_data = (
                fake.sentence(nb_words=3),
                random.randint(180, 360),
                fake.text(),
                album_id,
                genre_id,
                random.choice(['pending', 'active', 'inactive'])
            )
            track_cursor = execute_query(connection, track_query, track_data)
            if track_cursor:
                track_ids.append(track_cursor.lastrowid)

    print("Tracks inserted successfully")

    # Agreements
    # Randomly pick 80% from all the artists
    for artist_id in random.sample(artist_ids, int(0.8 * len(artist_ids))):
        channel_id = random.randint(1, len(channels))
        agreement_query = "INSERT INTO Agreements (artist_id, channel_id, agreement_date, terms) VALUES (%s, %s, %s, %s)"
        agreement_data = (
            artist_id,
            channel_id,
            fake.date_between(start_date='-5y', end_date='today'),
            fake.binary(length=1024)
        )
        execute_query(connection, agreement_query, agreement_data)

    print("Agreements inserted successfully")

    # Royalties
    for track_id in track_ids:
        for _ in range(random.randint(1, 3)):
            artist_id = random.choice(artist_ids)
            channel_id = random.randint(1, len(channels))
            royalty_query = "INSERT INTO Royalties (amount, payment_date, artist_id, track_id, channel_id) VALUES (%s, %s, %s, %s, %s)"
            royalty_data = (
                random.randint(500, 5000),
                fake.date_between(start_date='-3y', end_date='today'),
                artist_id,
                track_id,
                channel_id
            )
            execute_query(connection, royalty_query, royalty_data)

    print("Royalties inserted successfully")

    # Extra filling Tracks_Artists with random "track-artist" pairs
    for track_id in track_ids:
        # Add between 0 and 2 additional artists for some tracks
        additional_artists = random.sample(artist_ids, random.randint(0, 2))
        for artist_id in additional_artists:
            # Insert the track-artist pair
            track_artist_query = "INSERT INTO Tracks_Artists (track_id, artist_id) VALUES (%s, %s)"
            track_artist_data = (track_id, artist_id)
            execute_query(connection, track_artist_query, track_artist_data)

    # Fill Tracks_Channels with random track-channel pairs
    for track_id in track_ids:
        # Randomly assign the track to 2-4 different distribution channels
        assigned_channels = random.sample(range(1, len(channels) + 1), random.randint(2, 4))
        for channel_id in assigned_channels:
            track_channel_query = "INSERT INTO Tracks_Channels (track_id, channel_id) VALUES (%s, %s)"
            track_channel_data = (track_id, channel_id)
            execute_query(connection, track_channel_query, track_channel_data)

    print("Extra filling Tracks_Artists and Tracks_Channels completed successfully")

    connection.close()


if __name__ == "__main__":
    try:
        insert_data()
    except Exception:
        log_error("ERROR!")
    log_success("All data inserted successfully!")