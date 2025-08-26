# 使用存储过程
## 什么是存储过程？

存储过程是一组为了完成特定功能的 SQL 语句集合，经编译后存储在数据库中。用户通过指定存储过程的名字并给出参数（如果需要）来调用执行。

**可以把它想象成数据库中的函数或方法。**

---

## 为什么要使用存储过程？

1.  **减少网络流量：** 将复杂的多条 SQL 操作封装成一个单元，客户端只需调用一次，而不是发送多条 SQL 语句。
2.  **提高性能：** 存储过程在创建时进行编译和优化，后续调用直接执行，无需再次解析和编译。
3.  **增强安全性和一致性：**
    *   可以授予用户执行存储过程的权限，而不直接授予其对底层表的操作权限。
    *   将业务逻辑封装在数据库层，确保所有应用程序都以相同的方式处理数据，避免逻辑分散在应用代码中。
4.  **代码复用和维护：** 逻辑修改只需在数据库端修改存储过程即可，无需修改所有调用它的应用程序。

---

## 存储过程的基本语法

#### 1. 创建存储过程 (`CREATE PROCEDURE`)

使用 `DELIMITER` 命令临时更改语句分隔符，以便在过程体内使用分号 `;`。

```sql
DELIMITER // -- 将分隔符临时改为 //

CREATE PROCEDURE procedure_name (
    [IN | OUT | INOUT] parameter_name parameter_datatype [(length)], ...
)
[characteristic ...] -- 特性，如注释、语言等
BEGIN
    -- 存储过程体：SQL 语句集合
    -- 可以使用变量、条件、循环、游标等
END//

DELIMITER ; -- 将分隔符改回 ;
```

*   **参数模式：**
    *   `IN` (默认)：输入参数，调用者将值传入存储过程。
    *   `OUT`：输出参数，存储过程通过它返回值给调用者。
    *   `INOUT`：既是输入参数，也是输出参数。

#### 2. 调用存储过程 (`CALL`)

```sql
CALL procedure_name([parameter, ...]);
```

#### 3. 查看存储过程

```sql
-- 查看数据库中的所有存储过程
SHOW PROCEDURE STATUS [WHERE db = 'your_database_name'];

-- 查看某个存储过程的详细定义
SHOW CREATE PROCEDURE procedure_name;
```

#### 4. 删除存储过程 (`DROP PROCEDURE`)

```sql
DROP PROCEDURE IF EXISTS procedure_name;
```

---

## 完整示例演示

假设我们有一个简单的员工表 `employees`：

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);
```

#### 示例 1：简单的无参数存储过程
创建一个过程，获取所有员工信息。

```sql
DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT * FROM employees;
END //
DELIMITER ;

-- 调用
CALL GetAllEmployees();
```

#### 示例 2：带 `IN` 输入参数的过程
创建一个过程，根据部门名称筛选员工。

```sql
DELIMITER //
CREATE PROCEDURE GetEmployeesByDepartment(IN dept_name VARCHAR(50))
BEGIN
    SELECT * FROM employees WHERE department = dept_name;
END //
DELIMITER ;

-- 调用
CALL GetEmployeesByDepartment('Sales');
CALL GetEmployeesByDepartment('IT');
```

#### 示例 3：带 `OUT` 输出参数的过程
创建一个过程，计算某个部门的平均工资并返回。

```sql
DELIMITER //
CREATE PROCEDURE GetDepartmentAvgSalary(
    IN dept_name VARCHAR(50),
    OUT avg_salary DECIMAL(10, 2)
)
BEGIN
    SELECT AVG(salary) INTO avg_salary -- 使用 INTO 将结果赋值给 OUT 参数
    FROM employees 
    WHERE department = dept_name;
END //
DELIMITER ;

-- 调用
-- 先定义一个用户变量 @avg 来接收输出参数
CALL GetDepartmentAvgSalary('IT', @avg);
-- 查看结果
SELECT @avg AS it_department_avg_salary;
```

#### 示例 4：带 `INOUT` 参数的过程
创建一个过程，给指定员工加薪指定的百分比。

```sql
DELIMITER //
CREATE PROCEDURE GiveRaise(
    INOUT amount DECIMAL(10, 2), -- 既是输入的当前工资，也是输出的新工资
    IN raise_percentage DECIMAL(5, 2)
)
BEGIN
    SET amount = amount * (1 + raise_percentage / 100); -- 计算新工资
