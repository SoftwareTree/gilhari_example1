> **Note:** This file is written in Markdown and is best viewed with a Markdown viewer (e.g., GitHub, GitLab, VS Code, or a dedicated Markdown reader). Viewing it in a plain text editor may not render the formatting as intended.

Copyright (c) 2025 Software Tree

# Gilhari Example1

> **Basic example demonstrating RESTful CRUD operations for JSON objects with Gilhari ORM**

Gilhari is a Docker-compatible microservice framework that provides RESTful Object-Relational Mapping (ORM) functionality for JSON objects with any relational database.

Remarkably, Gilhari automates REST APIs (POST, GET, PUT, DELETE, etc.) handling, JSON CRUD operations, and database schema setup — **no manual coding required**.

## About This Example

This repository contains a foundational example showing how to use Gilhari to create a RESTful microservice for persisting JSON objects with basic CRUD operations, filtering, and aggregate queries.

The example uses the base Gilhari docker image (softwaretree/gilhari) to easily create a new docker image (gilhari_example1) that can run as a RESTful microservice (server) to persist app specific JSON objects.

This example can be used **standalone as a RESTful microservice** or with the **ORMCP Server** for AI-powered database interactions. This example is particularly useful for getting started with ORMCP.

**Related:**
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs) - Uses this example as a reference implementation
- **ORMCP/Gilhari Examples**: [https://github.com/softwaretree/ormcp-docs#examples](https://github.com/softwaretree/ormcp-docs#examples) - Comprehensive list of examples

**Note:** This example is included in both the Gilhari SDK distribution and the ORMCP Server package. 
- **If you have the Gilhari SDK installed**, you can use it directly from the `examples/gilhari_example1` directory
- **If you have the ORMCP Server package installed**, this example is bundled in the distribution
- **If accessing from GitHub**, you'll need to clone this repository

## Example Overview

The example showcases a JSON object model with one type of object: **User**

**Object Model Overview:**
- **User**: Simple user object with basic demographic information
- **Attributes**: id (int), name (string), age (int), city (string), state (string)
- **Database Table**: USER

### User Object Structure
```json
{
  "id": 39,
  "name": "John39",
  "age": 39,
  "city": "San Francisco",
  "state": "CA"
}
```

**Features Demonstrated:**
- Basic CRUD operations (Create, Read, Update, Delete)
- Querying with filters (e.g., `age > 40`, `state='CA'`)
- Aggregate queries (COUNT, AVG)
- Batch operations (inserting multiple objects at once)
- Advanced projections using `operationDetails` parameter
- Object model introspection via `getObjectModelSummary` endpoint

## Project Structure

```
gilhari_example1/
├── src/                           # Container domain model classes
│   └── com/softwaretree/...      # User.java and base classes
├── config/                        # Configuration files
│   ├── gilhari_example1.jdx      # ORM specification
│   └── classnames_map_example.js
├── bin/                           # Compiled .class files
├── Dockerfile                     # Docker image definition
├── gilhari_service.config         # Service configuration
├── compile.cmd / .sh              # Compilation scripts
├── build.cmd / .sh                # Docker build scripts
├── run_docker_app.cmd / .sh       # Docker run scripts
├── curlCommands.cmd / .sh         # API testing scripts
└── curlCommandsPopulate.cmd / .sh # Sample data population scripts
```

## Source Code
The `src` directory contains the declarations of the underlying shell (container) classes (e.g., User) that are used to define the object-relational mapping (ORM) specification for the corresponding conceptual domain-specific JSON object model classes:

- **User class**: Simple shell (container) class (.java file) corresponding to the domain-specific JSON object model class (Container domain model class)
- **JDX_JSONObject**: Base class of the container domain model classes for handling persistence of domain-specific JSON objects
- **Container domain model classes**: Only need to define two constructors, with most processing handled by the JDX_JSONObject superclass

**Note:** Gilhari does not require any explicit programmatic definitions (e.g., ES6 style JavaScript classes) for domain-specific JSON object model classes. It handles the data of domain-specific JSON objects using instances of the container domain model classes and the ORM specification.

## Configurations

A declarative ORM specification for the domain-specific JSON object model classes and their attributes is defined in `config/gilhari_example1.jdx` using the container domain model classes. This file defines the mappings between JSON objects and database tables.

**Key points:**
- Update the database URL and JDBC driver in this file according to your setup
- See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide` (.md or .html) for guides on configuring different databases
- The container domain model class (User) corresponding to the conceptual domain-specific JSON object model class is defined as a subclass of the JDX_JSONObject class
- Appropriate mappings for the domain-specific JSON object model class are defined in the ORM specification file using the corresponding container domain model class
- The .jdx file includes commented examples showing how to enable auto-increment IDs if desired

For comprehensive details on defining and using container classes and the ORM specification for JSON object models, refer to the **"Persisting JSON Objects"** section in the JDX User Manual.

### Docker Configuration

The `Dockerfile` builds a RESTful Gilhari microservice using:
- Base Gilhari image (softwaretree/gilhari)
- Compiled domain model (.class) files
- Configuration files including the ORM specification and a JDBC driver

### Service Configuration

The `gilhari_service.config` file specifies runtime parameters for the RESTful Gilhari microservice:

```json
{
  "gilhari_microservice_name": "gilhari_example1",
  "jdx_orm_spec_file": "./config/gilhari_example1.jdx",
  "jdbc_driver_path": "/node/node_modules/jdxnode/external_libs/sqlite-jdbc-3.50.3.0.jar",
  "jdx_debug_level": 3,
  "jdx_force_create_schema": "true",
  "jdx_persistent_classes_location": "./bin",
  "classnames_map_file": "config/classnames_map_example.js",
  "gilhari_rest_server_port": 8081
}
```

#### Service Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `gilhari_microservice_name` | Optional name to identify this Gilhari microservice. The name is logged on console during start up | - |
| `jdx_orm_spec_file` | Location of the ORM specification file containing mapping for persistent classes | - |
| `jdbc_driver_path` | Path to the JDBC driver (.jar) file. SQLite driver included by default | - |
| `jdx_debug_level` | Debug output level (0-5). 0 = most verbose, 5 = minimal. Level 3 outputs all SQL statements | 5 |
| `jdx_force_create_schema` | Whether to recreate database schema on each run. `true` = useful for development, `false` = create only once | false |
| `jdx_persistent_classes_location` | Root location for compiled persistent (Container domain model) classes. Can be a directory (e.g., ./bin) or a JAR file path. Used as a Java CLASSPATH  | - |
| `classnames_map_file` | Optional JSON file that can map names of container domain model classes to (simpler) object class (type) names (e.g., by omitting a package name) to simplify REST URL| - |
| `gilhari_rest_server_port` | Port number for the RESTful service. This port number may be mapped to different port number (e.g., 80) by a docker run command. | 8081 |


## Build Files
- `compile.cmd` / `compile.sh`: Compiles the container domain model classes
- `sources.txt`: Lists the names of the container domain model class source (.java) files for compilation
- `build.cmd` / `build.sh`: Creates the Gilhari Docker image (gilhari_example1) using the local Dockerfile

**Note**: Compilation targets JDK version 1.8, which is compatible with the current Gilhari version.

## Quick Start

### For Quick Evaluation (No SDK Required)

**IMPORTANT:** Docker is required for building and running a Gilhari microservice — **[Get Docker](https://docs.docker.com/get-docker/)** if not already installed on your machine

If you just want to see this example in action without modifications:

1. **Clone this repository** (pre-compiled classes included)
2. **Install Docker** (skip, if already installed)
3. **Build and run** (skip compilation step)

### For Development and Customization
If you want to modify the object model or create your own Gilhari microservices:

1. **Gilhari SDK**: Download and install from [https://softwaretree.com](https://softwaretree.com)
2. **JX_HOME environment variable**: Set to the root directory of your Gilhari SDK installation
3. **Java Development Kit (JDK 1.8+)** for compilation
4. **Docker** installed on your system

**Note:** The Gilhari SDK contains necessary libraries (JARs) and base classes required for compiling container domain model classes. While pre-compiled `.class` files are included in this repository for immediate use, you'll need the SDK to make any modifications to the object model or to create your own Gilhari microservices.

## Build and Run

### Option 1: Quick Run (Using Pre-compiled Classes)

**Skip compilation** and go straight to Docker:

```bash
# Windows
build.cmd
run_docker_app.cmd

# Linux/Mac
./build.sh
./run_docker_app.sh
```

### Option 2: Compile and Run (For Modifications)

**If you've made changes to the source code:**

1. **Ensure JX_HOME is set** to your Gilhari SDK installation directory

2. **Compile the classes**:
   ```bash
   # Windows
   compile.cmd
   
   # Linux/Mac
   ./compile.sh
   ```

3. **Build and run the Docker container**:
   ```bash
   # Windows
   build.cmd
   run_docker_app.cmd
   
   # Linux/Mac
   ./build.sh
   ./run_docker_app.sh
   ```

## REST API Usage

Once running, access the Gilhari microservice at:

```
http://localhost:<port>/gilhari/v1/:className
```

**Example endpoints:**
```
http://localhost:80/gilhari/v1/User
http://localhost:80/gilhari/v1/getObjectModelSummary/now
```

### Supported HTTP Methods

| Method | Purpose | Example |
|--------|---------|---------|
| GET | Retrieve objects | `GET /gilhari/v1/User` |
| POST | Create objects | `POST /gilhari/v1/User` |
| PUT | Update objects | `PUT /gilhari/v1/User` |
| PATCH | Partial update | `PATCH /gilhari/v1/User` |
| DELETE | Delete objects | `DELETE /gilhari/v1/User` |

### Example Operations

**Get Object Model Summary:**
```bash
curl -X GET "http://localhost:80/gilhari/v1/getObjectModelSummary/now"
```

**Create a User:**
```bash
curl -X POST http://localhost:80/gilhari/v1/User \
  -H "Content-Type: application/json" \
  -d '{
    "entity": {
      "id": 39,
      "name": "John39",
      "age": 39,
      "city": "San Francisco",
      "state": "CA"
    }
  }'
