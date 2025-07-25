# Video

TBD

# Message history

## 1. Alex

take a look at the `get-all-tasks-flow` flow, the `Prepare Query` transform message has an error. please fix it and make sure the rest of the flow is correctly set up to get a list of all the tasks from the database

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
        
        <!-- Prepare query based on filter parameters -->
        <ee:transform doc:name="Prepare Query">
            <ee:message />
            <ee:variables>
                <ee:set-variable variableName="whereClause"><![CDATA[%dw 2.0
output application/java
var completedParam = attributes.queryParams.completed
var dueDateParam = attributes.queryParams.dueDate
var conditions = []

var withCompleted = if (completedParam != null) 
    conditions + ("completed = " ++ completedParam)
else 
    conditions
    
var withDueDate = if (dueDateParam != null)
    withCompleted + ("due_date = '" ++ dueDateParam ++ "'")
else 
    withCompleted

var whereClauseStr = if (sizeOf(withDueDate) > 0) 
    " WHERE " ++ (withDueDate joinBy " AND ")
else 
    ""
---
whereClauseStr
]]></ee:set-variable>
            </ee:variables>
        </ee:transform>
        
        <!-- Execute query with dynamic where clause -->
        <db:select doc:name="Select Tasks" config-ref="mysql-db-config">
            <db:sql><![CDATA[SELECT id, title, description, dueDate, completed FROM tasks$(vars.whereClause)]]></db:sql>
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