END //
DELIMITER ;

-- 调用
-- 假设员工当前工资是 5000，我们给他加薪 10%
SET @current_salary = 5000.00;
CALL GiveRaise(@current_salary, 10.0);
-- 查看加薪后的工资
SELECT @current_salary AS new_salary; -- 结果应为 5500.00
```

#### 示例 5：使用变量和流程控制
创建一个过程，根据员工 ID 调整其工资等级。

```sql
DELIMITER //
CREATE PROCEDURE AdjustSalary(IN emp_id INT)
BEGIN
    -- 声明局部变量
    DECLARE current_sal DECIMAL(10, 2);
    DECLARE new_sal DECIMAL(10, 2);
    
    -- 获取当前工资
    SELECT salary INTO current_sal FROM employees WHERE id = emp_id;
    
    -- 使用条件语句
    IF current_sal < 5000 THEN
        SET new_sal = current_sal * 1.15; -- 低薪加 15%
    ELSEIF current_sal BETWEEN 5000 AND 10000 THEN
        SET new_sal = current_sal * 1.10; -- 中等加 10%
    ELSE
        SET new_sal = current_sal * 1.05; -- 高薪加 5%
    END IF;
    
    -- 更新工资
    UPDATE employees SET salary = new_sal WHERE id = emp_id;
    
    -- 返回信息（在 MySQL 中，SELECT 语句可以直接作为结果返回）
    SELECT CONCAT('Employee ', emp_id, ' salary adjusted from ', current_sal, ' to ', new_sal) AS result;
END //
DELIMITER ;

-- 调用
CALL AdjustSalary(1);
```

---

## 存储过程中的编程元素

在过程体 (`BEGIN ... END`) 中，你还可以使用更复杂的编程结构：

1.  **变量：**
    *   **用户变量：** `@variable_name`，会话级有效。
    *   **局部变量：** 用 `DECLARE var_name TYPE [DEFAULT value];` 声明，只在 `BEGIN...END` 块中有效。
2.  **流程控制：**
    *   **条件语句：** `IF ... THEN ... ELSEIF ... ELSE ... END IF;` 或 `CASE ... END CASE;`
    *   **循环语句：** `WHILE ... DO ... END WHILE;`, `REPEAT ... UNTIL ... END REPEAT;`, `LOOP ... END LOOP;`
3.  **游标 (Cursor)：** 用于遍历结果集，逐行处理数据（通常与循环一起使用）。
4.  **错误处理 (Handler)：** 使用 `DECLARE ... HANDLER` 来定义当发生特定 SQL 异常时应执行的操作。

## 总结与最佳实践

*   **命名清晰：** 使用动词开头，如 `Get`, `Calculate`, `Update`, `Insert` 等，使其功能一目了然。
*   **注释：** 使用 `/* ... */` 或 `--` 为存储过程添加注释，说明其用途、参数和逻辑。
*   **权限控制：** 使用 `GRANT EXECUTE ON PROCEDURE procedure_name TO 'user'@'host';` 来授予执行权限，而不是直接授予表权限。
*   **谨慎使用：** 虽然强大，但过多的业务逻辑放入数据库会使应用难以扩展和移植。通常将核心的数据操作和复杂的计算放在存储过程中，而将业务规则放在应用层。

存储过程是 MySQL 中非常强大的工具，熟练掌握它能极大地提升你处理复杂数据库操作的能力和效率。
# 管理事务处理
好的，事务处理是数据库系统中至关重要的高级特性。它确保了数据的完整性和一致性。下面我来详细教你如何在 MySQL 中管理事务。

### 1. 什么是事务？

**事务**是一个不可分割的工作单元，它由一组 SQL 操作组成。这些操作要么**全部成功**，要么**全部失败**，不会存在中间状态。

最经典的例子就是**银行转账**：
1.  从 A 账户扣钱
2.  向 B 账户加钱

这两个步骤必须作为一个整体来执行。如果第一步成功而第二步失败，会导致钱凭空消失，这是绝对不允许的。事务就是用来防止这种情况发生的。

---

### 2. 事务的四个核心特性 (ACID)

| 特性 | 全称 | 含义 |
| :--- | :--- | :--- |
| **A**tomicity | **原子性** | 事务是一个不可分割的整体，要么全部完成，要么全部不完成。 |
| **C**onsistency | **一致性** | 事务必须使数据库从一个一致状态变换到另一个一致状态。转账前后总金额不变。 |
| **I**solation | **隔离性** | 多个并发事务之间互不干扰，一个事务的执行不应影响其他事务。 |
| **D**urability | **持久性** | 一旦事务提交，它对数据库的修改就是永久性的，即使系统故障也不会丢失。 |

---

### 3. MySQL 中的事务管理语句

MySQL 默认使用**自动提交 (AUTOCOMMIT)** 模式，即每一条 SQL 语句都是一个独立的事务，执行后会自动提交。

要手动控制事务，需要使用以下命令：

| 命令 | 作用 |
| :--- | :--- |
| `START TRANSACTION;` 或 `BEGIN;` | **开始一个事务**。之后的 SQL 语句不会立即生效，直到提交或回滚。 |
| `COMMIT;` | **提交事务**。将事务中的所有操作永久保存到数据库。 |
| `ROLLBACK;` | **回滚事务**。撤销事务中所有未提交的操作，回到事务开始前的状态。 |
| `SET autocommit = 0;` | **关闭自动提交**模式。此后所有语句都在一个隐式事务中，直到显式执行 `COMMIT` 或 `ROLLBACK`。 |
| `SET autocommit = 1;` | **开启自动提交**模式（默认）。 |

---

### 4. 基础事务处理示例

假设我们有一个 `bank_accounts` 表：

```sql
CREATE TABLE bank_accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_name VARCHAR(100) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