```

**Create Multiple Users:**
```bash
curl -X POST http://localhost:80/gilhari/v1/User \
  -H "Content-Type: application/json" \
  -d '{
    "entity": [
      {
        "id": 40,
        "name": "Mike40",
        "age": 40,
        "city": "New York",
        "state": "NY"
      },
      {
        "id": 41,
        "name": "Mary41",
        "age": 41,
        "city": "Austin",
        "state": "TX"
      }
    ]
  }'
```

**Query with Filter:**
```bash
curl -X GET "http://localhost:80/gilhari/v1/User?filter=age>40" \
  -H "Content-Type: application/json"
```

**Count Users in California:**
```bash
curl -X GET "http://localhost:80/gilhari/v1/User/getAggregate?attribute=id&aggregateType=COUNT&filter=state='CA'" \
  -H "Content-Type: application/json"
```

**Average Age (California Users):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/User/getAggregate?attribute=age&aggregateType=AVG&filter=state='CA'" \
  -H "Content-Type: application/json"
```

**Query with Projections (Selected Attributes Only):**
```bash
curl -G "http://localhost:80/gilhari/v1/User" \
  --data-urlencode "filter=state='CA'" \
  --data-urlencode 'operationDetails=[{"opType": "projections", "projectionsDetails": [{"type": "User", "attribs": ["id", "name", "city"]}]}]' \
  -H "Content-Type: application/json"
```

