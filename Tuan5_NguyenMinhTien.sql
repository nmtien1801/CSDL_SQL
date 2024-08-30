----------------------------------------------Tuan 5--------------------------------------
--1. Liệt kê danh sách các mặt hàng (Products)

select * from [dbo].[Products]

--2. Liệt kê danh sách các mặt hàng (Products). Thông tin bao gồm
--ProductID, ProductName, UnitPrice.

select ProductID, ProductName, UnitPrice 
from [dbo].[Products]

--3. Liệt kê danh sách các nhân viên (Employees). Thông tin bao gồm
--EmployeeID, EmployeeName, Phone, Age. Trong đó EmployeeName
--được ghép từ LastName và FirstName; Age là tuổi được tính dựa trên
--năm hiện hành (GetDate()) và năm sinh.

select e.EmployeeID, LastName +' '+ FirstName as EmployeeName, Phone,getdate() -year(birthdate) as Age
from ([dbo].[Employees] e join [dbo].[Orders] o on e.EmployeeID=o.EmployeeID)
	join [dbo].[Shippers] s on s.ShipperID=o.EmployeeID

--4. Liệt kê danh sách các khách hàng (Customers) mà người đại diện có
--ContactTitle bắt đầu bằng chữ ‘O’. Thông tin bao gồm CustomerID,
--CompanyName, ContactName, ContactTitle, City, Phone

select CustomerID,CompanyName, ContactName, ContactTitle, City, Phone
from [dbo].[Customers] 
where ContactTitle = 'o%'

--5. Liệt kê danh sách khách hàng (Customers) ở thành phố LonDon, Boise và Paris

select *
from [dbo].[Customers]
where city = 'london' or city = 'Boise' or city='Paris'

--6. Liệt kê danh sách khách hàng (Customers) có tên bắt đầu bằng chữ V mà
--ở thành phố Lyon.

select *
from Customers 
where ContactName like 'V%' and City ='london'

--7. Liệt kê danh sách các khách hàng (Customers) không có số fax.

select *
from Customers 
where fax is null

--8. Liệt kê danh sách các khách hàng (Customers) có số Fax.

select *
from Customers
where fax is not null

--9. Liệt kê danh sách nhân viên (Employees) có năm sinh <=1960

select *
from Employees 
where year(BirthDate)<=1960

--10. Liệt kê danh sách các sản phẩm (Products) có chứa chữ ‘Boxes’ trong
--cột QuantityPerUnit.

select * 
from Products 
where QuantityPerUnit like '%boxes'

--11. Liệt kê danh sách các mặt hàng (Products) có đơn giá (Unitprice) lớn
--hơn 10 và nhỏ hơn 15.

select * 
from Products  
where UnitPrice >10 and UnitPrice<15

--12. Liệt kê danh sách các mặt hàng (Products) có số lượng tồn nhỏ hơn 5.

select *
from Products 
where UnitsInStock <5

--13. Liệt kê danh sách các mặt hàng (Products) ứng với tiền tồn vốn. Thông
--tin bao gồm ProductId, ProductName, Unitprice, UnitsInStock, Total.
--Trong đó Total= UnitsInStock*Unitprice. Được sắp xếp theo Total giảm dần.

select ProductId, ProductName, Unitprice, UnitsInStock, UnitsInStock*Unitprice as Total
from Products 
order by UnitsInStock*Unitprice desc


--14. Hiển thị thông tin OrderID, OrderDate, CustomerID, EmployeeID của 2
--hóa đơn có mã OrderID là ‘10248’ và ‘10250’

select OrderID, OrderDate, CustomerID, EmployeeID
from [dbo].[Orders]
where OrderID =10248 or OrderID = 10250

--15. Liệt kê chi tiết của hóa đơn có OrderID là ‘10248’. Thông tin gồm
--OrderID, ProductID, Quantity, Unitprice, Discount, ToTalLine =
--Quantity * unitPrice *(1-Discount)

select od.OrderID, p.ProductID, Quantity, od.Unitprice, Discount, 
		ToTalLine =Quantity * od.unitPrice *(1-Discount)
from Products p join [Order Details] od on od.ProductID=p.ProductID
where od.OrderID = 10248


--16. Liệt kê danh sách các hóa đơn (orders) có OrderDate được lập trong
--tháng 9 năm 1996. Được sắp xếp theo mã khách hàng, cùng mã khách
--hàng sắp xếp theo ngày lập hóa đơn giảm dần.

select *
from Orders o join Customers c on o.CustomerID = c.CustomerID
where month(OrderDate)= 9 and year(OrderDate)= 1996
order by c.CustomerID, OrderDate desc

--17. Liệt kê danh sách các hóa đơn (Orders) được lập trong quý 4 năm 1997.
--Thông tin gồm OrderID, OrderDate, CustomerID, EmployeeID. Được
--sắp xếp theo tháng của ngày lập hóa đơn.

select OrderID, OrderDate, CustomerID, EmployeeID
from Orders 
where datepart(QUARTER,OrderDate)=4 and year(OrderDate) =1997
order by month(OrderDate) 

--18. Liệt kê danh sách các hóa đơn (Orders) được lập trong trong ngày thứ 7
--và chủ nhật của tháng 12 năm 1997. Thông tin gồm OrderID, OrderDate,
--Customerid, EmployeeID, WeekDayOfOrdate (Ngày thứ mấy trong tuần).

select OrderID, OrderDate, Customerid, EmployeeID, DATEPART(WEEKDAY,OrderDate) as WeekDayOfOrdate
from Orders 
where DATEPART(WEEKDAY,OrderDate) = 7 or DATEPART(WEEKDAY,OrderDate) = 1
	and month(orderdate)=12 and year(orderdate)=1997


--19. Liệt kê danh sách 5 customers có city có ký tự bắt đầu ‘M’.

select top 5 *
from Customers 
where City like 'M%'

--20. Liệt kê danh sách 2 employees có tuổi lớn nhất. Thông tin bao gồm
--EmployeeID, EmployeeName, Age. Trong đó, EmployeeName được
--ghép từ LastName và FirstName; Age là tuổi

select EmployeeID, FirstName+' '+LastName as EmployeeName,year(GETDATE()) - DATEPART(year,BirthDate) as Age
from Employees