INSERT INTO bank_accounts (account_name, balance) VALUES
('Alice', 1000.00),
('Bob', 500.00);
```

**示例：实现从 Alice 向 Bob 转账 200 元**

```sql
-- 1. 开始事务
START TRANSACTION;

-- 2. 执行一系列操作
UPDATE bank_accounts SET balance = balance - 200 WHERE account_name = 'Alice';
UPDATE bank_accounts SET balance = balance + 200 WHERE account_name = 'Bob';

-- 3. 检查是否有错误（通常在应用程序中检查）
-- 如果没有问题，提交事务
COMMIT;

-- 如果中途出现问题（如 Alice 余额不足、系统故障），则回滚
-- ROLLBACK;
```

**验证结果：**
```sql
SELECT * FROM bank_accounts;
```
| id | account_name | balance |
|----|--------------|---------|
| 1  | Alice        | 800.00  |
| 2  | Bob          | 700.00  |

---

### 5. 使用 `SAVEPOINT` 实现部分回滚

对于复杂的事务，你可以在事务内部设置**保存点 (Savepoint)**，以便回滚到特定的点，而不是回滚整个事务。

```sql
START TRANSACTION;

-- 一些操作...
UPDATE table1 ... ;

-- 设置保存点 point1
SAVEPOINT point1;

-- 更多操作...
INSERT INTO table2 ... ;

-- 如果这里的操作失败了，可以回滚到保存点 point1，而不是事务开头
-- 这样 table1 的更新依然有效
ROLLBACK TO SAVEPOINT point1;

-- 继续其他操作...
UPDATE table3 ... ;

-- 最终提交
COMMIT;
```

---

### 6. 事务的隔离级别 (Isolation Levels)

这是事务中最高级也最重要的概念。它定义了多个并发事务之间的可见性规则，解决了以下问题：
*   **脏读 (Dirty Read):** 一个事务读到了另一个**未提交事务**修改的数据。
*   **不可重复读 (Non-repeatable Read):** 一个事务内，两次读取同一数据，结果不同（因为另一事务**提交了修改**）。
*   **幻读 (Phantom Read):** 一个事务内，两次查询同一范围的数据，第二次查询看到了第一次没有的**新行**（因为另一事务**提交了插入**）。

MySQL 支持 4 种隔离级别（从宽松到严格）：

| 隔离级别 | 脏读 | 不可重复读 | 幻读 | 性能 |
| :--- | :--- | :--- | :--- | :--- |
| **READ UNCOMMITTED** (读未提交) | ❌ 可能 | ❌ 可能 | ❌ 可能 | 最高 |
| **READ COMMITTED** (读已提交) | ✅ 避免 | ❌ 可能 | ❌ 可能 | 较高 |
| **REPEATABLE READ** (可重复读) | ✅ 避免 | ✅ 避免 | ❌ 可能 | 中等 **(MySQL InnoDB 默认)** |
| **SERIALIZABLE** (串行化) | ✅ 避免 | ✅ 避免 | ✅ 避免 | 最低 |

**查看和设置隔离级别：**

```sql
-- 查看当前会话的隔离级别
SELECT @@transaction_isolation;

