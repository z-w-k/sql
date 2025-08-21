/* create table */
create table vendors (
    vend_id INT UNSIGNED AUTO_INCREMENT,
    vend_name VARCHAR(100) NOT NULL,
    vend_address TEXT,
    vend_city VARCHAR(50) NOT NULL,
    vend_state VARCHAR(50) NOT NULL,
    vend_zip VARCHAR(10) NOT NULL,
    vend_country VARCHAR(50) NOT NULL,
    CONSTRAINT pk_vend_id PRIMARY KEY (vend_id)
);
create table products (
    prod_id INT UNSIGNED AUTO_INCREMENT,
    vend_id INT UNSIGNED NOT NULL,
    prod_name VARCHAR(100) NOT NULL,
    prod_price DECIMAL(8, 2) NOT NULL,
    prod_desc TEXT,
    prod_date DATE NOT NULL,
    prod_status VARCHAR(50) NOT NULL,
    CONSTRAINT pk_prod_id PRIMARY KEY (prod_id),
    CONSTRAINT fk_vend_id FOREIGN KEY (vend_id) REFERENCES vendors(vend_id)
);
create table customers (
    cust_id INT UNSIGNED AUTO_INCREMENT,
    cust_name VARCHAR(100) NOT NULL,
    cust_address TEXT,
    cust_city VARCHAR(50) NOT NULL,
    cust_state VARCHAR(50) NOT NULL,
    cust_zip VARCHAR(10) NOT NULL,
    cust_country VARCHAR(50) NOT NULL,
    cust_contact VARCHAR(30) NOT NULL,
    cust_email VARCHAR(30) NOT NULL,
    CONSTRAINT pk_cust_id PRIMARY KEY (cust_id)
);
create table orders (
    order_num INT UNSIGNED AUTO_INCREMENT,
    order_date TIMESTAMP NOT NULL,
    cust_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_order_num PRIMARY KEY (order_num),
    CONSTRAINT fk_cust_id FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
);
create table order_items (
    order_num INT UNSIGNED NOT NULL,
    order_item INT UNSIGNED NOT NULL,
    prod_id INT UNSIGNED NOT NULL,
    quantity SMALLINT NOT NULL,
    item_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_order_num_order_item PRIMARY KEY (order_num, order_item),
    CONSTRAINT fk_order_num FOREIGN KEY (order_num) REFERENCES orders(order_num),
    CONSTRAINT fk_prod_id FOREIGN KEY (prod_id) REFERENCES products(prod_id)
);
/* insert */
INSERT INTO vendors (
        vend_name,
        vend_address,
        vend_city,
        vend_state,
        vend_zip,
        vend_country
    )
VALUES (
        'ToyWorld Inc.',
        '123 Main St',
        'New York',
        'NY',
        '10001',
        'USA'
    ),
    (
        'KidsToys Co.',
        '456 Oak Ave',
        'Los Angeles',
        'CA',
        '90001',
        'USA'
    ),
    (
        'FunPlay Ltd.',
        '789 Pine Rd',
        'Chicago',
        'IL',
        '60007',
        'USA'
    );
INSERT INTO products (
        vend_id,
        prod_name,
        prod_price,
        prod_desc,
        prod_date,
        prod_status
    )
VALUES (
        1,
        'Lego Classic Set',
        49.99,
        '300 pieces creative building set',
        '2024-01-15',
        'Active'
    ),
    (
        1,
        'Remote Control Car',
        29.99,
        '2.4Ghz remote control sports car',
        '2024-02-20',
        'Active'
    ),
    (
        2,
        'Barbie Doll',
        19.99,
        'Fashion doll with accessories',
        '2024-03-10',
        'Active'
    ),
    (
        2,
        'Teddy Bear',
        15.99,
        'Soft plush teddy bear 30cm',
        '2024-01-25',
        'Active'
    ),
    (
        3,
        'Puzzle Game',
        12.50,
        '1000 pieces landscape puzzle',
        '2024-02-15',
        'Active'
    );
INSERT INTO customers (
        cust_name,
        cust_address,
        cust_city,
        cust_state,
        cust_zip,
        cust_country,
        cust_contact,
        cust_email
    )
VALUES (
        'John Smith',
        '100 Maple St',
        'Boston',
        'MA',
        '02108',
        'USA',
        '555-0101',
        'john.smith@email.com'
    ),
    (
        'Emma Johnson',
        '200 Elm St',
        'San Francisco',
        'CA',
        '94102',
        'USA',
        '555-0102',
        'emma.j@email.com'
    ),
    (
        'Mike Brown',
        '300 Birch St',
        'Seattle',
        'WA',
        '98101',
        'USA',
        '555-0103',
        'mike.brown@email.com'
    );
