from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Flask via Gunicorn and Nginx!"

if __name__ == '__main__':
    app.run()