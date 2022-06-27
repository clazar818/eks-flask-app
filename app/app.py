from flask import Flask
from flask_cors import CORS
import mysql.connector
import os

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    cnx = mysql.connector.connect(user=os.environ.get('mysql_username'), password=os.environ.get('mysql_password'),
                                  host=os.environ.get('mysql_host'))
    return "connected"
if __name__ == "__main__":
  app.run(host='0.0.0.0', port=80)
