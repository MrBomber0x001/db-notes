## Content of Course

| **Day1**                                                                                             | **Day2**                                                             | **Day3**                                                  |
| ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | --------------------------------------------------------- |
| 1) DB Concept<br>2) DB Design<br>3) ERD <br>4) DB Life Cycle<br>5) File based system<br>6) DB System | 1) DB Mapping<br>2) DB Schema<br>3) Create DB <br>4) RDMBs<br>5) SQL | 1) Joins<br>2) DB Integrity<br>3) Constraints<br>4) Rules |

| **Day4**                                                                                    | **Day5**                                                                                                  | **Day6**                                                        |
| ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| 1) Aggregate Functions<br>2) grouping<br>3) Union<br>4) Data Types<br>5) Script Transaction | 1) Transact-SQL<br>2) Top<br>3) Newid<br>4) select into<br>5) Ranking<br>6) Security<br>7) SQL schema<br> | 1) Variables<br>2) Conditions<br>3) loops<br>4) Create Function |

| **Day7**                                   | **Day8**                                                         |
| ------------------------------------------ | ---------------------------------------------------------------- |
| 1) Index<br>2) View<br>3) Merge<br>4) Temp | 1) Stored procedure<br>2) Triggers<br>3) Backups <br>4) Snapshot |

___
# Database Life Cycle
1. **Analysis** `=> System Analyst`
	=>Requirement Document
2. **DB Design** `=> DB Designer`
	=>ERD => Entity Relationship Diagram
3. **DB Mapping** `=>DB Designer`
	=>DB Schema (tables_Relations)
4. **DB Implementation** `=> DB Developer`
	=> Physical DB (Files) (.mdf & .ldf) : is created by RDBMS 
	Relation Database Management System
	EX: SQLServer Oracle MySQL
	Database System :is Build on database sharing only one instance of database
5. **application** `=>Application Programmer` 
	`GUI Interface`
	`Website`
	`desktop`
	`Moblie`
6. **Client** `=> End User`
	Client Does not have access to database Directly he uses database throw application.
### Database Users
1. Database Administrator
2. System Analyst
3. Database Designer
4. Database Developer
5. Application Programmer
6. BI & Big Data Specialist
7. End User
# Types Of System

| File Based System                        | DB System                                            |
| :--------------------------------------- | ---------------------------------------------------- |
| **File Structure**                       | **Structure**                                        |
| 1 -Delimited File Seperate data with "," | Tables                                               |
| 2- Fixed Width File (bytes)              | .mdf .ldf                                            |
| **Problems**                             | **Advantages**                                       |
| :--------------------------------------- | ---------------------------------------------------- |
| 1-Redundancy                             | 1-One Standard *SQL*                                 |
| 2-Bigger DB                              | 2-Relationship                                       |
| 3-Lower Performance                      | 3-Constraints rules                                  |
| 4-Difficulty Search                      | 4-DB Integrity                                       |
| 5-File Scan                              | 5-Sharing                                            |
| 6-No DB Sharing                          | 6-Security                                           |
| 7-Seperated Copies                       | 7-Table(Column Primary Key) Unique & Not Null        |
| 8-No Relationship                        | 8- Column **Data Type** Ensures Quality & Size       |
| 9-No DB Integrity                        | **Disadvantages**                                    |
| 10-Invalid Data                          | 1-DBMS is Expensive                                  |
| 11-Long Development Time                 | 2-DBMS is Incompatible with any other available DBMS |
| 12-No Constraints_rules                  | 3-It need Expertise to use                           |
| 13-No Security                           |                                                      |
| 14-Manual Backup restore                 |                                                      |
| 15-No Data Quality                       |                                                      |
| 16-Different Integrtion                  |                                                      |
| 17-Incompatible File Format              |                                                      |

 **Metadata** : Data About data it describes the database tables and can't access data without metadata.
![Image](https://github.com/ahmedelmaadawy/DB-Notes/blob/main/Notes/Images/1.png)
# ERD
Entity-relationship Diagram
	Identifies information required by the business displaying the relevant entities and relations between them

**Construction Of The E-R Model**
1. Entities 
2. Attributes 
3. Relationships 
![Image](https://github.com/ahmedelmaadawy/DB-Notes/blob/main/Notes/Images/vlcsnap-2024-03-10-23h13m34s308.png)
___
## Types of Entities
- ### strong Entity
	An Entity set that has a primary key
- ### Weak Entity 
	An Entity set that do not have sufficient attributes to form a primary key When Parent is deleted the weak entity (child) is deleted to
___
## Types of Attributes
1. Simple Attribute
2. Composite Attribute : `=>Consist of two or more attributes`
3. Derived Attribute : `=>Caculated in run time`
4. Multi-Valued Attribute :`=>More than one value for the single entity`
5. Complex Attribute (Multi-Valued + Composite)
___
## Relationships
### Degree of Relationship
1. Unary or self relationship or Recursive 
	- A relationship in which the same entity participates more than once 
	- **EX** : `A person is married to a person` OR `Employee Manages Employee `
2. Binary Relationship
	- A Relation Between Two Different Entities 
3. Ternary Relationship
	- Where an attribute uses three entities to define it's value
### cardinality
1. One-To-One
2. One-To-Many
3. Many-To-Many
### Participation Constraint
1. Total Participation
	- Employee Must Work for department `two lines in ERD`
2. Partial Participation :Weak Participation 
	- some employees manage department `one line in ERD`

**Any Weak Entity Must be a total Participation but total participation is not mandatory to be a weak entity**
___
## Types of keys
1. Candidate Key 
	- Is a key that may be a primary key (Unique and Not Null).
2. Primary Key
	- A primary key in a table that uniquely identifies each row and column or set of columns in the table.  
3. Foreign Key
4. Composite Primary Key
	- Primary Key Consists of two columns 
5. Partial Key
6. Alternate key
7. Super key  
___
