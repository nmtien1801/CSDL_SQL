-- Cau 1
CREATE DATABASE QLKHAMBENH_NguyenMinhTien
ON PRIMARY
(
NAME=QLKHAMBENH_Data,
FILENAME='T:\NguyenMinhTien\QLKHAMBENH_Data.mdf',
SIZE=10MB,
MAXSIZE=15MB,
FILEGROWTH=20%) 
LOG ON
( 
NAME=QLKHAMBENH_Log,
FILENAME= 'T:\NguyenMinhTien\QLKHAMBENH_Log.ldf',
SIZE=3MB,
MAXSIZE=5MB,
FILEGROWTH=1MB)

use QLKHAMBENH_NguyenMinhTien
--Cau 2
create table DIEUTRI
(
	MaBN char(5),
	MaBS char(5),
	Ngaykham datetime,
	Ngaytaikham datetime,
	Chuandoan nvarchar(225),
	primary key(MaBN,MaBS)
)
alter table DIEUTRI
add constraint CD check (Ngaykham < Ngaytaikham)
ALTER TABLE DIEUTRI WITH CHECK
ADD CONSTRAINT FK1 FOREIGN KEY(MaBN) REFERENCES BENHNHAN(MaBN)
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE DIEUTRI WITH CHECK
ADD CONSTRAINT FK2 FOREIGN KEY(MaBS) REFERENCES BACSI(MaBS)
ON UPDATE CASCADE
ON DELETE CASCADE



create table BENHNHAN
(
	MaBN char(5) primary key,
	Hoten nvarchar(50),
	Namsinh smallint check (Namsinh > 0),
	Phai bit
)
create table BACSI
(
	MaBS char(5) primary key,
	Hoten nvarchar(50),
	Chuyenmon nvarchar(50)
)
--cau 3
INSERT INTO BACSI
VALUES
('1',N'Tuấn',N'Răng'),
('2',N'Vân',N'Tay Chân')

select * from BACSI

INSERT INTO BENHNHAN
VALUES
('BN1',N'Minh','2002',1),
('BN2',N'An','2002',1)

select * from BENHNHAN

INSERT INTO DIEUTRI
VALUES
('BN1','1','2022-08-20','2022-09-20',N'Bình thường'),
('BN2','1','2022-08-20','2022-09-20',N'Bình thường'),
('BN1','2','2022-09-20','2022-10-20',N'Bình thường')

select * from DIEUTRI
--cau 4
UPDATE BACSI
SET Hoten = 'Nguyễn Minh tiến' WHERE Hoten = 'Vân' 
select * from BACSI
--cau 5
DELETE FROM DIEUTRI WHERE MaBS = '1' AND MaBN = 'BN2' AND Ngaykham = '2022-08-20'
--cau 6
ALTER TABLE DIEUTRI WITH CHECK
ADD CONSTRAINT FK1 FOREIGN KEY(MaBN) REFERENCES BENHNHAN(MaBN)
ON UPDATE CASCADE
ON DELETE CASCADE
