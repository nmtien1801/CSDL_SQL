--a. Insert dữ liệu vào bảng KhachHang trong QLBH với dữ liệu nguồn là
--bảng Customers trong NorthWind.

insert into qlbh.[dbo].[KhachHang] ([MaKH],TenKH,[Phone])
select  [CustomerID],[ContactName],[Phone] from [dbo].[Customers]

--b. Insert dữ liệu vào bảng Sanpham trong QLBH. Dữ liệu nguồn là các
--sản phẩm có SupplierID từ 4 đến 29 trong bảng
--Northwind.dbo.Products 

insert into qlbh.[dbo].[SanPham] (masp,tensp,mota)
select [ProductID], [ProductName], [QuantityPerUnit] from [dbo].[Products]
where [SupplierID] >=4 and [SupplierID]<=29

--c. Insert dữ liệu vào bảng HoaDon trong QLBH. Dữ liệu nguồn là các
--hoá đơn có OrderID nằm trong khoảng 10248 đến 10350 trong
--NorthWind.dbo.[Orders]
ALTER TABLE QLBH.[dbo].[HoaDon]
NOCHECK CONSTRAINT CK__HoaDon__LoaiHD__36B12243

insert into QLBH.[dbo].[HoaDon] ([MaHD],[NgayGiao],[Noichuyen])
select [OrderID],[ShippedDate],[ShipAddress] from [dbo].[Orders]
where OrderID >=10248 and OrderID <=10350

--d. Insert dữ liệu vào bảng CT_HoaDon trong QLBH. Dữ liệu nguồn là
--các chi tiết hoá đơn có OderID nằm trong khoảng 10248 đến 10350
--trong NorthWind.dbo.[Order Detail]

ALTER TABLE QLBH.[dbo].[CT_HoaDon]
NOCHECK CONSTRAINT FK__CT_HoaDon__MaSP__300424B4

INSERT INTO QLBH.[dbo].[CT_HoaDon] ([MaHD], [MaSP], [Dongia], [Soluong])
SELECT [OrderID], [ProductID], [UnitPrice], [Quantity] FROM [dbo].[Order Details]
WHERE OrderID BETWEEN 10248 AND 10350

----------------------------------------------bài 2------------------------------------------
--1. Cập nhật chiết khấu 0.1 cho các mặt hàng trong các hóa đơn xuất bán
--vào ngày ‘1/1/1997’

update QLBH.[dbo].[CT_HoaDon]
set [ChietKhau] = 0.1
from [dbo].[Order Details] od join [dbo].[Orders] o on od.OrderID = o.OrderID
where [OrderDate] = '1997-1-1'

--2. Cập nhật đơn giá bán 17.5 cho mặt hàng có mã 11 trong các hóa đơn
--xuất bán vào tháng 2 năm 1997

update QLBH.[dbo].[CT_HoaDon]
set [Dongia]= 17.5 
FROM [dbo].[Order Details] OD JOIN [dbo].[Orders] O ON O.OrderID = OD.OrderID
WHERE YEAR([OrderDate]) = 1997 AND MONTH([OrderDate]) = 2

--3. Cập nhật giá bán các sản phẩm trong bảng [Order Details] bằng với đơn
--giá mua trong bảng [Products] của các sản phẩm được cung cấp từ nhà
--cung cấp có mã là 4 hay 7 và xuất bán trong tháng 4 năm 1997

UPDATE [Order Details] 
SET [UnitPrice] = P.[UnitPrice]
FROM [Products] P JOIN [Order Details] OD ON OD.ProductID = P.ProductID
	JOIN [dbo].[Orders] O ON O.OrderID = OD.OrderID
WHERE [SupplierID] = 4 OR [SupplierID]= 7 AND MONTH([OrderDate])=4 AND YEAR([OrderDate])=1997

--4. Cập nhật tăng phí vận chuyển (Freight) lên 20% cho những hóa đơn có
--tổng trị giá hóa đơn >= 10000 và xuất bán trong tháng 1/1997

UPDATE [dbo].[Orders]
SET [Freight] *=0.2
FROM [dbo].[Orders] O JOIN [dbo].[Order Details] OD ON OD.OrderID = O.OrderID
WHERE O.OrderID IN ( SELECT OD.OrderID
		FROM [dbo].[Orders] O JOIN [dbo].[Order Details] OD ON OD.OrderID = O.OrderID
		GROUP BY OD.OrderID
		HAVING SUM([UnitPrice]) >=10000 ) AND 
	MONTH([OrderDate])= 1 AND YEAR([OrderDate])=1997

--5. Thêm 1 cột vào bảng Customers lưu thông tin về loại thành viên :
--Member97 varchar(3) . Cập nhật cột Member97 là ‘VIP’ cho những
--khách hàng có tổng trị giá các đơn hàng trong năm 1997 từ 50000 trở
--lên

ALTER TABLE Customers
ADD Member97 varchar(3)

UPDATE Customers
SET [Member97] = 'VIP'
FROM Customers C JOIN [dbo].[Orders] O ON O.CustomerID = C.CustomerID
WHERE C.CustomerID IN (SELECT C.CustomerID
		FROM [dbo].[Orders] O JOIN [dbo].[Order Details] OD ON OD.OrderID = O.OrderID
			JOIN Customers C ON O.CustomerID = C.CustomerID
		GROUP BY OD.OrderID,C.CustomerID
		HAVING SUM([UnitPrice]) >=50.000)
	AND YEAR([OrderDate])=1997

