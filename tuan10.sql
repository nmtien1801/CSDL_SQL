--1. Tạo view vw_Products_Info hiển thị danh sách các sản phẩm từ bảng
--Products và bảng Categories. Thông tin bao gồm CategoryName,
--Description, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock ?
--Thực hiện truy vấn dữ liệu từ View ?

create view vw_Products_Info
as 
select CategoryName, Description, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock 
from Products p join Categories c on p.CategoryID = c.CategoryID 

select * from vw_Products_Info

--2. Tạo view vw_CustomerTotals hiển thị tổng tiền các hóa đơn của mỗi
--khách hàng theo tháng và theo năm. Thông tin gồm CustomerID,
--YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month,
--SUM(UnitPrice*Quantity) ?

create view vw_CustomerTotals
as 
select c.CustomerID, YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(UnitPrice*Quantity) as sum
from Customers c join Orders o on o.CustomerID = c.CustomerID 
	join [Order Details] od on od.OrderID = o.OrderID
	group by c.CustomerID, YEAR(OrderDate) , MONTH(OrderDate) 

select * from vw_CustomerTotals

--3. Tạo view hiển thị tổng số lượng sản phẩm bán được của mỗi nhân viên
--theo từng năm. Thông tin gồm EmployeeID, OrderYear,
--SumOfQuantity. Yêu cầu : người dùng không xem được cú pháp lệnh tạo
--view ?

create view vw_sumQuality
as
select e.EmployeeID,year(OrderDate) as OrderYear, sum(Quantity) as SumOfQuantity
from Employees e join Orders o on o.EmployeeID = e.EmployeeID
	join [Order Details] od on o.OrderID = od.OrderID
group by e.EmployeeID,year(OrderDate)

select * from vw_sumQuality

--4. Tạo view ListCustomer_view chứa danh sách các khách hàng có trên 5
--hóa đơn đặt hàng từ năm 1997 đến 1998, thông tin gồm mã khách hàng
--(CustomerID) , họ tên (CompanyName), Số hóa đơn (CountOfOrders) ?
--Thực hiện truy vấn dữ liệu từ View ?

create view ListCustomer_view
as 
select c.CustomerID , CompanyName, count(OrderDate) as CountOfOrders
from Customers c join Orders o on o.CustomerID = c.CustomerID
group by c.CustomerID , CompanyName

select * from ListCustomer_view

--5. Tạo view ListProduct_view chứa danh sách những sản phẩm thuộc
--nhóm hàng ‘Beverages’ và ‘Seafood’ có tổng số lượng bán trong mỗi
--năm trên 30 sản phẩm, thông tin gồm CategoryName, ProductName,
--Year, SumOfQuantity ?

create view ListProduct_view
as
select c.CategoryName, ProductName,year(OrderDate) as Year, sum(Quantity) as SumOfQuantity
from Categories c join Products p on p.CategoryID = c.CategoryID
	join [Order Details] od on od.ProductID = p.ProductID
	join Orders o on o.OrderID = od.OrderID
group by c.CategoryName, ProductName,year(OrderDate)

select * from ListProduct_view

--6. Tạo view vw_OrderSummary với từ khóa WITH ENCRYPTION gồm
--OrderYear (năm của ngày lập hóa đơn), OrderMonth (tháng của ngày lập
--hóa đơn), OrderTotal (tổng tiền sum(UnitPrice*Quantity)) ?
--Thực hiện truy vấn dữ liệu từ View ?

create view vw_OrderSummary
WITH ENCRYPTION
as 
select year(OrderDate) as OrderYear , month(OrderDate) as OrderMonth,sum(OrderID) as OrderTotal
from Orders 
group by year(OrderDate) , month(OrderDate) 

select * from vw_OrderSummary

--7. Tạo view vwProducts với từ khóa WITH SCHEMABINDING gồm
--ProductID, ProductName, Discount ?

create view vwProducts
WITH SCHEMABINDING
as 
select ProductID, ProductName, Discontinued
from Products

select * from vwProducts

--8.Tạo view vw_Customer với với từ khóa WITH CHECK OPTION chỉ
--chứa các khách hàng ở thành phố London và Madrid, thông tin gồm:
--CustomerID, CompanyName, City.

create view vw_Customer
WITH CHECK OPTION
as 
select CustomerID, CompanyName, City
from Customers

select * from vw_Customer