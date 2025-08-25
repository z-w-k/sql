-- 自 SQL 必知必会 第 5 版 学习笔记,使用 MySQL 8.0 版本
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
create table OrderItems (
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
INSERT INTO OrderItems (
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
FROM OrderItems oi
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
FROM OrderItems;
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
FROM OrderItems
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
FROM OrderItems
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
FROM OrderItems
WHERE order_num = 2;
SELECT SUM(item_price * quantity) AS total_price
FROM OrderItems
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
FROM OrderItems;
SELECT SUM(quantity) AS total_prod
FROM OrderItems
WHERE prod_id = 1;
SELECT MAX(prod_price) AS max_price
FROM products
WHERE prod_price <= 20;
-- 10.分组数据
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
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 1;
SELECT order_num,
    COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 1
ORDER BY items,
    order_num;
-- 11.SELECT子句顺序
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
SELECT order_num,
    COUNT(*) AS order_lines
FROM OrderItems
GROUP BY order_num
ORDER BY order_lines;
SELECT vend_id,
    MIN(prod_price) AS cheapest_item
FROM products
GROUP BY vend_id
ORDER BY cheapest_item;
SELECT order_num
FROM OrderItems
GROUP BY order_num
HAVING SUM(quantity) >= 2;
SELECT order_num,
    SUM(quantity * item_price) AS total_price
FROM OrderItems
GROUP BY order_num
HAVING SUM(quantity * item_price) > 100
ORDER BY order_num;
-- 使用子查询
SELECT order_num
FROM OrderItems
WHERE prod_id = 1;
SELECT cust_id
FROM orders
WHERE order_num IN (
        SELECT order_num
        FROM OrderItems
        WHERE prod_id = 1
    );
SELECT cust_name,
    cust_contact
FROM customers
WHERE cust_id IN (
        SELECT cust_id
        FROM orders
        WHERE order_num IN (
                SELECT order_num
                FROM OrderItems
                WHERE prod_id = 1
            )
    )
ORDER BY cust_id;
-- 作为计算字段使用子查询
select cust_name,
    cust_state,
    (
        SELECT COUNT(*)
        FROM orders
        WHERE orders.cust_id = customers.cust_id
    ) AS orders
FROM customers
ORDER BY cust_name;
-- 测试
SELECT cust_name
FROM customers
WHERE cust_id IN (
        SELECT cust_id
        FROM orders
        WHERE orders.order_num IN (
                SELECT order_num
                FROM OrderItems
                WHERE OrderItems.item_price >= 30
            )
    );
SELECT cust_id,
    order_date
FROM orders
WHERE order_num IN (
        SELECT order_num
        FROM OrderItems
        WHERE prod_id = 1
    )
ORDER BY order_date;
SELECT cust_name,
    cust_email
FROM customers
WHERE cust_id IN(
        SELECT cust_id
        FROM orders
        WHERE order_num IN (
                SELECT order_num
                FROM OrderItems
                WHERE prod_id = 1
            )
    )
ORDER BY cust_name;
SELECT cust_id,
    COUNT(order_num) AS order_count,
    SUM(total_ordered) AS customer_total
FROM (
        SELECT cust_id,
            order_num,
            (
                SELECT SUM(quantity * item_price)
                FROM OrderItems
                WHERE order_num = orders.order_num
            ) AS total_ordered
        FROM orders
    ) AS order_totals
GROUP BY cust_id
ORDER BY customer_total DESC;
SELECT prod_name,
    (
        SELECT SUM(quantity)
        FROM OrderItems
        WHERE OrderItems.prod_id = products.prod_id
    ) AS quant_sold
FROM products
ORDER BY quant_sold DESC;
-- 12. 联结表
SELECT vend_name,
    prod_name,
    prod_price
FROM vendors,
    products
WHERE vendors.vend_id = products.vend_id;
-- inner join
SELECT vend_name,
    prod_name,
    prod_price
FROM vendors
    INNER JOIN products ON vendors.vend_id = products.vend_id;
-- 联结多个表
SELECT prod_name,
    vend_name,
    prod_price,
    quantity
FROM products,
    vendors,
    OrderItems
WHERE products.vend_id = vendors.vend_id
    AND products.prod_id = OrderItems.prod_id
    AND OrderItems.order_num = 1;
SELECT cust_name,
    cust_contact
FROM customers,
    orders,
    OrderItems
WHERE customers.cust_id = orders.cust_id
    AND orders.order_num = OrderItems.order_num
    AND OrderItems.prod_id = 2;
-- 测试
SELECT cust_name,
    order_num
FROM customers,
    orders
WHERE customers.cust_id = orders.cust_id
ORDER BY cust_name,
    order_num;
SELECT cust_name,
    order_num
FROM customers
    INNER JOIN orders ON customers.cust_id = orders.cust_id
ORDER BY cust_name,
    order_num;
SELECT cust_name,
    order_num,
    (
        SELECT SUM(quantity * item_price)
        FROM OrderItems
        WHERE OrderItems.order_num = orders.order_num
    ) AS order_total
FROM customers,
    orders
WHERE customers.cust_id = orders.cust_id
ORDER BY cust_name,
    order_num;
SELECT cust_name,
    orders.order_num,
    SUM(OrderItems.quantity * OrderItems.item_price) AS order_total
FROM customers,
    orders,
    OrderItems
WHERE customers.cust_id = orders.cust_id
    AND orders.order_num = OrderItems.order_num
GROUP BY cust_name,
    orders.order_num
ORDER BY cust_name,
    orders.order_num;
SELECT cust_name,
    orders.order_num,
    SUM(OrderItems.quantity * OrderItems.item_price) AS order_total
FROM customers
    INNER JOIN orders ON customers.cust_id = orders.cust_id
    INNER JOIN OrderItems ON orders.order_num = OrderItems.order_num
GROUP BY cust_name,
    orders.order_num
ORDER BY cust_name,
    orders.order_num;
SELECT o.cust_id,
    c.cust_name,
    p.prod_name,
    SUM(oi.quantity) AS quantity,
    o.order_date
FROM orders o,
    OrderItems oi,
    products p,
    customers c
WHERE o.order_num = oi.order_num
    AND oi.prod_id = p.prod_id
    AND c.cust_id = o.cust_id
    AND oi.prod_id = 1
GROUP BY o.cust_id,
    c.cust_name,
    p.prod_name,
    o.order_date
ORDER BY o.order_date;
SELECT o.cust_id,
    c.cust_name,
    p.prod_name,
    SUM(oi.quantity) AS quantity,
    o.order_date
FROM orders o
    INNER JOIN OrderItems oi ON o.order_num = oi.order_num
    INNER JOIN products p ON oi.prod_id = p.prod_id
    INNER JOIN customers c ON o.cust_id = c.cust_id
WHERE oi.prod_id = 1
GROUP BY o.cust_id,
    c.cust_name,
    p.prod_name,
    o.order_date
ORDER BY o.order_date;
SELECT orders.cust_id,
    customers.cust_email,
    orders.order_date
FROM orders,
    OrderItems,
    customers
WHERE orders.order_num = OrderItems.order_num
    AND customers.cust_id = orders.cust_id
    AND OrderItems.prod_id = 1
ORDER BY order_date;
SELECT orders.cust_id,
    customers.cust_email,
    orders.order_date
FROM orders
    INNER JOIN OrderItems ON orders.order_num = OrderItems.order_num
    INNER JOIN customers ON orders.cust_id = customers.cust_id
WHERE OrderItems.prod_id = 1
ORDER BY order_date;
SELECT o.cust_id,
    o.order_num,
    SUM(oi.quantity * oi.item_price) AS total_price
FROM orders o,
    OrderItems oi
WHERE o.order_num = oi.order_num
GROUP BY o.cust_id,
    o.order_num
HAVING SUM(oi.quantity * oi.item_price) > 50
ORDER BY o.order_num;
SELECT o.cust_id,
    o.order_num,
    SUM(oi.quantity * oi.item_price) AS total_price,
    c.cust_name
FROM orders o
    INNER JOIN OrderItems oi ON o.order_num = oi.order_num
    INNER JOIN customers c ON o.cust_id = c.cust_id
GROUP BY o.cust_id,
    o.order_num
HAVING SUM(oi.quantity * oi.item_price) > 50
ORDER BY c.cust_name;
-- 13. 创建高级联结
-- 使用不同类型的联结
-- 自联结
SELECT c1.cust_id,
    c1.cust_name,
    c1.cust_contact,
    c1.cust_email,
    c1.cust_country
FROM customers AS c1,
    customers AS c2
WHERE c1.cust_country = c2.cust_country
    AND c2.cust_id = 1;
-- 自然联结
SELECT C.*,
    O.order_num,
    O.order_date,
    OI.prod_id,
    OI.quantity,
    OI.item_price
FROM customers AS C,
    Orders AS O,
    OrderItems AS OI
WHERE C.cust_id = O.cust_id
    AND OI.order_num = O.order_num
    AND prod_id = 1;
-- 外联结
SELECT c.cust_id,
    o.order_num
FROM orders o
    LEFT OUTER JOIN customers c ON o.cust_id = c.cust_id;
SELECT c.cust_id,
    o.order_num
FROM orders o
    RIGHT OUTER JOIN customers c ON o.cust_id = c.cust_id;
-- 全外联结
SELECT Customers.cust_id,
    Orders.order_num
FROM Customers
    FULL OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id;
-- 使用带聚集函数的联结
SELECT c.cust_id,
    COUNT(o.order_num) AS order_count
FROM customers AS c
    LEFT OUTER JOIN orders AS o ON c.cust_id = o.cust_id
GROUP BY c.cust_id
ORDER BY order_count DESC;
-- 测试
SELECT c.cust_name,
    o.order_num
FROM customers AS c
    INNER JOIN orders AS o ON c.cust_id = o.cust_id
ORDER BY c.cust_name,
    o.order_num;
SELECT c.cust_name,
    o.order_num
FROM customers AS c
    LEFT OUTER JOIN orders AS o ON c.cust_id = o.cust_id
ORDER BY c.cust_name,
    o.order_num;
SELECT prod_name,
    order_num
FROM products AS p
    LEFT OUTER JOIN OrderItems AS oi ON p.prod_id = oi.prod_id
ORDER BY p.prod_name;
SELECT prod_name,
    COUNT(order_num) AS order_count
FROM products AS p
    LEFT OUTER JOIN OrderItems AS oi ON p.prod_id = oi.prod_id
GROUP BY prod_name
ORDER BY p.prod_name;
SELECT v.vend_id,
    SUM(oi.quantity) AS total_quantity
FROM vendors AS v
    INNER JOIN products AS p ON v.vend_id = p.vend_id
    INNER JOIN OrderItems AS oi ON oi.prod_id = p.prod_id
GROUP BY v.vend_id
ORDER BY v.vend_id;
-- 14. 组合查询
-- 任何具有多个WHERE 子句的 SELECT 语句都可以作为一个组合查询
-- 创建组合查询
-- 可用 UNION 操作符来组合数条 SQL 查询。利用 UNION，可给出多条SELECT语句，将它们的结果组合成一个结果集
-- 使用UNION
SELECT cust_name,
    cust_contact,
    cust_email
FROM customers
WHERE cust_state IN ('MA', 'CA', 'WA')
UNION
SELECT cust_name,
    cust_contact,
    cust_email
FROM customers
WHERE cust_name = 'John Smith';
-- 包含或取消重复的行
SELECT cust_name,
    cust_contact,
    cust_email
FROM customers
WHERE cust_state IN ('MA', 'CA', 'WA')
UNION ALL
SELECT cust_name,
    cust_contact,
    cust_email
FROM customers
WHERE cust_name = 'John Smith';
-- 对组合查询结果排序
SELECT cust_name,
    cust_contact,
    cust_email
FROM customers
WHERE cust_state IN ('MA', 'CA', 'WA')
UNION
SELECT cust_name,
    cust_contact,
    cust_email
FROM customers
WHERE cust_name = 'John Smith';
ORDER BY cust_name,
    cust_contact;
-- 测试
SELECT oi.prod_id,
    quantity
FROM OrderItems AS oi
    INNER JOIN products AS p ON oi.prod_id = p.prod_id
WHERE oi.quantity > 2
UNION
SELECT oi.prod_id,
    quantity
FROM products AS p
    INNER JOIN OrderItems AS oi ON oi.prod_id = p.prod_id
WHERE p.prod_id = 1
ORDER BY prod_id;
SELECT oi.prod_id,
    quantity
FROM OrderItems AS oi
    INNER JOIN products AS p ON oi.prod_id = p.prod_id
WHERE oi.quantity > 2
    OR oi.prod_id <> 1
ORDER BY prod_id;
SELECT prod_name
FROM products
UNION
SELECT cust_name
FROM customers
ORDER BY prod_name;
-- 插入数据
-- 挑战
-- 挑战2 备份 Orders 表和 OrderItems 表
CREATE TABLE orders_backup AS
SELECT *
FROM orders;
-- 16. 更新和删除数据
-- 挑战
-- 1. 美国各州的缩写应始终用大写。编写 SQL语句来更新所有美国地址，包括供应商状态（Vendors 表中的 vend_state）和顾客状态（Customers表中的 cust_state），使它们均为大写。
UPDATE vendors AS v
SET vend_state = UPPER(v.vend_state);
UPDATE customers AS c
SET cust_state = UPPER(c.cust_state);
-- 2. 第 15 课的挑战题 1 要求你将自己添加到 Customers 表中。现在请删除自己。确保使用 WHERE 子句（在 DELETE 中使用它之前，先用 SELECT对其进行测试），否则你会删除所有顾客！
DELETE FROM customers
WHERE cust_name = 'z-w-k';
-- 17. 创建和操纵表
-- 17.1 创建表
CREATE TABLE Products (
    prod_id CHAR(10) NOT NULL,
    vend_id CHAR(10) NOT NULL,
    prod_name CHAR(254) NOT NULL,
    prod_price DECIMAL(8, 2) NOT NULL,
    prod_desc VARCHAR(1000) NULL
);
CREATE TABLE Orders (
    order_num INTEGER NOT NULL,
    order_date DATETIME NOT NULL,
    cust_id CHAR(10) NOT NULL
);
CREATE TABLE Vendors (
    vend_id CHAR(10) NOT NULL,
    vend_name CHAR(50) NOT NULL,
    vend_address CHAR(50),
    vend_city CHAR(50),
    vend_state CHAR(5),
    vend_zip CHAR(10),
    vend_country CHAR(50)
);
-- 指定默认值
CREATE TABLE OrderItems (
    order_num INTEGER NOT NULL,
    order_item INTEGER NOT NULL,
    prod_id CHAR(10) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    item_price DECIMAL(8, 2) NOT NULL
);
-- 更新表
ALTER TABLE Vendors
ADD vend_phone CHAR(20);
ALTER TABLE Vendors DROP COLUMN vend_phone;
-- 删除表
DROP TABLE cust_copy;
-- 重命名表
RENAME TABLE old_table_name TO new_table_name;
RENAME TABLE old_table1 TO new_table1,
old_table2 TO new_table2,
old_table3 TO new_table3;
ALTER TABLE old_table_name
    RENAME TO new_table_name;
ALTER TABLE old_table_name
    RENAME AS new_table_name;
-- 挑战题
-- 挑战1. 在 Vendors 表中添加一个网站列（vend_web）。你需要一个足以容纳URL 的大文本字段。
ALTER TABLE vendors
ADD vend_web TEXT;
-- 挑战2.使用 UPDATE 语句更新 Vendor 记录，以便加入网站（你可以编造任何地址）
UPDATE vendors AS v
SET vend_web = 'https://www.example.com';
-- 18. 使用视图
-- 视图
-- 视图是虚拟的表。与包含数据的表不一样，视图只包含使用时动态检索数据的查询
SELECT cust_name,
    cust_contact,
    prod_id
FROM customers,
    orders,
    OrderItems
WHERE customers.cust_id = orders.cust_id
    AND OrderItems.order_num = orders.order_num
    AND prod_id = 1;
-- 假如可以把整个查询包装成一个名为 ProductCustomers 的虚拟表，则可以如下轻松地检索出相同的数据：
SELECT cust_name,
    cust_contact
FROM ProductCustomers
WHERE prod_id = 'RGAN01';
-- 这就是视图的作用。ProductCustomers 是一个视图，作为视图，它不包含任何列或数据，包含的是一个查询（与上面用以正确联结表的查询相同）
-- 为什么使用视图
-- 重用 SQL 语句。
-- 简化复杂的 SQL 操作。在编写查询后，可以方便地重用它而不必知道其基本查询细节。
-- 使用表的一部分而不是整个表。
-- 保护数据。可以授予用户访问表的特定部分的权限，而不是整个表的访问权限。
-- 更改数据格式和表示。视图可返回与底层表的表示和格式不同的数据。
-- 性能问题
/*
 因为视图不包含数据，所以每次使用视图时，都必须处理查询执行时
 需要的所有检索。如果你用多个联结和过滤创建了复杂的视图或者嵌
 套了视图，性能可能会下降得很厉害。因此，在部署使用了大量视图
 的应用前，应该进行测试。
 */
-- 视图的规则和限制
/*
 与表一样，视图必须唯一命名（不能给视图取与别的视图或表相同的
 名字）。
 对于可以创建的视图数目没有限制。
 创建视图，必须具有足够的访问权限。这些权限通常由数据库管理人员授予。
 视图可以嵌套，即可以利用从其他视图中检索数据的查询来构造视图。所允许的嵌套层数在不同的 DBMS中有所不同（嵌套视图可能会严重降低查询的性能，因此在产品环境中使用之前，应该对其进行全面测试）。
 许多 DBMS 禁止在视图查询中使用 ORDER BY 子句。
 有些 DBMS 要求对返回的所有列进行命名，如果列是计算字段，则需要使用别名（关于列别名的更多信息，请参阅第 7 课）。
 视图不能索引，也不能有关联的触发器或默认值。
 有些 DBMS 把视图作为只读的查询，这表示可以从视图检索数据，但不能将数据写回底层表。详情请参阅具体的 DBMS 文档。
 有些 DBMS 允许创建这样的视图，它不能进行导致行不再属于视图的插入或更新。例如有一个视图，只检索带有电子邮件地址的顾客。如果更新某个顾客，删除他的电子邮件地址，将使该顾客不再属于视图。这是默认行为，而且是允许的，但有的 DBMS 可能会防止这种情况发生。
 */
-- 18.2 创建视图
-- 视图用 CREATE VIEW 语句来创建。与 CREATE TABLE 一样，CREATE VIEW只能用于创建不存在的视图。
/*
 视图重命名
 删除视图，可以使用 DROP 语句，其语法为 DROP VIEW viewname;。
 覆盖（或更新）视图，必须先删除它，然后再重新创建。
 */
--  18.2.1 利用视图简化复杂的联结
-- 一个最常见的视图应用是隐藏复杂的 SQL，这通常涉及联结。请看下面的例子：
CREATE VIEW ProductCustomers AS
SELECT cust_name,
    cust_contact,
    prod_id
FROM customers,
    orders,
    OrderItems
WHERE customers.cust_id = orders.cust_id
    AND OrderItems.order_num = orders.order_num;
SELECT cust_name,
    cust_contact
FROM ProductCustomers
WHERE prod_id = 1;
-- 用视图重新格式化检索出的数据
SELECT CONCAT(RTRIM(vend_name), ' (', RTRIM(vend_country), ')') AS vend_title
FROM Vendors
ORDER BY vend_name;
-- 用视图过滤数据
CREATE VIEW VendorLocations AS
SELECT CONCAT(RTRIM(vend_name), ' (', RTRIM(vend_country), ')') AS vend_title
FROM Vendors;
-- 用视图过滤不想要的数据
/*
 视图对于应用普通的 WHERE 子句也很有用。例如，可以定义 CustomerEMailList 视图，过滤没有电子邮件地址的顾客。为此，可使用下面的
 语句：
 */
CREATE VIEW CustomerEMailList AS
SELECT cust_id,
    cust_name,
    cust_email
FROM Customers
WHERE cust_email IS NOT NULL;
-- 使用视图与计算字段
/*
 在简化计算字段的使用上，视图也特别有用。下面是第 7 课中介绍的一
 条 SELECT 语句，它检索某个订单中的物品，计算每种物品的总价格：
 */
SELECT prod_id,
    quantity,
    item_price,
    quantity * item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008;
/*要将其转换为一个视图，如下进行：*/
CREATE VIEW OrderItemsExpanded AS
SELECT order_num,
    prod_id,
    quantity,
    item_price,
    quantity * item_price AS expanded_price
FROM OrderItems
    /* 检索订单 20008 的详细内容（上面的输出），如下进行： */
SELECT *
FROM OrderItemsExpanded
WHERE order_num = 20008;
-- 18.3 小结
/*
 视图为虚拟的表。它们包含的不是数据而是根据需要检索数据的查询。
 视图提供了一种封装 SELECT 语句的层次，可用来简化数据处理，重新
 格式化或保护基础数据
 */
-- 18.4 挑战题
/*
 1. 创建一个名为 CustomersWithOrders 的视图，其中包含 Customers
 表中的所有列，但仅仅是那些已下订单的列。提示：可以在 Orders
 表上使用 JOIN 来仅仅过滤所需的顾客，然后使用 SELECT 来确保拥
 有正确的数据。
 */
CREATE VIEW CustomersWithOrders AS
SELECT c.*
FROM customers AS c
    INNER JOIN orders AS o ON c.cust_id = o.cust_id;
-- 19. 使用存储过程
/* 介绍什么是存储过程，为什么要使用存储过程，如何使用存储过
 程，以及创建和使用存储过程的基本语法。 */
-- 19.1 存储过程
/*
 迄今为止，我们使用的大多数 SQL 语句都是针对一个或多个表的单条语
 句。并非所有操作都这么简单，经常会有一些复杂的操作需要多条语句
 才能完成，例如以下的情形。
 */
/*
 为了处理订单，必须核对以保证库存中有相应的物品。
 如果物品有库存，需要预定，不再出售给别的人，并且减少物品数据
 以反映正确的库存量。
 库存中没有的物品需要订购，这需要与供应商进行某种交互。
 关于哪些物品入库（并且可以立即发货）和哪些物品退订，需要通知
 相应的顾客。
 */
/*
 那么，怎样编写代码呢？可以单独编写每条 SQL 语句，并根据结果有条
 件地执行其他语句。在每次需要这个处理时（以及每个需要它的应用中），
 都必须做这些工作。
 */
/*
 可以创建存储过程。简单来说，存储过程就是为以后使用而保存的一条
 或多条 SQL 语句。可将其视为批文件，虽然它们的作用不仅限于批处理。
 */
-- 19.2 为什么要使用存储过程
/*
 通过把处理封装在一个易用的单元中，可以简化复杂的操作（如前面
 例子所述）。
  由于不要求反复建立一系列处理步骤，因而保证了数据的一致性。如
 果所有开发人员和应用程序都使用同一存储过程，则所使用的代码都
 是相同的。
  上一点的延伸就是防止错误。需要执行的步骤越多，出错的可能性就
 越大。防止错误保证了数据的一致性。
  简化对变动的管理。如果表名、列名或业务逻辑（或别的内容）有变
 化，那么只需要更改存储过程的代码。使用它的人员甚至不需要知道
 这些变化。
  上一点的延伸就是安全性。通过存储过程限制对基础数据的访问，减
 少了数据讹误（无意识的或别的原因所导致的数据讹误）的机会。
  因为存储过程通常以编译过的形式存储，所以 DBMS 处理命令所需的
 工作量少，提高了性能。
  存在一些只能用在单个请求中的 SQL 元素和特性，存储过程可以使用
 它们来编写功能更强更灵活的代码。
 */
/*
 换句话说，使用存储过程有三个主要的好处，即简单、安全、高性能。
 显然，它们都很重要。不过，在将 SQL 代码转换为存储过程前，也必须
 知道它的一些缺陷。
 */
/*
  不同 DBMS 中的存储过程语法有所不同。事实上，编写真正的可移植
 存储过程几乎是不可能的。不过，存储过程的自我调用（名字以及数
 据如何传递）可以相对保持可移植。因此，如果需要移植到别的DBMS，
 至少客户端应用代码不需要变动。
  一般来说，编写存储过程比编写基本 SQL 语句复杂，需要更高的技能，
 更丰富的经验。因此，许多数据库管理员把限制存储过程的创建作为
 安全措施（主要受上一条缺陷的影响）。
 */
/*
 尽管有这些缺陷，存储过程还是非常有用的，并且应该使用。事实上，
 多数 DBMS 都带有用于管理数据库和表的各种存储过程。
 */
-- 19.3 执行存储过程
/*
 存储过程的执行远比编写要频繁得多，因此我们先介绍存储过程的执行。
 执行存储过程的 SQL 语句很简单，即 EXECUTE。EXECUTE 接受存储过程
 名和需要传递给它的任何参数。请看下面的例子（你无法运行这个例子，
 因为 AddNewProduct 这个存储过程还不存在）：
 */
EXECUTE AddNewProduct(
    'JTS01',
    'Stuffed Eiffel Tower',
    6.49,
    'Plush stuffed toy with
➥the text La Tour Eiffel in red white and blue'
);
/*
 这里执行一个名为 AddNewProduct 的存储过程，将一个新产品添加到
 Products 表中。AddNewProduct 有四个参数，分别是：供应商 ID
 （Vendors 表的主键）、产品名、价格和描述。这 4 个参数匹配存储过程
 中 4 个预期变量（定义为存储过程自身的组成部分）。此存储过程将新行
 添加到 Products 表，并将传入的属性赋给相应的列
 */
/*
 我们注意到，在 Products 表中还有另一个需要值的列 prod_id 列，它
 是这个表的主键。为什么这个值不作为属性传递给存储过程？要保证恰
 当地生成此 ID，最好是使生成此 ID 的过程自动化（而不是依赖于最终
 用户的输入）。这也是这个例子使用存储过程的原因。以下是存储过程所
 完成的工作：
 */
/*
  验证传递的数据，保证所有 4 个参数都有值；
  生成用作主键的唯一 ID；
  将新产品插入 Products 表，在合适的列中存储生成的主键和传递的
 数据。
 */
/*
 这就是存储过程执行的基本形式。对于具体的 DBMS，可能包括以下的
 执行选择。
 */
/*
  参数可选，具有不提供参数时的默认值。
  不按次序给出参数，以“参数=值”的方式给出参数值。
  输出参数，允许存储过程在正执行的应用程序中更新所用的参数。
  用 SELECT 语句检索数据。
  返回代码，允许存储过程返回一个值到正在执行的应用程序。
 */
-- 19.4 创建存储过程
/*
 DELIMITER 是 MySQL 中的一个客户端命令，用于更改语句分隔符。它的主要作用是解决存储过程、函数、触发器等复合语句中的分号冲突问题。
 */
/*
 DELIMITER //
 
 CREATE PROCEDURE procedure_name([parameter_list])
 BEGIN
 -- 存储过程逻辑
 -- SQL 语句
 END //
 
 DELIMITER ;
 */
/*
 1. 创建不带参数的存储过程
 */
DELIMITER // CREATE PROCEDURE GetTotalProducts() BEGIN
SELECT COUNT(*) AS total_products
FROM products;
END // DELIMITER;
-- 调用存储过程
CALL GetTotalProducts();
/*
 2. 创建带输入参数的存储过程
 */
DELIMITER // CREATE PROCEDURE GetProductsByCategory(IN category_id INT) BEGIN
SELECT *
FROM products
WHERE category_id = category_id;
END // DELIMITER;
-- 调用带参数的存储过程
CALL GetProductsByCategory(1);
/*
 3. 创建带输出参数的存储过程
 */
DELIMITER // CREATE PROCEDURE GetProductCountByCategory(
    IN category_id INT,
    OUT product_count INT
) BEGIN
SELECT COUNT(*) INTO product_count
FROM products
WHERE category_id = category_id;
END // DELIMITER;
-- 调用并获取输出参数
CALL GetProductCountByCategory(1, @count);
SELECT @count AS product_count;
/*
 4. 创建带输入输出参数的存储过程
 */
DELIMITER // CREATE PROCEDURE UpdateProductPrice(
    INOUT price DECIMAL(10, 2),
    IN increase_percentage DECIMAL(5, 2)
) BEGIN
SET price = price * (1 + increase_percentage / 100);
END // DELIMITER;
-- 调用输入输出参数的存储过程
SET @current_price = 100.00;
CALL UpdateProductPrice(@current_price, 10);
SELECT @current_price AS new_price;
/*
 复杂的业务逻辑示例
 */
