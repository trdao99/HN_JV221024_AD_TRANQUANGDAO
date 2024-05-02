DROP database if exists quanlybanhang;
create database QUANLYBANHANG;
use QUANLYBANHANG;
create table CUSTOMERS
(
    customerID varchar(4) primary key not null,
    name       varchar(100)           not null,
    email      varchar(100) unique    not null,
    phone      varchar(25)            not null unique,
    address    varchar(255)           not null
);
create table ORDERS
(
    order_id     varchar(4) not null primary key,
    customer_id  varchar(4) not null references CUSTOMERS (customerID),
    order_date   date       not null,
    total_amount double     not null
);
create table PRODUCTS
(
    product_id  varchar(4) primary key not null,
    name        varchar(255)           not null,
    description text,
    price       double                 not null,
    status      bit(1) default 1       not null
);
create table ORDERS_DETAILS
(
    order_id   varchar(4) not null references ORDERS (order_id),
    product_id varchar(4) not null references PRODUCTS (product_id),
    quantity   int(11)    not null,
    price      double     not null,
    primary key (order_id, product_id)
);

insert into CUSTOMERS(customerID, name, email, phone, address) VALUE
    ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gamil.com', 984756322, 'Cầu Giấy, Hà Nội'),
    ('C002', 'Hồ Hải Nam', 'namhh@gamil.com', 984875926, 'Cầu Giấy, Hà Nội'),
    ('C003', 'Tô Ngọc Vũ', 'vutn@gamil.com', 904725784, 'Cầu Giấy, Hà Nội'),
    ('C004', 'Phạm Ngọc Anh', 'anhpn@gamil.com', 984635365, 'Cầu Giấy, Hà Nội'),
    ('C005', 'Trương Minh Cường', 'cuongtm@gamil.com', 989735624, 'Cầu Giấy, Hà Nội');

insert into products (product_id, name, description, price)
values ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999),
       ('P002', 'Dell Vostro V3510 Core i5', 'RAM 8GB', 14999999),
       ('P003', 'Macbook Pro M2 8CPU 10GPU', '8GB 256GB', 28999999),
       ('P004', 'Apple Watch Ultra TTitanium Alpine Loop Smaill', '', 18999999),
       ('P005', 'Airpods 2 2022 Spatial Audio', '', 4090000);

insert into orders (order_id, customer_id, total_amount, order_date)
    value ('H001', 'C001', 52999997, '2023-02-22'),
    ('H002', 'C001', 80999997, '2023-03-11'),
    ('H003', 'C002', 54359998, '2023-01-22'),
    ('H004', 'C003', 102999995, '2023-03-14'),
    ('H005', 'C003', 80999997, '2022-03-12'),
    ('H006', 'C004', 110449994, '2023-02-01'),
    ('H007', 'C004', 79999996, '2023-03-29'),
    ('H008', 'C005', 29999998, '2023-02-14'),
    ('H009', 'C005', 28999999, '2023-01-10'),
    ('H010', 'C005', 149999994, '2023-04-01');

insert into orders_details (order_id, product_id, price, quantity)
    value
    ('H001', 'P002', 14999999, 1),
    ('H001', 'P004', 18999999, 2),
    ('H002', 'P001', 22999999, 1),
    ('H002', 'P003', 28999999, 2),
    ('H003', 'P004', 18999999, 2),
    ('H003', 'P005', 40900001, 4),
    ('H004', 'P002', 14999999, 3),
    ('H004', 'P003', 28999999, 2),
    ('H005', 'P001', 22999999, 1),
    ('H005', 'P003', 28999999, 2),
    ('H006', 'P005', 40900001, 5),
    ('H006', 'P002', 14999999, 6),
    ('H007', 'P004', 18999999, 3),
    ('H007', 'P001', 22999999, 1),
    ('H008', 'P002', 14999999, 2),
    ('H009', 'P003', 28999999, 1),
    ('H010', 'P003', 28999999, 2),
    ('H010', 'P001', 22999999, 4);

# Bài 3: Truy vấn dữ liệu [30 điểm]:
# 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
select name, email, phone, address
from customers;
# 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).
select name, phone, address
from customers
         join ORDERS O on customers.customerID = O.customer_id
where month(order_date) = 3;
# 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
# tháng và tổng doanh thu ).
select month(order_date) tháng, sum(total_amount) 'tổng doanh thu'
from orders
where year(order_date) = 2023
group by month(order_date)
order by month(order_date);
# 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
# hàng, địa chỉ , email và số điên thoại).
select name, phone, email, address
from customers
where not CUSTOMERS.customerID in (select customerID
                                   from customers
                                            join ORDERS O on customers.customerID = O.customer_id
                                   where month(order_date) = 2);
