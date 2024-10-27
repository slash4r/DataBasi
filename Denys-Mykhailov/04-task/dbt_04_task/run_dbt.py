from dotenv import load_dotenv
import subprocess

load_dotenv()

# Run dbt
subprocess.run(["dbt", "run", "--models", "raw"])