DELIMITER // CREATE PROCEDURE ProcessOrder(
    IN customer_id INT,
    IN product_id INT,
    IN quantity INT,
    OUT order_id INT,
    OUT status_message VARCHAR(100)
) BEGIN
DECLARE product_price DECIMAL(10, 2);
DECLARE total_amount DECIMAL(10, 2);
DECLARE stock_quantity INT;
-- 获取产品价格和库存
SELECT price,
    stock INTO product_price,
    stock_quantity
FROM products
WHERE id = product_id;
-- 检查库存
IF stock_quantity < quantity THEN
SET status_message = '库存不足';
SET order_id = NULL;
ELSE -- 计算总金额
SET total_amount = product_price * quantity;
-- 插入订单
INSERT INTO orders (customer_id, total_amount, order_date)
VALUES (customer_id, total_amount, NOW());
SET order_id = LAST_INSERT_ID();
-- 插入订单详情
INSERT INTO OrderItems (order_id, product_id, quantity, unit_price)
VALUES (order_id, product_id, quantity, product_price);
-- 更新库存
UPDATE products
SET stock = stock - quantity
WHERE id = product_id;
SET status_message = CONCAT('订单创建成功，订单号: ', order_id);
END IF;
END // DELIMITER;
/*
 查看和管理存储过程
 */