INSERT INTO orders (order_date, cust_id)
VALUES ('2024-03-20 10:30:00', 1),
    ('2024-03-21 14:45:00', 2),
    ('2024-03-22 09:15:00', 1),
    ('2024-03-23 16:20:00', 3);
INSERT INTO order_items (
        order_num,
        order_item,
        prod_id,
        quantity,
        item_price
    )
VALUES -- 订单1 有两个物品
    (1, 1, 1, 2, 49.99),
    -- 第1个物品：乐高套装
    (1, 2, 3, 1, 19.99),
    -- 第2个物品：芭比娃娃
    -- 订单2 有两个物品  
    (2, 1, 2, 1, 29.99),
    -- 第1个物品：遥控车
    (2, 2, 4, 2, 15.99),
    -- 第2个物品：泰迪熊
    -- 订单3 有一个物品
    (3, 1, 5, 1, 12.50),
    -- 第1个物品：拼图
    -- 订单4 有两个物品
    (4, 1, 1, 1, 49.99),
    -- 第1个物品：乐高套装
    (4, 2, 2, 1, 29.99);
-- 第2个物品：遥控车
/* select */
SELECT oi.order_item as 物品序号,
    p.prod_name as 产品名称,
    oi.quantity as 数量,
    oi.item_price as 单价,
    (oi.quantity * oi.item_price) as 小计
FROM order_items oi
    JOIN products p ON oi.prod_id = p.prod_id
WHERE oi.order_num = 2
ORDER BY oi.order_item;
-- 检索单个列
SELECT prod_name
FROM Products;
-- 检索多个列
SELECT prod_id,
    prod_name,
    prod_price
FROM Products;
-- 检索所有列
SELECT *
FROM Products;
-- 检索不同的值
SELECT DISTINCT vend_id
FROM products;
SELECT DISTINCT vend_id,
    prod_price
FROM Products;
SELECT vend_id,
    prod_price
FROM Products;
-- 限制结果
-- SQL Server
SELECT TOP 5 prod_name
FROM Products;
-- DB2
SELECT prod_name
FROM Products
FETCH FIRST 5 ROWS ONLY;
-- Oracle
SELECT prod_name
FROM Products
WHERE ROWNUM <= 5;
-- MySQL、MariaDB、PostgreSQL 或者 SQLite
SELECT prod_name
FROM Products
LIMIT 4;
SELECT prod_name
FROM Products -- 从第2行开始，返回3行
LIMIT 3 OFFSET 2;
SELECT prod_name
FROM Products -- 从第2行开始，返回3行
LIMIT 2, 3;
-- 3. 排序检索数据
-- 排序数据
SELECT prod_name
FROM Products
ORDER BY prod_name;
-- 按多个列排序
SELECT prod_id,
    prod_price,
    prod_name
FROM Products
ORDER BY prod_price,
    prod_name;
-- 按列位置排序
SELECT prod_id,
    prod_price,
    prod_name
FROM Products
ORDER BY 2,
    3;
-- 指定排序方向
SELECT prod_id,
    prod_price,
    prod_name
FROM Products
ORDER BY prod_price DESC;
SELECT prod_id,
    prod_price,
    prod_name
FROM Products
ORDER BY prod_price DESC,
    prod_name;
-- 4.过滤数据
-- 使用 WHERE 子句
SELECT prod_name,
    prod_price
FROM Products
WHERE prod_price = 49.99;
-- 检查单个值
SELECT prod_name,
    prod_price
FROM Products
WHERE prod_price < 20;
-- 不匹配检查
SELECT vend_id,
    prod_name
FROM products
WHERE vend_id <> 1;
SELECT vend_id,
    prod_name
FROM Products
WHERE vend_id != 2;
-- 范围值检查
SELECT prod_name,
    prod_price
FROM products
WHERE prod_price BETWEEN 20 AND 30;
-- 空值检查
SELECT prod_name
FROM products
WHERE prod_price IS NULL;
-- 测试
SELECT prod_id,
    prod_name
FROM products
WHERE prod_price = 19.99;
SELECT prod_id,
    prod_name
FROM products
WHERE prod_price >= 19.99;
SELECT DISTINCT order_num
FROM order_items;
SELECT prod_name,
    prod_price
FROM products
WHERE prod_price BETWEEN 10 AND 30
ORDER BY prod_price DESC;
-- 5. 高级数据过滤
-- 组合 WHERE 子句
-- AND操作符
SELECT prod_id,
    prod_price,
    prod_name
