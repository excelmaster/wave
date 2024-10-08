from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    try:
        return render_template("index.html")  # Renderiza index.html
    except Exception as e:
        return f"An error occurred: {str(e)}"

if __name__ == '__main__':
    app.run()