-- 查看所有存储过程
SHOW PROCEDURE STATUS
WHERE Db = 'your_database';
-- 查看存储过程的定义
SHOW CREATE PROCEDURE procedure_name;
-- 删除存储过程
DROP PROCEDURE IF EXISTS procedure_name;
-- 修改存储过程（需要先删除再创建）
DROP PROCEDURE IF EXISTS procedure_name;
CREATE PROCEDURE procedure_name() BEGIN...
END;
/*
 存储过程中的控制结构
 */
-- 条件判断
CREATE PROCEDURE CheckProductStatus(IN product_id INT) BEGIN
DECLARE product_stock INT;
DECLARE status VARCHAR(20);
SELECT stock INTO product_stock
FROM products
WHERE id = product_id;
IF product_stock > 50 THEN
SET status = '充足';
ELSEIF product_stock > 10 THEN
SET status = '正常';
ELSEIF product_stock > 0 THEN
SET status = '紧张';
ELSE
SET status = '缺货';
END IF;
SELECT status AS inventory_status;
END // -- 循环处理
CREATE PROCEDURE GenerateTestData() BEGIN
DECLARE i INT DEFAULT 1;
WHILE i <= 100 DO
INSERT INTO test_table (name, value)
VALUES (CONCAT('Item-', i), RAND() * 100);
SET i = i + 1;
END WHILE;
END // -- 错误处理
CREATE PROCEDURE SafeDeleteProduct(IN product_id INT) BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK;
SELECT '错误：删除产品时发生异常' AS result;
END;
START TRANSACTION;
-- 删除相关订单项
DELETE FROM OrderItems
WHERE product_id = product_id;
-- 删除产品
DELETE FROM products
WHERE id = product_id;
COMMIT;
SELECT '产品删除成功' AS result;
END //
/*
 最佳实践
 
 使用 DELIMITER：更改分隔符以避免与 SQL 语句中的分号冲突
 
 参数命名：使用有意义的参数名称
 
 错误处理：添加适当的错误处理机制
 
 注释：为存储过程添加注释说明功能
 
 权限控制：严格控制存储过程的执行权限
 
 性能优化：避免在存储过程中进行复杂的计算
 */
