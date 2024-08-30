----------------------------Tuần 4------------------------------
--câu 1:
use QLBH
alter table nhomsanpham
alter column tennhom nvarchar(50)

insert into nhomSanPham values
(1,N'điện tử'),
(2,N'gia dụng'),
(3,N'Dụng cụ gia đình'),
(4,N'các mặt hàng khác')

insert into NhaCungCap values
(1,N'công ty nam phương',N'1 lê lợi p4 gò vấp',N'3326223',N'3612131',N'namPhuong@yahoo.com'),
(2,N'công ty lan ngọc',N'12 cao bá quát',N'36999923',N'3388831',N'lanNgoc@gmail.com')

insert into SanPham values
(1,N'máy tính',1,N'máy sony ram 2 gb',1,N'cái',7000,100),
(2,N'bàn phím',1,N'máy sony ram 2 gb',1,N'cái',1000,50),
(3,N'chuột',1,N'máy sony ram 2 gb',1,N'cái',800,150),
(4,N'CPU',1,N'máy sony ram 2 gb',1,N'cái',3000,200),
(5,N'USB',1,N'máy sony ram 2 gb',1,N'cái',500,100),
(6,N'lò vi sóng',2,N'máy sony ram 2 gb',3,N'cái',1000000,20)

insert into KhachHang values
('KH1',N'nguyễn thu hằng',N'VL',N'12 nguyễn du',N' ',null,null),
('KH2',N'lê minh',N'TV',N'34 điện biên phủ',N'315333211',N'leMinh@yahoo.com',100),
('KH3',N'nguyễn minh trung',N'VIP',N'3 lê lợi gò vấp',N'02169614',N'Trung@gmail.com',800)

insert into HoaDon values
(1,'2022-11-30','2023-10-5',N'cửa hàng ABC 3 lý chính hằng quận 3','KH1',null),
(2,'2022-10-30','2023-10-5',N'23 lê lợi','KH2',null),
(3,'2022-10-20','2023-10-5',N'2 nguyễn du quận gò vấp','KH3',null)


insert into CT_HoaDon values
(1,1,5,8000,null),
(1,2,4,1200,null),
(1,3,15,1000,null),
(2,2,9,1200,null),
(2,4,5,800,null),
(3,2,20,3500,null),
(3,3,15,1000,null)

select *from CT_HoaDon
select *from HoaDon
select *from KhachHang
select *from NhaCungCap
select *from NhomSanPham
select *from SanPham

update sanpham
set GiaGoc +=GiaGoc*0.05 where MaSP=2 

update SanPham
set SLTon=100 where MaNhom =3 and MaNCC=2

update SanPham
set MoTa=N'lò vi sóng' where TenSP=N'lò vi sóng'

alter table hoadon
drop constraint fk_makh

alter table hoadon with check 
add constraint fk_makh foreign key (makh) references khachhang(makh) 
on update set null

alter table khachhang
alter column makh char(10)

update KhachHang
set MAKH='VIP03' where MAKH='KH3'

update KhachHang
set MAKH='VL01' where MAKH='KH1'
update KhachHang
set makh='T002' where makh='KH2'