**Delete Users with Filter:**
```bash
curl -X DELETE "http://localhost:80/gilhari/v1/User?filter=age>40"
```

### Testing the API

**Comprehensive test scripts:**

1. **curlCommands.cmd / .sh** - Complete demonstration of CRUD operations

   Demonstrates:
   - Getting object model summary
   - Creating single and multiple User objects
   - Querying with filters
   - Aggregate operations (COUNT, AVG)
   - Filtered deletion
   - Complete cleanup

2. **curlCommandsPopulate.cmd / .sh** - Data population with advanced queries

   Demonstrates:
   - Populating sample User data across multiple states
   - Advanced filtering (`age>=55`)
   - Aggregate queries for specific groups
   - **Projections** using `operationDetails` parameter for selecting specific attributes

Run the scripts to generate a `curl.log` file with all responses:
```bash
# Windows
curlCommands.cmd
curlCommandsPopulate.cmd

# Linux/Mac
chmod +x curlCommands.sh curlCommandsPopulate.sh
./curlCommands.sh
./curlCommandsPopulate.sh

# Custom port
curlCommands.cmd 8899
curlCommandsPopulate.sh 8899
```

The scripts will create a `curl.log` file with all the API responses, demonstrating User object management with the Gilhari microservice. The populate script also demonstrates how queries for only a selected set of attributes can easily be done using the **projections** operation type with the **operationDetails** parameter.