-- 查看全局隔离级别
SELECT @@global.transaction_isolation;

-- 设置当前会话的隔离级别为 READ COMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 设置全局隔离级别（需要权限）
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

**如何选择？**
*   默认的 `REPEATABLE READ` 在大多数情况下已经足够。
*   对数据一致性要求极高，且可以接受性能损失时，考虑 `SERIALIZABLE`。
*   对性能要求极高，且可以容忍一定程度的数据不一致时，考虑 `READ COMMITTED`。
*   `READ UNCOMMITTED` 很少使用。

---

### 7. 在应用程序中管理事务（最佳实践）

在实际开发中，事务管理通常在应用程序代码中（如 Python, Java, PHP 等）进行，通常遵循以下模式：

**伪代码逻辑：**
```python
try:
    # 1. 开始事务
    db.start_transaction()
    
    # 2. 执行数据库操作
    db.execute("UPDATE accounts SET balance = balance - 100 WHERE user_id = 1")
    db.execute("UPDATE accounts SET balance = balance + 100 WHERE user_id = 2")
    
    # 3. 如果没有异常，提交事务
    db.commit()
    print("Transaction committed successfully!")

except Exception as e:
    # 4. 如果发生任何异常，回滚事务
    db.rollback()
    print(f"Transaction failed: {e}. Rolling back.")
```

### 总结

1.  **核心命令：** `START TRANSACTION;` -> `SQL Operations` -> `COMMIT;` (成功) 或 `ROLLBACK;` (失败)。
2.  **ACID 原则：** 理解原子性、一致性、隔离性、持久性是理解事务的基础。
3.  **隔离级别：** 理解不同隔离级别解决的问题（脏读、不可重复读、幻读），并根据业务需求选择合适的级别。通常使用默认即可。
4.  **应用层控制：** 在代码中使用 `try...except...` 块来确保事务的正确提交或回滚，这是最可靠的方式。
5.  **保持事务简短：** 事务应尽可能短小高效，长时间的事务会锁定资源，影响数据库并发性能。

熟练掌握事务处理，是你从编写简单 SQL 脚本迈向开发健壮、可靠企业级应用的关键一步。

# 游标
## 什么是游标？

**游标**是一种数据库对象，用于在 SQL 结果集中逐行遍历和处理数据。它允许你对查询返回的每一行数据进行单独的操作，就像编程语言中的循环遍历数组一样。

## 为什么需要游标？

在标准的 SQL 操作中，我们通常以集合为单位处理数据（一次处理多行）。但在某些场景下，我们需要：
- 逐行处理数据
- 基于每行数据执行复杂的业务逻辑
- 在存储过程或函数中进行行级操作

## 游标的基本生命周期

1. **声明游标**（DECLARE） - 定义游标及其对应的查询
2. **打开游标**（OPEN） - 执行查询并准备结果集
3. **获取数据**（FETCH） - 逐行读取数据
4. **处理数据** - 对每行数据进行操作
5. **关闭游标**（CLOSE） - 释放资源
6. **释放游标**（DEALLOCATE） - 删除游标定义（可选）

## MySQL 游标语法示例