--  20.管理事务处理
/*
 事务的基本概念
 事务是一组要么全部成功要么全部失败的 SQL 操作，满足 ACID 特性：
 
 原子性（Atomicity）：事务中的所有操作要么全部完成，要么全部不完成
 
 一致性（Consistency）：事务前后数据库状态保持一致
 
 隔离性（Isolation）：多个事务并发执行时互不干扰
 
 持久性（Durability）：事务提交后，修改永久保存
 */
-- 20.1 事务处理
/*
 使用事务处理（transaction processing），通过确保成批的 SQL 操作要么
 完全执行，要么完全不执行，来维护数据库的完整性。
 */
/*
 关系数据库把数据存储在多个表中，使数据更容易操
 纵、维护和重用。不用深究如何以及为什么进行关系数据库设计，在某
 种程度上说，设计良好的数据库模式都是关联的。
 */
/*
 前面使用的 Orders 表就是一个很好的例子。订单存储在 Orders 和
 OrderItems 两个表中：Orders 存储实际的订单，OrderItems 存储订
 购的各项物品。这两个表使用称为主键（参阅第 1 章）的唯一 ID 互相关
 联，又与包含客户和产品信息的其他表相关联。
 */
/*
 给系统添加订单的过程如下：
 (1) 检查数据库中是否存在相应的顾客，如果不存在，添加他；
 (2) 检索顾客的 ID；
 (3) 在 Orders 表添加一行，它与顾客 ID 相关联；
 (4) 检索 Orders 表中赋予的新订单 ID；
 (5) 为订购的每个物品在 OrderItems 表中添加一行，通过检索出来的 ID
 把它与 Orders 表关联（并且通过产品 ID 与 Products 表关联）。
 */
