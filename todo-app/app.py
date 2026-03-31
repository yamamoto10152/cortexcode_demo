from flask import Flask, request, jsonify, render_template
import uuid

app = Flask(__name__)

todos = {}


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/healthcheck")
def healthcheck():
    return jsonify({"status": "ok"}), 200


@app.route("/api/todos", methods=["GET"])
def get_todos():
    return jsonify(list(todos.values()))


@app.route("/api/todos", methods=["POST"])
def create_todo():
    data = request.get_json()
    todo_id = str(uuid.uuid4())
    todo = {
        "id": todo_id,
        "title": data.get("title", ""),
        "done": False,
        "due_date": data.get("due_date", ""),
    }
    todos[todo_id] = todo
    return jsonify(todo), 201


@app.route("/api/todos/<todo_id>", methods=["PUT"])
def update_todo(todo_id):
    if todo_id not in todos:
        return jsonify({"error": "not found"}), 404
    data = request.get_json()
    todos[todo_id]["title"] = data.get("title", todos[todo_id]["title"])
    todos[todo_id]["done"] = data.get("done", todos[todo_id]["done"])
    todos[todo_id]["due_date"] = data.get("due_date", todos[todo_id]["due_date"])
    return jsonify(todos[todo_id])


@app.route("/api/todos/<todo_id>", methods=["DELETE"])
def delete_todo(todo_id):
    if todo_id not in todos:
        return jsonify({"error": "not found"}), 404
    deleted = todos.pop(todo_id)
    return jsonify(deleted)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