```sql
DELIMITER //

CREATE PROCEDURE ProcessEmployees()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE emp_id INT;
    DECLARE emp_name VARCHAR(100);
    DECLARE emp_salary DECIMAL(10,2);
    
    -- 1. 声明游标
    DECLARE emp_cursor CURSOR FOR 
        SELECT id, name, salary FROM employees WHERE department = 'IT';
    
    -- 声明异常处理器
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- 创建临时表存储结果
    CREATE TEMPORARY TABLE IF NOT EXISTS processed_employees (
        id INT,
        name VARCHAR(100),
        salary DECIMAL(10,2),
        bonus DECIMAL(10,2)
    );
    
    -- 2. 打开游标
    OPEN emp_cursor;
    
    -- 3. 循环获取数据
    read_loop: LOOP
        FETCH emp_cursor INTO emp_id, emp_name, emp_salary;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 4. 处理每行数据（业务逻辑）
        IF emp_salary > 10000 THEN
            INSERT INTO processed_employees 
            VALUES (emp_id, emp_name, emp_salary, emp_salary * 0.1);
        ELSE
            INSERT INTO processed_employees 
            VALUES (emp_id, emp_name, emp_salary, emp_salary * 0.05);
        END IF;
    END LOOP;
    
    -- 5. 关闭游标
    CLOSE emp_cursor;
    
    -- 返回处理结果
    SELECT * FROM processed_employees;
    
    -- 清理临时表
    DROP TEMPORARY TABLE processed_employees;
END //

DELIMITER ;
```

## 游标的类型

### 1. 只读游标（默认）
```sql
DECLARE cursor_name CURSOR FOR SELECT ...;
```

### 2. 可更新游标
```sql
DECLARE cursor_name CURSOR FOR SELECT ... FOR UPDATE;
```

### 3. 敏感/不敏感游标
- **敏感游标**：反映其他事务对数据的修改
- **不敏感游标**：使用游标打开时的数据快照

## 实际应用场景

### 场景1：数据迁移和转换
```sql
CREATE PROCEDURE MigrateOldData()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE old_id, new_id INT;
    DECLARE old_name VARCHAR(100);
    
    DECLARE migrate_cursor CURSOR FOR 
        SELECT id, name FROM old_employees;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN migrate_cursor;
    
    migrate_loop: LOOP
        FETCH migrate_cursor INTO old_id, old_name;
        IF done THEN LEAVE migrate_loop; END IF;
        
        -- 复杂的转换逻辑
        INSERT INTO new_employees (name, email, hire_date)
        VALUES (old_name, CONCAT(LOWER(REPLACE(old_name, ' ', '.')), '@company.com'), NOW());
        
        SET new_id = LAST_INSERT_ID();
        
        -- 更新关联表
        UPDATE employee_departments 
        SET employee_id = new_id 
        WHERE employee_id = old_id;
    END LOOP;
    
    CLOSE migrate_cursor;
END;
```

### 场景2：复杂的计算和统计
```sql
CREATE PROCEDURE CalculateDepartmentStats()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE dept_id INT;
    DECLARE dept_name VARCHAR(100);
    DECLARE total_salary DECIMAL(15,2) DEFAULT 0;
    DECLARE employee_count INT DEFAULT 0;
    
    DECLARE dept_cursor CURSOR FOR 
        SELECT department_id, department_name FROM departments;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    CREATE TEMPORARY TABLE dept_stats (
        department_id INT,
        department_name VARCHAR(100),
        total_salary DECIMAL(15,2),
        avg_salary DECIMAL(15,2),
        employee_count INT
    );
    
    OPEN dept_cursor;
    
    dept_loop: LOOP
        FETCH dept_cursor INTO dept_id, dept_name;
        IF done THEN LEAVE dept_loop; END IF;
        
        -- 为每个部门计算统计信息
        SELECT SUM(salary), COUNT(*) 
        INTO total_salary, employee_count
        FROM employees 
        WHERE department_id = dept_id;
        
        INSERT INTO dept_stats 
        VALUES (dept_id, dept_name, total_salary, 
                total_salary / NULLIF(employee_count, 0), 
                employee_count);
    END LOOP;
    
    CLOSE dept_cursor;
    
    SELECT * FROM dept_stats ORDER BY total_salary DESC;
    
    DROP TEMPORARY TABLE dept_stats;
END;
```

## 游标的优缺点

### 优点：
- ✅ 逐行处理复杂业务逻辑
- ✅ 支持基于行的条件判断和操作
- ✅ 在存储过程中实现复杂的数据处理流程
- ✅ 处理需要逐行验证或转换的数据