FROM products
WHERE vend_id = 1
    AND prod_price < 30;
SELECT prod_id,
    prod_price,
    prod_name
FROM products
WHERE vend_id = 1
    OR vend_id = 3;
-- 求值顺序
-- AND 操作符优先级高于 OR
SELECT prod_name,
    prod_price
FROM products
WHERE (
        vend_id = 1
        OR vend_id = 3
    )
    AND prod_price >= 1;
-- IN 操作符
SELECT prod_name,
    prod_price
FROM products
WHERE vend_id IN (1, 2)
ORDER BY prod_name;
-- NOT 操作符
SELECT prod_name
FROM products
WHERE NOT vend_id = 1
ORDER BY prod_name;
-- 测试
SELECT vend_name
FROM vendors
WHERE vend_country = 'USA'
    AND vend_city = 'New York';
SELECT order_num,
    prod_id,
    quantity
FROM order_items
WHERE prod_id IN (1, 2)
    AND quantity > 1
ORDER BY prod_id,
    quantity DESC;
SELECT prod_name,
    prod_price
FROM products
WHERE prod_price > 10
    AND prod_price < 30
ORDER BY prod_price;
-- 6. 用通配符进行过滤
SELECT prod_id,
    prod_name
FROM products
WHERE prod_name LIKE 'T%';
SELECT prod_id,
    prod_name
FROM products
WHERE prod_name LIKE '%b%';
SELECT prod_name
FROM products
WHERE prod_name LIKE 'R%r';
/*
 注意后面所跟的空格
 有些 DBMS 用空格来填补字段的内容。例如，如果某列有 50 个字符，
 而存储的文本为 Fish bean bag toy（17 个字符），则为填满该列需
 要在文本后附加 33 个空格。这样做一般对数据及其使用没有影响，但
 是可能对上述 SQL 语句有负面影响。子句 WHERE prod_name LIKE
 'F%y'只匹配以 F 开头、以 y 结尾的 prod_name。如果值后面跟空格，
 则不是以 y 结尾，所以 Fish bean bag toy 就不会检索出来。简单
 的解决办法是给搜索模式再增加一个%号：'F%y%'还匹配 y 之后的字
 符（或空格）。更好的解决办法是用函数去掉空格
 */
-- 下划线（_）通配符，下划线的用途与%一样，但它只匹配单个字符，而不是多个字符
SELECT prod_id,
    prod_name
FROM Products
WHERE prod_name LIKE '______ Control Car';
-- 方括号（[ ]）通配符，方括号（[]）通配符用来指定一个字符集，它必须匹配指定位置（通配符的位置）的一个字符
-- 微软的 SQL Server 支持集合，但是 MySQL，Oracle，DB2，SQLite都不支持
SELECT cust_name
FROM customers
WHERE cust_name LIKE '[JM]%'
ORDER BY cust_name;
SELECT cust_name
FROM customers
WHERE cust_name LIKE 'J%'
    OR cust_name LIKE 'M%'
ORDER BY cust_name;
SELECT cust_name
FROM customers
WHERE NOT cust_name LIKE 'J%'
ORDER BY cust_name;
-- 测试
SELECT prod_name,
    prod_desc
FROM products
WHERE prod_desc LIKE '%doll%';
SELECT prod_name,
    prod_desc
FROM products
WHERE NOT prod_desc LIKE '%doll%'
ORDER BY prod_name;
SELECT prod_name,
    prod_desc
FROM products
WHERE prod_desc LIKE '%teddy%'
    AND prod_desc LIKE '%bear%';
SELECT prod_name,
    prod_desc
FROM products
WHERE prod_desc LIKE '%teddy%bear%';
-- 7.创建计算字段
-- 拼接
-- 使用 + 或 ||
SELECT vend_name + '(' + vend_country + ')'
FROM vendors
ORDER BY vend_name;
-- 使用 concat() 函数(mysql,mariadb)，RTRIM() 函数去掉字符串右边的空格，LTRIM() 函数去掉字符串左边的空格，TRIM() 函数去掉字符串两边的空格
SELECT concat(RTRIM(vend_name), ' (', RTRIM(vend_country), ')')
FROM vendors
ORDER BY vend_name;
-- 使用别名
SELECT concat(RTRIM(vend_name), ' (', RTRIM(vend_country), ')') AS vend_title
FROM vendors
ORDER BY vend_name;
-- 执行算术计算
SELECT prod_id,
    quantity,
    item_price,
    quantity * item_price AS expanded_price
