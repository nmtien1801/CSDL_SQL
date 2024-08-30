﻿----------------------------------------------------Tuan 7------------------------------------------------------

--1. Liệt kê danh sách các orders ứng với tổng tiền của từng hóa đơn. Thông
--tin bao gồm OrderID, OrderDate, Total. Trong đó Total là Sum của
--Quantity * Unitprice, kết nhóm theo OrderID.

select o.OrderID, OrderDate,  sum(Quantity*unitprice) as Total
from [dbo].[Orders] o join [dbo].[Order Details] od on o.OrderID=od.OrderID
group by o.OrderID,OrderDate


--2. Liệt kê danh sách các orders mà địa chỉ nhận hàng ở thành phố ‘Madrid’
--(Shipcity). Thông tin bao gồm OrderID, OrderDate, Total. Trong đó
--Total là tổng trị giá hóa đơn, kết nhóm theo OrderID.

select o.OrderID,  OrderDate,  sum(Quantity*unitprice) as Total
from [dbo].[Orders] o join [dbo].[Order Details] od on o.OrderID=od.OrderID
where o.shipCity ='madrit'
group by o.OrderID,OrderDate


--3. Viết các truy vấn để thống kê số lượng các hóa đơn xuất bán :
--	 Trong mỗi năm. Thông tin hiển thị : Year , CoutOfOrders ?
--	 Trong mỗi tháng/năm . Thông tin hiển thị : Year , Month,CoutOfOrders ?
--	 Trong mỗi tháng/năm và ứng với mỗi nhân viên. Thông tin hiển thị : Year, Month, EmployeeID, CoutOfOrders ?

select year(OrderDate) , count(*) as CoutOfOrders
from [dbo].[Orders]
group by year(OrderDate)
-------------------------------------------------

select year(OrderDate) as year ,month(OrderDate) as month,  count(*) as CoutOfOrders
from [dbo].[Orders]
group by year(OrderDate),month(OrderDate)
---------------------------------------------------

select year(OrderDate) as year ,month(OrderDate) as month, EmployeeID,  count(OrderID) as CoutOfOrders
from [dbo].[Orders] 
group by year(OrderDate),month(OrderDate),EmployeeID

--4. Cho biết mỗi Employee đã lập bao nhiêu hóa đơn. Thông tin gồm
--EmployeeID, EmployeeName, CountOfOrder. Trong đó CountOfOrder
--là tổng số hóa đơn của từng employee. EmployeeName được ghép từ
--LastName và FirstName

select e.EmployeeID,  firstname + ' '+ lastname as EmployeeName,  count(OrderID) as CountOfOrder
from [dbo].[Employees] e join [dbo].[Orders] o on o.EmployeeID=e.EmployeeID
group by  e.EmployeeID, firstname + ' '+ lastname

--5. Cho biết mỗi Employee đã lập được bao nhiêu hóa đơn, ứng với tổng
--tiền các hóa đơn tương ứng. Thông tin gồm EmployeeID,
--EmployeeName, CountOfOrder , Total

select e.EmployeeID,  firstname + ' '+ lastname as EmployeeName,  count(distinct o.OrderID) as CountOfOrder,sum(Quantity*UnitPrice) as total
from ([dbo].[Employees] e join [dbo].[Orders] o on o.EmployeeID=e.EmployeeID)
	join [dbo].[Order Details] od on o.OrderID=od.OrderID
group by  e.EmployeeID, firstname + ' '+ lastname

--6. Liệt kê bảng lương của mỗi Employee theo từng tháng trong năm 1996
--gồm EmployeeID, EmployName, Month_Salary, Salary =
--sum(quantity*unitprice)*10%. Được sắp xếp theo Month_Salary, cùmg
--Month_Salary thì sắp xếp theo Salary giảm dần

select e.EmployeeID,  firstname + ' '+ lastname as EmployeeName,month(OrderDate) as Month_Salary,  Salary=sum(quantity*unitprice)*0.1
from [dbo].[Employees] e join [dbo].[Orders] o on e.EmployeeID=o.EmployeeID
	join [dbo].[Order Details] od on o.OrderID = od.OrderID
where year(OrderDate)=1996
group by  e.EmployeeID,  firstname + ' '+ lastname,month(OrderDate)
order by month(OrderDate) desc


--7. Tính tổng số hóa đơn và tổng tiền các hóa đơn của mỗi nhân viên đã bán
--trong tháng 3/1997, có tổng tiền >4000. Thông tin gồm EmployeeID,
--LastName, FirstName, CountofOrder, Total

select e.EmployeeID, LastName, FirstName, count(distinct o.orderid) as CountofOrder, Total=sum(quantity*unitprice)
from [dbo].[Employees] e join [dbo].[Orders] o on e.EmployeeID=o.EmployeeID
	join [dbo].[Order Details] od on o.OrderID = od.OrderID
where month(OrderDate)=3 and year(OrderDate)=1997
group by e.EmployeeID, LastName, FirstName
having sum(quantity*unitprice)>4000