### 缺点：
- ⚠️ **性能开销大**：比集合操作慢很多
- ⚠️ **资源消耗**：占用内存和数据库连接
- ⚠️ **锁问题**：可能长时间锁定资源
- ⚠️ **复杂度高**：代码比简单的 SQL 查询复杂

## 最佳实践

1. **尽量避免使用游标**：优先使用集合操作
2. **尽快关闭游标**：减少资源占用时间
3. **使用合适的游标类型**：根据需求选择只读或可更新
4. **添加适当的错误处理**
5. **测试性能影响**

## 替代方案

在可能的情况下，尽量使用集合操作代替游标：

```sql
-- 使用游标（不推荐）
-- 逐行更新员工奖金

-- 使用集合操作（推荐）
UPDATE employees 
SET bonus = CASE 
    WHEN salary > 10000 THEN salary * 0.1
    ELSE salary * 0.05
END
WHERE department = 'IT';
```

## 总结

游标是一个强大的工具，但应该谨慎使用。它适用于：
- 复杂的逐行业务逻辑处理
- 数据迁移和转换
- 需要逐行验证的场景
- 在存储过程中实现复杂算法

但在大多数情况下，**优先考虑使用集合操作的 SQL 语句**，因为它们的性能更好，代码更简洁。只有在确实需要逐行处理时才使用游标。

# 高级 SQL 特性

SQL 中的四个核心高级特性：**约束、索引、触发器**和**数据库安全**。这些是构建健壮、高效和安全数据库系统的基石。

---

## 1. 约束

**概念：** 约束是应用于表中数据列的规则，用于强制数据的完整性和一致性。它们确保数据库中的数据符合特定的业务规则，防止无效数据进入数据库。

**主要类型及在 MySQL 中的用法：**

1.  **`PRIMARY KEY` (主键约束)**
    *   **作用：** 唯一标识表中的每一行。不能为 NULL，且值必须唯一。
    *   **示例：**
        ```sql
        CREATE TABLE Users (
            user_id INT AUTO_INCREMENT PRIMARY KEY, -- 列级约束
            username VARCHAR(50) NOT NULL
        );
        -- 或者表级约束
        CREATE TABLE Orders (
            order_id INT,
            product_id INT,
            PRIMARY KEY (order_id, product_id) -- 复合主键
        );
        ```

2.  **`FOREIGN KEY` (外键约束)**
    *   **作用：** 确保一个表（子表）中的数据指向另一个表（父表）中存在的值，维护表之间的引用完整性。
    *   **示例：**
        ```sql
        CREATE TABLE Orders (
            order_id INT PRIMARY KEY,
            user_id INT,
            order_date DATE,
            FOREIGN KEY (user_id) REFERENCES Users(user_id) -- 定义外键
            ON DELETE CASCADE -- 可选：当用户被删除时，其所有订单也被自动删除
        );
        ```
    *   **引用操作 (`ON DELETE` / `ON UPDATE`)：**
        *   `CASCADE`: 级联操作（删除或更新）。
        *   `SET NULL`: 将外键值设置为 NULL。
        *   `RESTRICT`（默认）: 拒绝操作（如果存在引用记录）。
        *   `NO ACTION`: 类似 `RESTRICT`。

3.  **`UNIQUE` (唯一约束)**
    *   **作用：** 确保列中的所有值都是不同的。允许有 NULL 值（但通常只能有一个 NULL，取决于数据库设置，在 MySQL 中多个 NULL 是允许的）。
    *   **示例：**
        ```sql
        CREATE TABLE Products (
            product_id INT PRIMARY KEY,
            product_code VARCHAR(10) UNIQUE, -- 确保产品代码唯一
            name VARCHAR(100)
        );
        ```

4.  **`NOT NULL` (非空约束)**
    *   **作用：** 强制列不能接受 NULL 值。
    *   **示例：**
        ```sql
        CREATE TABLE Employees (
            emp_id INT PRIMARY KEY,
            first_name VARCHAR(50) NOT NULL, -- 名字必须提供
            last_name VARCHAR(50) NOT NULL,
            email VARCHAR(100)
        );
        ```

