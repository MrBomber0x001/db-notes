SELECT user_id, 
CONCAT(UCASE(LEFT(name, 1)), LCASE(SUBSTRING(name, 2, LENGTH(name)))) as name
FROM Users
ORDER BY user_id;