/*
 现在假设由于某种数据库故障（如超出磁盘空间、安全限制、表锁等），
 这个过程无法完成。数据库中的数据会出现什么情况？
 如果故障发生在添加顾客之后，添加 Orders 表之前，则不会有什么问
 题。某些顾客没有订单是完全合法的。重新执行此过程时，所插入的顾
 客记录将被检索和使用。可以有效地从出故障的地方开始执行此过程。
 但是，如果故障发生在插入 Orders 行之后，添加 OrderItems 行之前，
 怎么办？现在，数据库中有一个空订单。
 更糟的是，如果系统在添加 OrderItems 行之时出现故障，怎么办？结
 果是数据库中存在不完整的订单，而你还不知道。
 如何解决这种问题？这就需要使用事务处理了。事务处理是一种机制，
 用来管理必须成批执行的 SQL 操作，保证数据库不包含不完整的操作结
 果。利用事务处理，可以保证一组操作不会中途停止，它们要么完全执
 行，要么完全不执行（除非明确指示）。如果没有错误发生，整组语句提
 交给（写到）数据库表；如果发生错误，则进行回退（撤销），将数据库
 恢复到某个已知且安全的状态。
 */
/*
 再看这个例子，这次我们说明这一过程是如何工作的：
 (1) 检查数据库中是否存在相应的顾客，如果不存在，添加他；
 (2) 提交顾客信息；
 (3) 检索顾客的 ID；
 (4) 在 Orders 表中添加一行；
 (5) 如果向 Orders 表添加行时出现故障，回退；
 (6) 检索 Orders 表中赋予的新订单 ID；
 (7) 对于订购的每项物品，添加新行到 OrderItems 表；
 (8) 如果向OrderItems添加行时出现故障，回退所有添加的OrderItems
 行和 Orders 行。
 */