5.  **`CHECK` (检查约束)**
    *   **作用：** 限制列中的值必须满足指定的条件。**注意：** 在 MySQL 8.0.16 之前，`CHECK` 约束会被解析但会被静默忽略。从 8.0.16 开始才被完全支持。
    *   **示例 (MySQL 8.0.16+):**
        ```sql
        CREATE TABLE Students (
            student_id INT PRIMARY KEY,
            age INT,
            grade CHAR(1),
            CONSTRAINT chk_age CHECK (age >= 0 AND age <= 120), -- 检查年龄范围
            CONSTRAINT chk_grade CHECK (grade IN ('A', 'B', 'C', 'D', 'F')) -- 检查成绩等级
        );
        ```

6.  **`DEFAULT` (默认约束)**
    *   **作用：** 当向表中插入新记录但未指定该列的值时，自动赋予一个默认值。
    *   **示例：**
        ```sql
        CREATE TABLE Posts (
            post_id INT PRIMARY KEY,
            title VARCHAR(255),
            content TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 默认为当前时间
            is_published BOOLEAN DEFAULT FALSE -- 默认为未发布
        );
        ```

---

## 2. 索引

**概念：** 索引是一种数据结构（如 B+Tree），用于快速查找和访问表中的特定数据，类似于书籍的目录。它能极大提高 `SELECT` 查询的速度，但会降低 `INSERT`, `UPDATE`, `DELETE` 的速度，因为索引本身也需要维护。

**主要类型及在 MySQL 中的用法：**

1.  **普通索引 (`INDEX`)**
    *   **作用：** 最基本的索引，没有任何唯一性限制。
    *   **示例：**
        ```sql
        CREATE INDEX idx_lastname ON Employees(last_name);
        -- 或者建表时创建
        CREATE TABLE Employees (
            emp_id INT PRIMARY KEY,
            last_name VARCHAR(50),
            INDEX idx_lastname (last_name)
        );
        ```

2.  **唯一索引 (`UNIQUE INDEX`)**
    *   **作用：** 与唯一约束类似，确保索引列的值都是唯一的。
    *   **示例：**
        ```sql
        CREATE UNIQUE INDEX uidx_email ON Employees(email);
        ```

3.  **主键索引 (`PRIMARY KEY`)**
    *   **作用：** 每张表的主键会自动创建一个唯一的主键索引。它是聚簇索引（InnoDB），决定了表中数据的物理存储顺序。

4.  **复合索引 (多列索引)**
    *   **作用：** 在多个列上创建的索引。查询条件如果使用了索引的最左前缀，则索引生效（**最左前缀原则**）。
    *   **示例：**
        ```sql
        CREATE INDEX idx_name_dob ON Employees(first_name, last_name, date_of_birth);
        -- 有效的查询：WHERE first_name = 'John'
        -- 有效的查询：WHERE first_name = 'John' AND last_name = 'Doe'
        -- 无效的查询：WHERE last_name = 'Doe' (跳过了 first_name)
        ```

5.  **全文索引 (`FULLTEXT INDEX`)**
    *   **作用：** 专门用于全文搜索，适用于 `MATCH() ... AGAINST()` 语法，用于在文本内容中搜索关键词。仅适用于 `MyISAM` 和 `InnoDB`（5.6+）存储引擎。
    *   **示例：**
        ```sql
        CREATE TABLE Articles (
            id INT PRIMARY KEY,
            title VARCHAR(200),
            body TEXT,
            FULLTEXT (title, body)
        );
        -- 使用全文搜索
        SELECT * FROM Articles
        WHERE MATCH(title, body) AGAINST('database MySQL');
        ```

---

## 3. 触发器

**概念：** 触发器是一种特殊的存储过程，它在数据库中发生特定事件（`INSERT`, `UPDATE`, `DELETE`）时自动执行（或“触发”）。它常用于实现复杂的业务逻辑、审计日志、数据验证等。

**关键点：**
*   **触发时机：** `BEFORE`（在操作之前）或 `AFTER`（在操作之后）。
*   **触发事件：** `INSERT`, `UPDATE`, `DELETE`。
*   **`OLD` 和 `NEW` 关键字：**
    *   在 `UPDATE` 和 `DELETE` 触发器中，可以使用 `OLD.col_name` 来引用被更新或删除行的旧值。
    *   在 `INSERT` 和 `UPDATE` 触发器中，可以使用 `NEW.col_name` 来引用即将被插入或更新后的新值。

