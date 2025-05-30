CREATE TABLE tasks(  
    id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    dueDate VARCHAR(255),
    completed BOOLEAN NOT NULL
);