/*
 在使用事务处理时，有几个反复出现的关键词。下面是关于事务处理需
 要知道的几个术语：
  事务（transaction）指一组 SQL 语句；
  回退（rollback）指撤销指定 SQL 语句的过程；
  提交（commit）指将未存储的 SQL 语句结果写入数据库表；
  保留点（savepoint）指事务处理中设置的临时占位符（placeholder），
 可以对它发布回退（与回退整个事务处理不同）。
 */
/*
 提示：可以回退哪些语句？
 事务处理用来管理 INSERT、UPDATE 和 DELETE 语句。不能回退 SELECT
 语句（回退 SELECT 语句也没有必要），也不能回退 CREATE 或 DROP 操
 作。事务处理中可以使用这些语句，但进行回退时，这些操作也不撤销。
 */
--  20.2 控制事务处理
/*
 管理事务的关键在于将 SQL 语句组分解为逻辑块，并明确规定数据何时
 应该回退，何时不应该回退。
 
 有的 DBMS 要求明确标识事务处理块的开始和结束。如在 SQL Server
 中，标识如下（省略号表示实际的代码）：
 输入▼
 BEGIN TRANSACTION
 ...
 COMMIT TRANSACTION
 分析▼
 在这个例子中，BEGIN TRANSACTION 和 COMMIT TRANSACTION 语句之
 间的 SQL 必须完全执行或者完全不执行。
 MariaDB 和 MySQL 中等同的代码为：
 START TRANSACTION
 ...
 
 多数实现没有明确标识事务处理在何处结束。事务一直存在，直到被中断。通常，COMMIT 用于保存更改，ROLLBACK 用于撤销，详述如下。
 */