# 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
# sản phẩm, tên sản phẩm và số lượng bán ra).
select PRODUCTS.product_id, name, sum(quantity)
from products
         join ORDERS_DETAILS OD on products.product_id = OD.product_id
         join ORDERS O on O.order_id = OD.order_id
where month(order_date) = 3
group by PRODUCTS.product_id;
# 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
# tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
select customerID, name, sum(total_amount) 'mức chi tiêu'
from orders
         join CUSTOMERS C on C.customerID = orders.customer_id
where year(order_date) = 2023
group by customerID, name
order by sum(total_amount) desc;

# 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
# tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) .
select name, sum(total_amount) 'tổng tiền', order_date 'ngày tạo hoá đơn', sum(quantity) 'tổng số lượng sản phẩm'
from orders
         join ORDERS_DETAILS OD on orders.order_id = OD.order_id
         join CUSTOMERS C on C.customerID = orders.customer_id
group by OD.order_id
having sum(quantity) >= 5;

# Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
# tiền và ngày tạo hoá đơn .
create view V_ODER_CUSTOMER AS
SELECT name, phone, address, SUM(total_amount) 'tổng tiền', order_date 'ngày tạo hoá đơn'
FROM orders
         JOIN CUSTOMERS C on C.customerID = orders.customer_id
GROUP BY name, order_id;

SELECT *
FROM V_ODER_CUSTOMER;
# 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
# số đơn đã đặt.
CREATE VIEW V_TOTALODER_CUSTOMER AS
SELECT c.name, c.phone, c.address, COUNT(o.order_id) AS 'tổng số đơn đã đặt.'
FROM CUSTOMERS c
         JOIN ORDERS o ON c.customerID = o.customer_id
GROUP BY c.customerID, c.name;

SELECT *
FROM V_TOTALODER_CUSTOMER;
# 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
# bán ra của mỗi sản phẩm.
CREATE VIEW V_SOLDED_PRODUCT AS
SELECT name, description, PRODUCTS.price, SUM(quantity)
FROM PRODUCTS
         JOIN ORDERS_DETAILS OD on PRODUCTS.product_id = OD.product_id
GROUP BY PRODUCTS.product_id;
SELECT *
FROM V_SOLDED_PRODUCT;
# 4. Đánh Index cho trường `phone` và `email` của bảng Customer.
CREATE INDEX idx_phone ON customers (phone);
CREATE INDEX idx_email ON customers (email);
# 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
delimiter //
create procedure P_CUSTOMER_DETAL(customerID_IN varchar(4))
begin
    select * from customers where customerID = customerID_IN;
end //

# 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
delimiter //
create procedure P_PRODUCT_DETAL(product_id_IN varchar(4))
begin
    select * from PRODUCTS where product_id = product_id_IN;
end //

# 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
delimiter //
create procedure P_ODER(customerID_IN varchar(4))
begin
    select * from ORDERS where customer_id = customerID_IN;
end //
# 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
# tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
delimiter //
create procedure P_INSERT_ODER(order_id_IN varchar(4),
                               customer_id_IN varchar(4),
                               order_date_IN date,
                               total_amount_IN double)
begin
    INSERT INTO ORDERS(ORDER_ID, CUSTOMER_ID, ORDER_DATE, TOTAL_AMOUNT) VALUE (order_id_IN,
                                                                               customer_id_IN,
                                                                               order_date_IN,
                                                                               total_amount_IN);
end //
# 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
# thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc.*
CREATE PROCEDURE COUNT_SALE_PRODUCT( startDate DATE, endDate DATE)
BEGIN
    SELECT P.product_id, P.name, SUM(OD.quantity) AS total_quantity
    FROM PRODUCTS P
              JOIN ORDERS_DETAILS OD ON P.product_id = OD.product_id
              JOIN ORDERS O ON OD.order_id = O.order_id
    WHERE O.order_date >= startDate
      AND O.order_date <= endDate
    GROUP BY P.product_id, P.name;
END;
CALL COUNT_SALE_PRODUCT(2023-01-01, 2024-01-01);
# 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
# giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê.
DELIMITER //
CREATE PROCEDURE COUNT_PRODUCT_BY_YEAR( YEAR_IN INT)
BEGIN
    SELECT name, COUNT(quantity)
    FROM PRODUCTS P
             JOIN ORDERS_DETAILS OD ON P.product_id = OD.product_id
             JOIN ORDERS O on O.order_id = OD.order_id
    WHERE YEAR(order_date) = YEAR_IN
    GROUP BY P.product_iD;
END;
CALL COUNT_PRODUCT_BY_YEAR('2023');
