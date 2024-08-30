-- bài 3:

 use QLBH

 CREATE TABLE NhomSanPham
 (maNhom int not null primary key,
 TenNhom Nvarchar(15))

 CREATE TABLE NhaCungCap
(MaNCC int not null primary key,
TenNCC nvarchar(40) not null,
DiaChi nvarchar(60),
Phone nvarchar(24),
SoFax nvarchar(24),
DCMail nvarchar(50))

 CREATE TABLE SanPham
 (MaSP int not null,
 TenSP nvarchar(40) not null,
 MaNCC int  REFERENCES NhaCungCap(MANCC),
 MoTa nvarchar(50),
 MaNhom int references NhomSanPham(maNhom),
 DonViTinh nvarchar(20),
 GiaGoc money check (GiaGoc > 0),
 SLTon int check (SLTon >=0))

 alter table SanPham
 ADD CONSTRAINT MaSP_PK primary key (MaSP)

 CREATE TABLE KhachHang
(MAKH char(5) not null primary key,
TenKH nvarchar(40) not null,
LoaiKH nvarchar(3) check(LoaiKH in('VIP','TV','vl')),
DiaChi nvarchar(60),
Phone nvarchar(24),
DCMail nvarchar(50),
DiemLT int check(DiemLT >= 0))

 CREATE TABLE HoaDon
 (MaHD int not null primary key,
 NgayLapHD Datetime check(NgayLapHD >= getdate()),
 NgayGiao Datetime ,
 NoiChuyen nvarchar(60) not null,
 MaKH char(5) references KhachHang(MAKH))

 alter table HoaDon
 add constraint DF_ngaylapHD default getdate() for ngayLapHD

 CREATE TABLE CT_HoaDon
 (MaHD int not null references hoadon(MAHD),
 MaSP int not null references SanPham(MaSP),
Soluong smallint check(soLuong > 0),
DonGia money,
ChietKhau money check(chietKhau >= 0),
primary key(MaHD, MaSP))

--bài 4:

alter table hoaDon
add loaiHD char(1) check(loaiHD in ('N','X','C','T'))

alter table hoadon
add constraint c_ngaygiao check(ngayGiao >= ngayLapHD)

-------------------tuần 3 bài 2:-------------------------

-- cau 1:

create database Movies
on primary
(name = Movies_data, filename = 'D:\Movies\Movies_data.mdf',
size = 25mb, maxsize = 40mb, filegrowth = 1mb)
log on
(name = Movies_log, filename = 'D:\Movies\Movies_log.ldf', 
size = 6mb, maxsize = 8mb , filegrowth = 1mb)

-- cau 2: 

use Movies
alter database movies
add file(name = movies_data2, filename = 'D:\Movies\Movies_data2.ndf', size = 10mb)


alter database movies
set  single_user

alter database movies
set  restricted_user

alter database movies
set  multi_user

alter database Movies 
modify file(name = movies_data2,  size = 15mb)

alter database movies
set  auto_shrink on 

-- drop database movies

-- cau 3:
alter database Movies
add filegroup DataGroup

alter database movies 
modify file(name = Movies_log, maxsize = 10mb)

alter database movies 
modify file(name = movies_data2, size = 20mb)

alter database movies 
add file (name = Movies_data3, filename = 'D:\Movies\Movies_data3.ndf',
size = 25mb, maxsize = 40mb, filegrowth = 1mb) to filegroup DataGroup


sp_helpdb movies

-- cau 5:
sp_addtype Movie_num, 'int' , 'not null'
sp_addtype Category_num, 'int', 'not null'
sp_addtype Cust_num, 'int', 'not null' 
sp_addtype Invoice_num , 'int', 'not null' 

-- cau 4,6:

create table customer
(Cust_num cust_num IDENTITY(300,1) not null,
 Lname Nvarchar(20) not null, 
 Fname varchar(20) not null,
 Address1 varchar(30),
 Address2 varchar(20),
 City varchar(20),
 State char(2),
 Zip char(10),
 phone varchar(10) not null,
 Join_date smalldatetime not null
)

create table Category
(Category_num Category_num identity(1,1) not null,
 Description varchar(20)
)

create table Movie
(Movie_num Movie_num not null,
 Title Cust_num not null,
 Category_Num Category_Num not null,
 Date_purch Smalldatetime,
 Rental_price int,
 Rating char(5)
)


create table Rental
(Invoice_num Invoice_num not null,
 Cust_num Cust_num not null,
 Rental_date Smalldatetime not null,
 Due_date Smalldatetime not null,
)

create table Rental_Detail
(Invoice_num Invoice_num not null,
 Line_num int not null,
 Movie_num Movie_num not null,
 Rental_price Smallmoney not null
)

-- câu 9:
alter table Movie 
add constraint PK_movies primary key (Movie_num)

alter table Customer
add constraint PK_customer primary key (Cust_num)

alter table Rental
add constraint PK_rental primary key (Invoice_num)

alter table Category
add constraint PK_category primary key (Category_num)

sp_helpconstraint movie

-- câu 10:
alter table movie
add constraint FK_movie foreign key (Category_num) references Category(Category_num)

alter table Rental
add constraint FK_rental foreign key (Cust_num) references Customer(Cust_num)

alter table Rental_detail
add constraint FK_detail_invoice foreign key (Invoice_num) references Rental(Invoice_num)

alter table Rental_detail
add constraint PK_detail_movie foreign key (Movie_num) references Movie(Movie_num)

sp_helpconstraint movie 

-- câu 12:
alter table Movie
add constraint DK_movie_date_purch default getdate() for Date_purch 

alter table Customer
add constraint DK_customer_join_date default getdate() for join_date 

alter table Rental
add constraint DK_rental_rental_date default getdate() for Rental_date 

alter table Rental
add constraint DK_rental_due_date default getdate()+2 for Due_date 

-- câu 13:

alter table Movie
add constraint CK_movie check(Rating in('G','PG','R','NC17','NR'))

alter table Rental
add constraint CK_Due_date check(Due_date >= Rental_date)

sp_helpconstraint Movie

-------------------------------------------------------TUẦN 3 - BÀI 3-------------------------------------------

create database QLDuAn
on primary
(name = DuAn_data, filename = 'D:\DuAn_data.mdf',
size = 25mb, maxsize = 40mb, filegrowth = 1mb)
log on
(name = DuAn_log, filename = 'D:\DuAn_log.ldf', 
size = 6mb, maxsize = 8mb , filegrowth = 1mb)

use QLDuan

create table PhongBan
(MaPB char(5) primary key,
TenPB nvarchar(30) not null,
MaTruongPhong char(5))

create table NhanVien
(MaNV char(5) primary key,
HoTen nvarchar(30),
phai nvarchar(9),
ngaySinh date,
maPB char(5) references phongban(maPb),
nhomTruong char(5),
constraint fk_leader foreign key (nhomTruong) references nhanvien(manv))

alter table phongban
add constraint fk_maTruongPhong foreign key(maTruongPhong) references nhanvien(manv)

create table CongViec
(macv char(5) primary key,
tencv nvarchar(30))

create table DuAN
(MaDA char(5) primary key,
tenDA nvarchar(30))

create table NhanVien_DuAN
(mada char(5) references duan(mada),
manv char(5) references nhanvien(manv),
macv char(5)references congviec(macv), 
thoiGian time,
primary key(mada,macv,manv))