--  20.2.1 使用ROLLBACK
/*
 SQL 的 ROLLBACK 命令用来回退（撤销）SQL 语句，请看下面的语句：
 */
DELETE FROM Orders;
ROLLBACK;
/*
 在此例子中，执行 DELETE 操作，然后用 ROLLBACK 语句撤销。虽然这不
 是最有用的例子，但它的确能够说明，在事务处理块中，DELETE 操作（与
 INSERT 和 UPDATE 操作一样）并不是最终的结果。
 */
-- 20.2.2 使用COMMIT
/*
 一般的 SQL 语句都是针对数据库表直接执行和编写的。这就是所谓的隐
 式提交（implicit commit），即提交（写或保存）操作是自动进行的。
 在事务处理块中，提交不会隐式进行。不过，不同 DBMS 的做法有所不
 同。有的 DBMS 按隐式提交处理事务端，有的则不这样。
 进行明确的提交，使用 COMMIT 语句。
 */
START TRANSACTION;
-- 开始事务
-- 一系列SQL操作
COMMIT;
-- 提交事务
/*
 完整的事务示例
 示例1：简单的转账操作
 */
-- 开始事务
START TRANSACTION;
-- 从账户A扣款
UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;
-- 向账户B存款
UPDATE accounts
SET balance = balance + 100
WHERE account_id = 2;
-- 记录交易日志
INSERT INTO transactions (
        from_account,
        to_account,
        amount,
        transaction_time
    )
VALUES (1, 2, 100, NOW());
-- 提交事务
COMMIT;
-- 20.2.3 使用保留点
/*
 使用简单的 ROLLBACK 和 COMMIT 语句，就可以写入或撤销整个事务。但
 是，只对简单的事务才能这样做，复杂的事务可能需要部分提交或回退。
 例如前面描述的添加订单的过程就是一个事务。如果发生错误，只需要
 返回到添加 Orders 行之前即可。不需要回退到 Customers 表（如果存
 在的话）。
 要支持回退部分事务，必须在事务处理块中的合适位置放置占位符。这
 样，如果需要回退，可以回退到某个占位符。
 */
/*
 在 SQL 中，这些占位符称为保留点。在 MariaDB、MySQL 和 Oracle 中
 创建占位符，可使用 SAVEPOINT 语句。
 */
SAVEPOINT delete1;
/*
 每个保留点都要取能够标识它的唯一名字，以便在回退时，DBMS 知道
 回退到何处。要回退到本例给出的保留点，在 SQL Server 中可如下进行。
 */
START TRANSACTION;
-- 操作1
UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;
-- 设置保存点
SAVEPOINT after_debit;
-- 操作2
UPDATE accounts
SET balance = balance + 100
WHERE account_id = 2;
-- 如果操作2失败，可以回滚到保存点
ROLLBACK TO SAVEPOINT after_debit;
-- 继续其他操作
INSERT INTO transactions (from_account, to_account, amount)
VALUES (1, 2, 100);
-- 提交事务
COMMIT;
/*
 提示：保留点越多越好
 可以在 SQL 代码中设置任意多的保留点，越多越好。为什么呢？因为
 保留点越多，你就越能灵活地进行回退。
 */
-- 20.3 小结
/*
 这一章介绍了事务是必须完整执行的 SQL 语句块。我们学习了如何使用
 COMMIT 和 ROLLBACK 语句对何时写数据、何时撤销进行明确的管理；还
 学习了如何使用保留点，更好地控制回退操作。事务处理是个相当重要
 的主题
 */
-- 21. 使用游标
/*
 游标是一种数据库对象，用于在 SQL 结果集中逐行遍历和处理数据。它允许你对查询返回的每一行数据进行单独的操作，就像编程语言中的循环遍历数组一样。
 */
/*
 在标准的 SQL 操作中，我们通常以集合为单位处理数据（一次处理多行）。但在某些场景下，我们需要：
 
 逐行处理数据
 
 基于每行数据执行复杂的业务逻辑
 
 在存储过程或函数中进行行级操作
 */
