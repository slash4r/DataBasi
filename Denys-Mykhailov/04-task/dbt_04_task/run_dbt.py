from dotenv import load_dotenv
import subprocess

load_dotenv()

# Run dbt
# subprocess.run(["dbt", "test", "--models", "dbt_04_task"])
subprocess.run(["dbt", "test"])
