# Video

TBD

# Message history

## 1. Alex

implement the whole api with the crud operations based on the api specification:

```
openapi: 3.0.0 info: title: To-Do Task Management API version: 1.0.0 description: | A simple API for managing to-do tasks. Supports full CRUD operations for tasks in a single-user context. paths: /tasks: get: summary: List all tasks description: Retrieve a list of all tasks, with optional filtering by completion status and due date. parameters: - in: query name: completed schema: type: boolean description: Filter tasks by completion status (true or false) - in: query name: dueDate schema: type: string format: date description: Filter tasks by due date (YYYY-MM-DD) responses: '200': description: A list of tasks content: application/json: schema: type: array items: $ref: '#/components/schemas/Task' post: summary: Create a new task description: Add a new task to the to-do list. requestBody: required: true content: application/json: schema: $ref: '#/components/schemas/TaskInput' responses: '201': description: Task created successfully content: application/json: schema: $ref: '#/components/schemas/Task' /tasks/{taskId}: get: summary: Get a task by ID description: Retrieve a specific task by its unique ID. parameters: - in: path name: taskId required: true schema: type: string responses: '200': description: Task details content: application/json: schema: $ref: '#/components/schemas/Task' '404': description: Task not found put: summary: Update a task description: Update an existing task by its ID. parameters: - in: path name: taskId required: true schema: type: string requestBody: required: true content: application/json: schema: $ref: '#/components/schemas/TaskInput' responses: '200': description: Task updated successfully content: application/json: schema: $ref: '#/components/schemas/Task' '404': description: Task not found delete: summary: Delete a task description: Remove a task from the list by its ID. parameters: - in: path name: taskId required: true schema: type: string responses: '204': description: Task deleted successfully '404': description: Task not found components: schemas: Task: type: object properties: id: type: string example: "1" title: type: string example: Buy groceries description: type: string example: Milk, Bread, Eggs dueDate: type: string format: date example: 2024-06-15 completed: type: boolean default: false example: false required: - id - title - completed TaskInput: type: object properties: title: type: string example: Buy groceries description: type: string example: Milk, Bread, Eggs dueDate: type: string format: date example: 2024-06-15 completed: type: boolean default: false example: false required: - title - completed
```

the flows have already been scaffolded into the main xml file. dont change these. just add flow references from the main file's flows to the subflows with the actual logic.

that said, create a different XML file for each of the 5 subflows: 
1. get all tasks
2. create a new task
3. get a task by id
4. update a task by id
5. delete a task by id

the data is saved in a mysql database with the following details:

```properties
host: 127.0.0.1
port: 3306
MYSQL_DATABASE: mysqldb
MYSQL_USER: user
MYSQL_PASSWORD: password
```

the mysql table is set up like this:

```sql
CREATE TABLE tasks(
id int NOT NULL PRIMARY KEY AUTO_INCREMENT, title VARCHAR(255) NOT NULL, description VARCHAR(255), dueDate VARCHAR(255), completed BOOLEAN NOT NULL );
```

when you create a task, the id in the db will be automatically incremented for a new record, but note that the id in the db is a number and our api spec is a string so you have to make sure to transform this data in the code.

make sure to follow best practices and secure the needed properties

- All the global element configurations have to go inside a `global.xml` file unless a different name is provided for this file.
- Properties like `host` and `port` should not be hardcoded in the XML files. These values should be referenced from (a) properties file(s).
- Whenever a Mule Runtime version is added to the `pom.xml` file, this version has to match the version from the `mule-artifact.json` file (located at the root directory).
- Always make sure the properties files added to the project are being correctly configured with a Configuration Properties global element.
- When adding dependencies to the `pom.xml`, ensure the version is compatible with the Mule Runtime version specified in `mule-artifact.json` file (located at the root directory) AND is compatible with the Java version specified in the same file.
- Always verify connector compatibility by checking the official MuleSoft documentation at https://docs.mulesoft.com/release-notes/connector/anypoint-connector-release-notes before adding or updating dependencies.
- When determining the latest compatible version of a connector, always check the MuleSoft Maven repository (https://repository.mulesoft.org/releases/) to find the actual latest available version. Do not assume version numbers or make up version numbers.
- Configuration properties should be stored in YAML files with the naming convention `{env}-properties.yaml` (e.g., `local-properties.yaml`, `dev-properties.yaml`).
- The configuration-properties module must be added to the `pom.xml` with the correct version that matches the Mule Runtime version.
- The configuration properties element in `global.xml` should use the format `<configuration-properties file="${env}-properties.yaml" doc:name="Configuration properties"/>`.
- The environment variable (`env`) should be set as a global property in `global.xml` with a default value (e.g., `<global-property name="env" value="local" doc:name="Environment"/>`).
- All values in YAML properties files should be strings, including numeric values. For example, use `port: "8081"` instead of `port: 8081`.
- The `.gitignore` file must include entries for IDE-specific files (e.g., `.vscode/`) and test resources (e.g., `src/test/resources/embedded*`) to prevent them from being committed to the repository. 
- NEVER hardcode credentials in the XML files.
- NEVER commit credentials.

## 2. Curie

_Creates PR: https://github.com/alexandramartinez/todo-task-management-impl/pull/1_