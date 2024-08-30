----------------------------------------------Tuan 6--------------------------------------
--1. Hiển thị thông tin về hóa đơn có mã ‘10248’, bao gồm: OrderID,
--OrderDate, CustomerID, EmployeeID, ProductID, Quantity, Unitprice,
--Discount.

select OrderDate, CustomerID, EmployeeID, ProductID, Quantity, Unitprice,Discount
from [dbo].[Orders] o join [dbo].[Order Details] od on o.OrderID = od.OrderID
where o.OrderID = 10248

--2. Liệt kê các khách hàng có lập hóa đơn trong tháng 7/1997 và 9/1997.
--Thông tin gồm CustomerID, CompanyName, Address, OrderID,
--Orderdate. Được sắp xếp theo CustomerID, cùng CustomerID thì sắp xếp
--theo OrderDate giảm dần. 

select c.CustomerID, CompanyName, Address, OrderID,Orderdate
from [dbo].[Customers] c join [dbo].[Orders] o on c.CustomerID = o.CustomerID
where (month(orderdate) = 7 and year(orderdate)=1997) or (month(orderdate)=9 and year(orderdate)=1997)
order by CustomerID desc

--3. Liệt kê danh sách các mặt hàng xuất bán vào ngày 19/7/1996. Thông tin
--gồm : ProductID, ProductName, OrderID, OrderDate, Quantity.

select p.ProductID, ProductName, od.OrderID, OrderDate, Quantity
from ([dbo].[Orders] o join [dbo].[Order Details] od On o.OrderID = od.OrderID)join [dbo].[Products] p on (od.ProductID = p.ProductID)
where day(OrderDate)=19 and month(OrderDate)=7 and year(OrderDate)=1997

--4. Liệt kê danh sách các mặt hàng từ nhà cung cấp (supplier) có mã 1,3,6 và
--đã xuất bán trong quý 2 năm 1997. Thông tin gồm : ProductID,
--ProductName, SupplierID, OrderID, Quantity. Được sắp xếp theo mã 
--nhà cung cấp (SupplierID), cùng mã nhà cung cấp thì sắp xếp theo
--ProductID

select p.ProductID,ProductName, s.SupplierID, o.OrderID, Quantity
from (([dbo].[Orders] o join [dbo].[Order Details] od on o.OrderID = od.OrderID)
	join [dbo].[Products] p on od.ProductID  =p.ProductID)
	join [dbo].[Suppliers] s on s.SupplierID=p.SupplierID
where (s.SupplierID =1 or s.SupplierID=3 or s.SupplierID=6) and  year(o.OrderDate)=1997
order by SupplierID

--5. Liệt kê danh sách các mặt hàng có đơn giá bán bằng đơn giá mua.
select ProductName, od.UnitPrice
from [dbo].[Products]p join [dbo].[Order Details] od on p.ProductID = od.ProductID
where od.UnitPrice = p.UnitPrice

--6. Danh sách các mặt hàng bán trong ngày thứ 7 và chủ nhật của tháng 12
--năm 1996, thông tin gồm ProductID, ProductName, OrderID, OrderDate,
--CustomerID, Unitprice, Quantity, ToTal= Quantity*UnitPrice. Được sắp
--xếp theo ProductID, cùng ProductID thì sắp xếp theo Quantity giảm dần.

select p.ProductID, ProductName, o.OrderID, OrderDate,
	CustomerID, od.UnitPrice, Quantity, Quantity*od.UnitPrice as ToTal
from ([dbo].[Orders] o join [dbo].[Order Details] od on o.OrderID=od.OrderID)
	join [dbo].[Products] p on od.ProductID=p.ProductID 
where (datepart(WEEKDAY,o.OrderDate)=7 or datepart(dw,o.OrderDate)=1)
	and month(o.OrderDate)=12 and year(o.OrderDate) = 1996

--7. Liệt kê danh sách các nhân viên đã lập hóa đơn trong tháng 7 của năm
--1996. Thông tin gồm : EmployeeID, EmployeeName, OrderID,
--Orderdate.

select e.EmployeeID, FirstName+' '+LastName as EmployeeName, o.OrderID,Orderdate 
from [dbo].[Orders] o join [dbo].[Employees] e on o.EmployeeID=e.EmployeeID
where month(OrderDate) =7 and year(OrderDate)=1996 

--8. Liệt kê danh sách các hóa đơn do nhân viên có Lastname là ‘Fuller’ lập.
--Thông tin gồm : OrderID, Orderdate, ProductID, Quantity, Unitprice.

select  o.OrderID, Orderdate, p.ProductID, Quantity, p.Unitprice
from ((([dbo].[Employees] e join [dbo].[Orders] o on e.EmployeeID=o.EmployeeID)
	join [dbo].[Order Details] od on o.OrderID = od.OrderID)
	join [dbo].[Products] p on p.ProductID=od.ProductID)
where Lastname = 'fuller'

--9. Liệt kê chi tiết bán hàng của mỗi nhân viên theo từng hóa đơn trong năm
--1996. Thông tin gồm: EmployeeID, EmployName, OrderID, Orderdate,
--ProductID, quantity, unitprice, ToTalLine=quantity*unitprice

select e.EmployeeID, FirstName+' '+LastName as EmployName, o.OrderID, Orderdate,
	p.ProductID, quantity, p.unitprice,quantity*p.unitprice as ToTalLine
from (([dbo].[Products] p join [dbo].[Order Details] od on p.ProductID=od.ProductID)
	join [dbo].[Orders] o on o.OrderID = od.OrderID)
	join [dbo].[Employees] e on e.EmployeeID=o.EmployeeID
where year(Orderdate)=1996

--10.Danh sách các đơn hàng sẽ được giao trong các thứ 7 của tháng 12 năm
--1996. 

select * 
from [dbo].[Orders] 
where month(ShippedDate)=12 and year(ShippedDate)=1996 and datepart(dw,ShippedDate)=7


