from flask import Flask, request, jsonify

app = Flask(__name__)
todos = []


@app.route('/todos', methods=['GET'])
def get_todos():
    return jsonify(todos)


@app.route('/todos', methods=['POST'])
def add_todo():
    data = request.get_json()
    if 'task' in data:
        task = data['task']
        todos.append(task)
        return jsonify({"message": "Todo added successfully."})
    else:
        return jsonify({"error": "Invalid request data."}), 400


if __name__ == '__main__':
    app.run(debug=True)
