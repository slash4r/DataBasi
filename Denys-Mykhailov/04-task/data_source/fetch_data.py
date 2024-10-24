import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Connection settings
HOST = os.getenv('HOST')
USER = os.getenv('USER')
PASSWORD = os.getenv('PASSWORD2')
DATABASE = os.getenv('DATABASE')


# Create SQLAlchemy engine
print(f'mysql+mysqldb://{USER}:{PASSWORD}@{HOST}/{DATABASE}')
engine = create_engine(f'mysql+mysqldb://{USER}:{PASSWORD}@{HOST}/{DATABASE}')

# List of tables to export
tables = ['albums', 'artists', 'royalties', 'tracks', 'tracks_artists']

for table in tables:
    # Fetch data from each table
    df = pd.read_sql(f"SELECT * FROM {table}", con=engine)

    # Save to CSV
    df.to_csv(f'C:\\_GitHub\\_DataBasiGit\\Denys-Mykhailov\\04-task\\dbt_04_task\\models\\raw\\{table}.csv',
              index=False)

# The connection is automatically handled by SQLAlchemy, no need to close it manually
# connection.close()