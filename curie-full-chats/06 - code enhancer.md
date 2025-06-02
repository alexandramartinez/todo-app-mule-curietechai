# Video

TBD

# Message history

## 1. Alex

Use Parameterized Queries

Why:

Directly injecting values into SQL is error-prone and can lead to SQL injection vulnerabilities. The DB connector expects parameters to be bound using the :paramName syntax.

How to fix:

Build both the SQL and the parameters map together in DataWeave.
Pass the parameters map to <db:input-parameters> in the DB connector.

## 2. Curie

_Returns code changes_

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mule xmlns="http://www.mulesoft.org/schema/mule/core"
      xmlns:doc="http://www.mulesoft.org/schema/mule/documentation"
      xmlns:db="http://www.mulesoft.org/schema/mule/db"
      xmlns:ee="http://www.mulesoft.org/schema/mule/ee/core"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.mulesoft.org/schema/mule/core http://www.mulesoft.org/schema/mule/core/current/mule.xsd
                          http://www.mulesoft.org/schema/mule/db http://www.mulesoft.org/schema/mule/db/current/mule-db.xsd
                          http://www.mulesoft.org/schema/mule/ee/core http://www.mulesoft.org/schema/mule/ee/core/current/mule-ee.xsd">

    <sub-flow name="get-all-tasks-flow" doc:id="6fdbaf16-63a8-4a6f-838f-802efd09e317">
        <logger level="INFO" doc:name="Start - Get All Tasks" message="Starting get all tasks flow with query params: #[attributes.queryParams]"/>
        
        
        
        <!-- Execute query with parameterized where clause -->
        <ee:transform doc:name="Prepare Query Parameters">
            <ee:message />
            <ee:variables>
                <ee:set-variable variableName="queryParams"><![CDATA[%dw 2.0
output application/java
var completedParam = attributes.queryParams.completed
var dueDateParam = attributes.queryParams.dueDate
---
{
    completed: if (completedParam != null) completedParam else null,
    dueDate: if (dueDateParam != null) dueDateParam else null
}]]></ee:set-variable>
                <ee:set-variable variableName="sqlQuery"><![CDATA[%dw 2.0
output application/java
var completedParam = attributes.queryParams.completed
var dueDateParam = attributes.queryParams.dueDate
var conditions = []

var withCompleted = if (completedParam != null) 
    conditions + "completed = :completed"
else 
    conditions
    
var withDueDate = if (dueDateParam != null)
    withCompleted + "due_date = :dueDate"
else 
    withCompleted

var whereClauseStr = if (sizeOf(withDueDate) > 0) 
    " WHERE " ++ (withDueDate joinBy " AND ")
else 
    ""
---
"SELECT id, title, description, dueDate, completed FROM tasks" ++ whereClauseStr]]></ee:set-variable>
            </ee:variables>
        </ee:transform>
        
        <db:select doc:name="Select Tasks" config-ref="mysql-db-config">
            <db:sql><![CDATA[#[vars.sqlQuery]]]></db:sql>
            <db:input-parameters><![CDATA[#[vars.queryParams]]]></db:input-parameters>
        </db:select>
        
        <!-- Transform database result to API response format -->
        <ee:transform doc:name="Transform to API Response">
            <ee:message>
                <ee:set-payload><![CDATA[%dw 2.0
output application/json
---
payload map {
    id: $.id as String,
    title: $.title,
    description: $.description,
    dueDate: $.dueDate,
    completed: $.completed
}]]></ee:set-payload>
            </ee:message>
        </ee:transform>
        
        <logger level="INFO" doc:name="End - Get All Tasks" message="Completed get all tasks flow, returning #[sizeOf(payload)] tasks"/>
    </sub-flow>
    
</mule>
```