FROM order_items
WHERE order_num = 1
ORDER BY expanded_price DESC;
-- 测试
SELECT vend_id,
    vend_name AS vname,
    vend_address AS vaddress,
    vend_city AS vcity
FROM vendors
ORDER BY vname;
SELECT prod_id,
    prod_price,
    prod_price *.9 AS sale_price
FROM products
ORDER BY prod_price DESC;
-- 8.使用函数处理数据
SELECT vend_name,
    UPPER(vend_name) AS vend_name_upcase
FROM vendors
ORDER BY vend_name;
-- SOUNDEX()得能对字符串进行发音比较而不是字母比较
SELECT cust_name,
    cust_contact
FROM customers
WHERE SOUNDEX(cust_name) = SOUNDEX('johnn Smith');
-- 日期和时间处理函数
SELECT order_num,
    order_date
FROM Orders
WHERE YEAR(order_date) = 2024;
-- 测试
SELECT cust_id,
    cust_name AS customer_name,
    UPPER(CONCAT(LEFT(cust_name, 2), LEFT(cust_city, 3))) AS user_login
FROM customers;
SELECT order_num,
    order_date
FROM orders
WHERE YEAR(order_date) = 2024
    AND MONTH(order_date) = 3
    AND DAY(order_date) <= 22
ORDER BY order_date;
-- 9.汇总数据
-- 聚集函数
/*
 AVG() 返回某列的平均值
 COUNT() 返回某列的行数
 MAX() 返回某列的最大值
 MIN() 返回某列的最小值
 SUM() 返回某列值之和
 */
SELECT AVG(prod_price) AS avg_price
FROM products;
SELECT AVG(prod_price) AS avg_price
FROM Products
WHERE vend_id = 1;
SELECT COUNT(*) AS num_cust
FROM customers;
SELECT COUNT(cust_email) AS num_cust
FROM customers;
SELECT MAX(prod_price) AS max_price
FROM products;
SELECT MIN(prod_price) AS min_price
FROM products;
SELECT SUM(quantity) AS items_ordered
FROM order_items
WHERE order_num = 2;
SELECT SUM(item_price * quantity) AS total_price
FROM order_items
WHERE order_num = 2;
-- 聚集不同值
SELECT AVG(DISTINCT prod_price) AS avg_price
FROM products
WHERE vend_id = 2;
-- 组合聚集函数
SELECT COUNT(*) AS num_items,
    MIN(prod_price) AS price_min,
    MAX(prod_price) AS price_max,
    AVG(prod_price) AS price_avg
FROM products;
-- 测试
SELECT SUM(quantity) AS total_prod
FROM order_items;
SELECT SUM(quantity) AS total_prod
FROM order_items
WHERE prod_id = 1;
SELECT MAX(prod_price) AS max_price
FROM products
WHERE prod_price <= 20;
-- 分组数据
-- 数据分组
SELECT vend_id,
    COUNT(*) AS num_prods
FROM products
GROUP BY vend_id;
-- 过滤分组
SELECT cust_id,
    COUNT(*) AS orders
FROM orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;
SELECT vend_id,
    COUNT(*) AS num_prods
FROM Products
WHERE prod_price >= 4
GROUP BY vend_id
HAVING COUNT(*) >= 2;
-- 分组和排序
SELECT order_num,
    COUNT(*) AS items
FROM order_items
GROUP BY order_num
HAVING COUNT(*) >= 1;
SELECT order_num,
    COUNT(*) AS items
FROM order_items
GROUP BY order_num
HAVING COUNT(*) >= 1
ORDER BY items,
    order_num;
-- SELECT子句顺序
/*
 子 句     -- 说 明            -- 是否必须使用
 SELECT   -- 要返回的列或表达式  -- 是
 FROM     -- 从中检索数据的表    -- 仅在从表选择数据时使用
 WHERE    -- 行级过滤           -- 否
 GROUP BY -- 分组说明           -- 仅在按组计算聚集时使用
 HAVING   -- 组级过滤           -- 否
 ORDER BY -- 输出排序顺序        -- 否
 */

-- 测试

SELECT order_num,COUNT(*) AS order_lines
FROM order_items
GROUP BY order_num
ORDER BY order_lines;

SELECT vend_id,MIN(prod_price) AS cheapest_item
FROM products
GROUP BY vend_id
ORDER BY cheapest_item;

SELECT order_num
FROM order_items
GROUP BY order_num
HAVING SUM(quantity) >= 2;

SELECT order_num,SUM(quantity * item_price) AS total_price
FROM order_items
GROUP BY order_num
HAVING SUM(quantity * item_price) > 100
ORDER BY order_num;

-- 使用子查询