**Note:** The **`operationDetails`** parameter in a query allows you to fine-tune query operations with operational directives similar to **GraphQL** capabilities. It accepts a JSON array containing one or more operation directives that refine the shape and scope of returned objects. For more details, see `operationDetails_doc.md`.

**Other options:**
- **Postman**: Import the endpoints for interactive testing
- **Browser**: Access GET endpoints directly
- **Any REST Client**: Standard HTTP methods work with any REST client
- **ORMCP Server**: Use ORMCP Server tools for AI-powered interactions

## Using with ORMCP Server

This Gilhari microservice is designed to work seamlessly with the ORMCP Server for AI-powered database interactions:

1. **Start this Gilhari microservice** (as shown in Quick Start)
2. **Configure ORMCP Server** to connect to this microservice endpoint
3. **Use natural language** to query and manipulate User objects through the ORMCP Server

The ORMCP Server uses this example as a reference implementation and can automatically discover the object model via the `getObjectModelSummary` endpoint.

**Example ORMCP interactions:**
- "Show me all users in California"
- "What's the average age of users in New York?"
- "Add a new user named Alice aged 35 in Boston, MA"
- "Delete all users older than 50"

For more information on ORMCP Server:
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **ORMCP/Gilhari Examples**: [https://github.com/softwaretree/ormcp-docs#examples](https://github.com/softwaretree/ormcp-docs#examples)
- **Product Website**: [https://www.softwaretree.com/products/ormcp/](https://www.softwaretree.com/products/ormcp/)

## Development Tools

### Docker Container Access
Shell into a running container:
```bash
# Find container ID
docker ps

# Access container
docker exec -it <container-id> bash
```

### View Logs
```bash
docker logs <container-id>
```

### Stop Container
```bash
docker stop <container-id>
```

## Additional Resources

- **JDX User Manual**: "Persisting JSON Objects" section for detailed ORM specification documentation
- **Gilhari SDK Documentation**: The SDK available for download at [https://softwaretree.com](https://softwaretree.com)
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **Database Configuration Guide**: See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide.md`
- **operationDetails Documentation**: See `operationDetails_doc.md` for GraphQL-like query capabilities

## Platform Notes

Script files are provided for both Windows (`.cmd`) and Linux/Mac (`.sh`). 

**Linux/Mac users**: Make scripts executable before running:
```bash
chmod +x *.sh
```

## Troubleshooting

### Common Issues

**Problem**: Docker image build fails
- **Solution**: Ensure the base Gilhari image is pulled: `docker pull softwaretree/gilhari`

**Problem**: Compilation errors
- **Solution**: Verify JDK 1.8+ is installed and JX_HOME environment variable is set correctly

**Problem**: Port 80 already in use
- **Solution**: Modify `run_docker_app` script to use a different port (e.g., `-p 8080:8081`)

**Problem**: Database connection errors
- **Solution**: Check `config/gilhari_example1.jdx` for correct database URL and JDBC driver path

**Problem**: ORMCP Server cannot connect to the microservice
- **Solution**: Ensure the microservice is running and accessible at the configured endpoint. Verify the `getObjectModelSummary` endpoint is reachable

**Problem**: Projections not working in queries
- **Solution**: Ensure the `operationDetails` parameter is properly URL-encoded. Use `--data-urlencode` with curl or proper encoding in your HTTP client

## Support

For issues or questions:
- **ORMCP Documentation & Issues**: [https://github.com/softwaretree/ormcp-docs/issues](https://github.com/softwaretree/ormcp-docs/issues)
- **This example**: [https://github.com/SoftwareTree/gilhari_example1/issues](https://github.com/SoftwareTree/gilhari_example1/issues)
- **Gilhari SDK**: Contact support at [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com)

## License

This example code is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Important:** This license applies ONLY to the example code in this repository. The Gilhari software (including the softwaretree/gilhari Docker image and Gilhari SDK) and the embedded JDX ORM software are proprietary products owned by Software Tree.

The Gilhari Docker image includes an evaluation license for testing purposes. For production use or licensing beyond the evaluation period, please visit [https://www.softwaretree.com](https://www.softwaretree.com) or contact [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com).

---

**Ready to try it?** Start with the [Quick Start](#quick-start) section above!