-- 21.1 游标
/*
 游标的基本生命周期
 声明游标（DECLARE） - 定义游标及其对应的查询
 
 打开游标（OPEN） - 执行查询并准备结果集
 
 获取数据（FETCH） - 逐行读取数据
 
 处理数据 - 对每行数据进行操作
 
 关闭游标（CLOSE） - 释放资源
 
 释放游标（DEALLOCATE） - 删除游标定义（可选）
 */
DELIMITER // CREATE PROCEDURE ProcessEmployees() BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE emp_id INT;
DECLARE emp_name VARCHAR(100);
DECLARE emp_salary DECIMAL(10, 2);
-- 1. 声明游标
DECLARE emp_cursor CURSOR FOR
SELECT id,
    name,
    salary
FROM employees
WHERE department = 'IT';
-- 声明异常处理器
DECLARE CONTINUE HANDLER FOR NOT FOUND
SET done = TRUE;
-- 创建临时表存储结果
CREATE TEMPORARY TABLE IF NOT EXISTS processed_employees (
    id INT,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    bonus DECIMAL(10, 2)
);
-- 2. 打开游标
OPEN emp_cursor;
-- 3. 循环获取数据
read_loop: LOOP FETCH emp_cursor INTO emp_id,
emp_name,
emp_salary;
IF done THEN LEAVE read_loop;
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
SELECT *
FROM processed_employees;
-- 清理临时表
DROP TEMPORARY TABLE processed_employees;
END // DELIMITER;
-- 游标的类型
-- 1. 只读游标（默认）
DECLARE cursor_name CURSOR FOR
SELECT...;
-- 2. 可更新游标
DECLARE cursor_name CURSOR FOR
SELECT...FOR
UPDATE;
-- 3. 敏感/不敏感游标
/*
 敏感游标：反映其他事务对数据的修改
 不敏感游标：使用游标打开时的数据快照
 */
-- 实际应用场景
/*场景1：数据迁移和转换*/
CREATE PROCEDURE MigrateOldData() BEGIN
DECLARE done INT DEFAULT 0;
DECLARE old_id,
    new_id INT;
DECLARE old_name VARCHAR(100);
DECLARE migrate_cursor CURSOR FOR
SELECT id,
    name
FROM old_employees;
DECLARE CONTINUE HANDLER FOR NOT FOUND
SET done = 1;
OPEN migrate_cursor;
migrate_loop: LOOP FETCH migrate_cursor INTO old_id,
old_name;
IF done THEN LEAVE migrate_loop;
END IF;
-- 复杂的转换逻辑
INSERT INTO new_employees (name, email, hire_date)
VALUES (
        old_name,
        CONCAT(
            LOWER(REPLACE(old_name, ' ', '.')),
            '@company.com'
        ),
        NOW()
    );
SET new_id = LAST_INSERT_ID();
-- 更新关联表
UPDATE employee_departments
SET employee_id = new_id
WHERE employee_id = old_id;
END LOOP;
CLOSE migrate_cursor;
END;
/* 场景2：复杂的计算和统计 */
CREATE PROCEDURE CalculateDepartmentStats() BEGIN
DECLARE done INT DEFAULT 0;
DECLARE dept_id INT;
DECLARE dept_name VARCHAR(100);
DECLARE total_salary DECIMAL(15, 2) DEFAULT 0;
DECLARE employee_count INT DEFAULT 0;
DECLARE dept_cursor CURSOR FOR
SELECT department_id,
    department_name
FROM departments;
DECLARE CONTINUE HANDLER FOR NOT FOUND
SET done = 1;
CREATE TEMPORARY TABLE dept_stats (
    department_id INT,
    department_name VARCHAR(100),
    total_salary DECIMAL(15, 2),
    avg_salary DECIMAL(15, 2),
    employee_count INT
);
OPEN dept_cursor;
dept_loop: LOOP FETCH dept_cursor INTO dept_id,
dept_name;
IF done THEN LEAVE dept_loop;
END IF;
-- 为每个部门计算统计信息
SELECT SUM(salary),
    COUNT(*) INTO total_salary,
    employee_count
FROM employees
WHERE department_id = dept_id;
INSERT INTO dept_stats
VALUES (
        dept_id,
        dept_name,
        total_salary,
        total_salary / NULLIF(employee_count, 0),
        employee_count
    );
END LOOP;
CLOSE dept_cursor;
SELECT *
FROM dept_stats
ORDER BY total_salary DESC;
DROP TEMPORARY TABLE dept_stats;
END;
-- 游标的优缺点
/*
 优点：
 ✅ 逐行处理复杂业务逻辑
 
 ✅ 支持基于行的条件判断和操作
 
 ✅ 在存储过程中实现复杂的数据处理流程
 
 ✅ 处理需要逐行验证或转换的数据
 
 缺点：
 ⚠️ 性能开销大：比集合操作慢很多
 
 ⚠️ 资源消耗：占用内存和数据库连接
 
 ⚠️ 锁问题：可能长时间锁定资源
 
 ⚠️ 复杂度高：代码比简单的 SQL 查询复杂
 */
-- 最佳实践
/*
 尽量避免使用游标：优先使用集合操作
 
 尽快关闭游标：减少资源占用时间
 
 使用合适的游标类型：根据需求选择只读或可更新
 
 添加适当的错误处理
 
 测试性能影响
 */
--  替代方案
/*
 在可能的情况下，尽量使用集合操作代替游标：
 */
-- 使用游标（不推荐）
-- 逐行更新员工奖金
-- 使用集合操作（推荐）
UPDATE employees
SET bonus = CASE
        WHEN salary > 10000 THEN salary * 0.1
        ELSE salary * 0.05
    END
WHERE department = 'IT';

-- 总结

/*
游标是一个强大的工具，但应该谨慎使用。它适用于：

复杂的逐行业务逻辑处理

数据迁移和转换

需要逐行验证的场景

在存储过程中实现复杂算法
*/