**示例：** 创建一个审计日志表，在 `Employees` 表的薪水被更新后自动记录更改。
```sql
-- 1. 创建审计表
CREATE TABLE salary_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100)
);

-- 2. 创建 AFTER UPDATE 触发器
DELIMITER // -- 临时更改分隔符，以便在触发器体内使用分号

CREATE TRIGGER after_employee_salary_update
AFTER UPDATE ON Employees
FOR EACH ROW -- 行级触发器（MySQL只支持行级触发）
BEGIN
    IF OLD.salary <> NEW.salary THEN -- 只有当薪水确实改变时才记录
        INSERT INTO salary_audit (emp_id, old_salary, new_salary, changed_by)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary, CURRENT_USER());
    END IF;
END;//

DELIMITER ; -- 将分隔符改回分号
```

---

## 4. 数据库安全

数据库安全涉及保护数据库免受未经授权的访问、滥用或破坏。MySQL 提供了多层次的安全机制。

1.  **用户账户管理**
    *   **创建用户：**
        ```sql
        CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'strong_password';
        -- 'new_user'@'%' 允许从任何主机连接
        ```
    *   **删除用户：**
        ```sql
        DROP USER 'old_user'@'localhost';
        ```

2.  **权限管理 (`GRANT` / `REVOKE`)**
    *   这是安全的核心。原则是：**最小权限原则**，即只授予用户完成其工作所必需的最低权限。
    *   **授予权限：**
        ```sql
        -- 授予对特定数据库的所有权限
        GRANT ALL PRIVILEGES ON company_db.* TO 'user'@'localhost';
        -- 授予特定权限（SELECT, INSERT, UPDATE）于特定表
        GRANT SELECT, INSERT, UPDATE ON company_db.employees TO 'report_user'@'%';
        ```
    *   **撤销权限：**
        ```sql
        REVOKE UPDATE ON company_db.employees FROM 'report_user'@'%';
        ```
    *   **立即刷新权限：**
        ```sql
        FLUSH PRIVILEGES;
        ```

3.  **角色 (MySQL 8.0+)**
    *   角色是权限的集合，可以分配给用户，极大地简化了权限管理。
    *   **示例：**
        ```sql
        -- 1. 创建角色并授予权限
        CREATE ROLE 'read_only';
        GRANT SELECT ON company_db.* TO 'read_only';

        -- 2. 将角色授予用户
        GRANT 'read_only' TO 'report_user'@'%';

        -- 3. 为用户激活角色（重要！）
        SET DEFAULT ROLE 'read_only' TO 'report_user'@'%';
        ```

4.  **视图用于安全**
    *   可以创建视图来暴露表中的部分数据，然后只授予用户对视图的访问权限，而不是对整个基表的权限。这是一种有效的访问控制手段。
    *   **示例：**
        ```sql
        -- 创建一个不包含敏感工资信息的视图
        CREATE VIEW employee_public AS
        SELECT emp_id, first_name, last_name, department_id
        FROM Employees;

        -- 授予用户只能查询这个视图
        GRANT SELECT ON company_db.employee_public TO 'public_user'@'%';
        ```

5.  **其他安全实践**
    *   **加密连接：** 使用 SSL/TLS 加密客户端和服务器之间的通信。
    *   **数据加密：** 对敏感数据（如密码）进行哈希加密存储（例如使用 `SHA2()` 函数），而不是明文存储。
    *   **网络安全：** 使用防火墙限制对数据库端口（默认 3306）的访问。
    *   **定期备份：** 确保发生安全事件或数据损坏后可以恢复。

## 总结

| 特性 | 核心目的 | 关键点 |
| :--- | :--- | :--- |
| **约束** | **保证数据正确性** | `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK` |
| **索引** | **提高查询性能** | `INDEX`, `UNIQUE INDEX`, 复合索引（最左前缀），`FULLTEXT` |
| **触发器** | **自动化业务逻辑** | `BEFORE/AFTER` `INSERT/UPDATE/DELETE`, `OLD` & `NEW` |
| **安全** | **防止未授权访问** | 用户管理、`GRANT/REVOKE`、角色（8.0+）、视图、加密 |

这些特性共同作用，使你能够构建出不仅性能高效，而且数据准确、逻辑自动化和高度安全的数据库应用。