--8. Liệt kê danh sách các customer ứng với tổng số hoá đơn, tổng tiền các
--hoá đơn, mà các hóa đơn được lập từ 31/12/1996 đến 1/1/1998 và tổng
--tiền các hóa đơn >20000. Thông tin được sắp xếp theo CustomerID,
--cùng mã thì sắp xếp theo tổng tiền giảm dần

select c.CustomerID, count(distinct o.orderid) as CountofOrder, sum(Quantity * UnitPrice) as total
from [dbo].[Customers] c join [dbo].[Orders] o on c.CustomerID=o.CustomerID
	join [dbo].[Order Details] od on o.OrderID = od.OrderID
where OrderDate>='1996-12-31' and OrderDate<='1998-1-1'
group by c.CustomerID
having sum(quantity*unitprice)>20000
order by CustomerID , sum(Quantity * UnitPrice) desc  

--9. Liệt kê danh sách các customer ứng với tổng tiền của các hóa đơn ở từng
--tháng. Thông tin bao gồm CustomerID, CompanyName, Month_Year,
--Total. Trong đó Month_year là tháng và năm lập hóa đơn, Total là tổng
--của Unitprice* Quantity.


select c.CustomerID, CompanyName, month(OrderDate) as Month_Year, sum(Unitprice* Quantity) as Total
from [dbo].[Orders] o join [dbo].[Customers] c on o.CustomerID = c.CustomerID
	join [dbo].[Order Details] od on od.OrderID = o.OrderID
group by c.CustomerID, CompanyName, month(OrderDate) 


--10. Liệt kê danh sách các nhóm hàng (category) có tổng số lượng tồn
--(UnitsInStock) lớn hơn 300, đơn giá trung bình nhỏ hơn 25. Thông tin
--bao gồm CategoryID, CategoryName, Total_UnitsInStock,
--Average_Unitprice.

select c.CategoryID, CategoryName, sum(UnitsInStock) as Total_UnitsInStock, AVG(UnitPrice) as Average_Unitprice
from [dbo].[Categories] c join [dbo].[Products] p on c.CategoryID=p.CategoryID
group by c.CategoryID, CategoryName
having sum(UnitsInStock) >300 and AVG(UnitPrice) <25

--11. Liệt kê danh sách các nhóm hàng (category) có tổng số mặt hàng
--(product) nhỏ hớn 10. Thông tin kết quả bao gồm CategoryID,
--CategoryName, CountOfProducts. Được sắp xếp theo CategoryName,
--cùng CategoryName thì sắp theo CountOfProducts giảm dần.

select c.CategoryID,CategoryName, count(p.ProductID) as CountOfProducts
from [dbo].[Categories] c join [dbo].[Products] p on p.CategoryID=c.CategoryID
group by c.CategoryID,CategoryName
having count(p.ProductID) <10
order by CategoryName, count(p.ProductID) desc

--12. Liệt kê danh sách các Product bán trong quý 1 năm 1998 có tổng số
--lượng bán ra >200, thông tin gồm [ProductID], [ProductName],
--SumofQuatity

select p.ProductID, ProductName, sum(od.Quantity) as SumofQuatity
from [dbo].[Products] p join [dbo].[Order Details] od on p.ProductID= p.ProductID
	join [dbo].[Orders] o on o.OrderID=od.OrderID
where MONTH(OrderDate)>=1 and MONTH(OrderDate) <=4 and year(OrderDate) = 1998
group by p.ProductID, ProductName

--13. Cho biết Employee nào bán được nhiều tiền nhất trong tháng 7 năm 1997

select top 1 e.EmployeeID, FirstName + ' '+ LastName as nameEmployee, sum(Unitprice* Quantity) as Total
from [dbo].[Employees] e join [dbo].[Orders] o on o.EmployeeID = e.EmployeeID
	join [dbo].[Order Details] od on od.OrderID = o.OrderID
where month(OrderDate) =7 and year(OrderDate)=1997
group by e.EmployeeID, FirstName + ' '+ LastName
order by sum(Unitprice* Quantity) desc 

--14. Liệt kê danh sách 3 Customer có nhiều đơn hàng nhất của năm 1996.

select top 3 c.CustomerID, ContactName, count(OrderID) as Total
from [dbo].[Customers] c join [dbo].[Orders] o on o.CustomerID = c.CustomerID
where year(OrderDate)=1996
group by c.CustomerID, ContactName
order by count(OrderID) desc 

--15. Liệt kê danh sách các Products có tổng số lượng lập hóa đơn lớn nhất.
--Thông tin gồm ProductID, ProductName, CountOfOrders.

select top 1 p.ProductID, ProductName,count(distinct o.OrderID) as CountOfOrders
from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID = p.ProductID
	join [dbo].[Orders] o on o.OrderID = od.OrderID
group by p.ProductID, ProductName
order by count(distinct o.OrderID) desc
