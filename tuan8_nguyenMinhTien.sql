------------------------------------------Tuan 8--------------------------------------------
--1. Liệt kê các product có đơn giá bán lớn hơn đơn giá bán trung bình của
--các product. Thông tin gồm ProductID, ProductName, Unitprice .

select p.ProductID, ProductName, od.Unitprice
from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID=p.ProductID
where od.Unitprice >all (select avg(Unitprice)
					from [dbo].[Order Details])

--2. Liệt kê các product có đơn giá bán lớn hơn đơn giá bán trung bình của
--các product có ProductName bắt đầu là ‘N’

select *
from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID=p.ProductID
where od.Unitprice >all (select avg(od.Unitprice)
					from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID=p.ProductID
					where p.ProductName='N%')


--3. Danh sách các products có đơn giá mua lớn hơn đơn giá mua nhỏ nhất
--của tất cả các products

select *
from [dbo].[Products]
where Unitprice >all (select min(Unitprice)
					from [dbo].[Products])

----4. Cho biết những product có đơn vị tính có chữ ‘box’ và có số lượng bán
--lớn hơn số lượng trung bình bán ra.

select *
from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID = p.ProductID
where CHARINDEX(N'box',QuantityPerUnit,1) not in(0) and Quantity > (select avg(Quantity)
														from [dbo].[Order Details])
---------------------------------------------------
select *
from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID = p.ProductID
where QuantityPerUnit like N'%box%' and Quantity > (select avg(Quantity)
														from [dbo].[Order Details])

--5.  Cho biết  những sản phẩm có tên  bắt đầu bằng  ‘T’  và  có  đơn giá bán  lớn 
--hơn  đơn giá bán của  (tất cả) những  sản phẩm có tên bắt đầu bằng chữ 
--‘V’.

select *
from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID = p.ProductID
where ProductName like 'T%' and od.UnitPrice >all (select max(od.UnitPrice)
					from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID = p.ProductID
					where ProductName like 'V%')
--6.  Cho biết những  sản phẩm thuộc nhóm hàng có mã 4 (categoryID)  và có 
--tổng số lượng bán lớn hơn  (tất cả)  tổng số lượng của những sản phẩm 
--không thuộc nhóm hàng mã 4
--Lưu  ý  :  Có  nhiều  phương  án  thực  hiện  các  truy  vấn  sau.  Hãy  đưa  ra 
--phương án sử dụng subquery.

select p.ProductID, ProductName
from [dbo].[Products] p join [dbo].[Categories] c on c.CategoryID= p.CategoryID
	join [dbo].[Order Details] od on od.ProductID = p.ProductID
	join [dbo].[Orders] o on o.OrderID=od.OrderID
where c.CategoryID = 4 
group by p.ProductID, ProductName
having count(OrderDate) >all (select count(orderDate)
					from [dbo].[Products] p join [dbo].[Categories] c 
							on c.CategoryID= p.CategoryID
							join [dbo].[Order Details] od on od.ProductID = p.ProductID
							join [dbo].[Orders] o on o.OrderID=od.OrderID
					where c.CategoryID not in(4)
					group by p.ProductID)

 
--7.  Danh sách các products đã có khách hàng mua hàng (tức là ProductID có 
--trong  [Order  Details]).  Thông  tin  bao  gồm  ProductID,  ProductName, 
--Unitprice

select p.ProductID,  ProductName,od.Unitprice
from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID=p.ProductID
where p.ProductID in (select p.ProductID 
					from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID=p.ProductID
					group by p.ProductID)

--8.  Danh sách các hóa đơn của những  khách hàng  ở thành phố LonDon và 
--Madrid.

select *
from [dbo].[Orders] o join [dbo].[Customers] c on c.CustomerID=o.CustomerID
where City like 'london' or city ='Madrid'

--9.  Liệt kê các sản phẩm có trên 20 đơn hàng trong  quí 3  năm 1998, thông 
--tin gồm ProductID, ProductName.

select p.ProductID, ProductName 
from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID = p.ProductID
	join [dbo].[Orders] o on o.OrderID=od.OrderID
where year(o.OrderDate)=1998 and month(o.OrderDate)<=9 and month(o.OrderDate)>=7
	and p.ProductID in (select p.ProductID
					from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID = p.ProductID
					join [dbo].[Orders] o on o.OrderID=od.OrderID
					group by p.ProductID
					having count(orderdate) >20)


--10.  Liệt kê danh sách các sản phẩm chưa bán được trong tháng 6 năm 1996

select ProductID, ProductName
from [dbo].[Products]
where ProductID not in(
	select p.ProductID
	from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID=p.ProductID
	join [dbo].[Orders] o on o.OrderID=od.OrderID
	where month(OrderDate) = 6 and year(OrderDate)=1996 )

--11.  Liệt kê danh sách các Employes không lập hóa đơn vào ngày hôm nay

select EmployeeID, FirstName +' '+LastName as name
from [dbo].[Employees]
where EmployeeID not in(
	select e.EmployeeID
	from [dbo].[Employees] e join [dbo].[Orders] o on o.EmployeeID=e.EmployeeID
	where OrderDate = GETDATE())

--12.  Liệt kê danh sách các Customers chưa mua hàng trong năm 1997

select *
from [dbo].[Customers]
where CustomerID not in(
	select c.CustomerID
	from [dbo].[Customers] c join [dbo].[Orders] o on o.CustomerID=c.CustomerID
	where year(OrderDate)=1997)

--13.  Tìm tất cả các Customers mua các sản phẩm có tên bắt đầu bằng chữ T 
--trong tháng 7 năm 1997

select * 
from [dbo].[Customers]
where CustomerID in (
	select c.CustomerID
	from [dbo].[Customers] c join [dbo].[Orders] o on c.CustomerID=o.CustomerID
		join [Order Details] od on od.OrderID=o.OrderID
		join Products p on p.ProductID=od.ProductID
	where ProductName like 'T%' and month(OrderDate)=7 and year(OrderDate)=1997)

--14.  Liệt kê danh sách các khách  hàng mua các hóa đơn mà các hóa đơn này 
--chỉ mua những sản phẩm có mã >=3 

select * 
from [dbo].[Customers] c join [dbo].[Orders] o on c.CustomerID=o.CustomerID
		join [Order Details] od on od.OrderID=o.OrderID
		join Products p on p.ProductID=od.ProductID
where p.ProductID in (
	select p.ProductID
	from [dbo].[Products] p
	where p.ProductID >2 )

--15.  Tìm các Customer chưa từng lập  hóa đơn (viết bằng ba cách: dùng NOT 
--EXISTS, dùng LEFT JOIN, dùng NOT IN )

select *
from [dbo].[Customers] 
where CustomerID not in (
	select c.CustomerID
	from Customers c join Orders o on o.CustomerID=c.CustomerID)

--16.  Cho biết sản phẩm nào có đơn giá bán cao nhất trong số những sản phẩm
--có đơn vị tính có chứa chữ ‘box’ .

select p.ProductID, ProductName
from Products p
where ProductID in(
	select top 1 p.ProductID
	from [dbo].[Products] p join [dbo].[Order Details] od on od.ProductID=p.ProductID
	group by p.ProductID
	order by max(od.UnitPrice) desc)


--17.  Danh sách các Products có tổng số lượng (Quantity) bán được lớn nhất.

select p.ProductID, ProductName 
from Products p 
where p.ProductID in (
	select top 1 p.ProductID
	from Products p join [Order Details] od on od.ProductID=p.ProductID
	group by p.ProductID
	order by sum(Quantity) desc)


--cau 8

Select ProductID, ProductName, UnitPrice 
From [Products]
Where Unitprice>ALL (
	Select Unitprice from [Products] where
	ProductName like 'N%')

Select ProductId, ProductName, UnitPrice 
From [Products]
Where Unitprice>ANY (
	Select Unitprice 
	from [Products] 
	where ProductName like 'N%')

Select ProductId, ProductName, UnitPrice 
from [Products]
Where Unitprice=ANY (
	Select Unitprice 
	from [Products] 
	where ProductName like 'N%')

Select ProductId, ProductName, UnitPrice 
from [Products]
Where ProductName like 'N%' and
Unitprice>=ALL (
	Select Unitprice 
	from [Products] 
	where ProductName like 'N%')



