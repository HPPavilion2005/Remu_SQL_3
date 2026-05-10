USE Baitap03
GO

CREATE TABLE KhachHang (

    MaKH INT PRIMARY KEY IDENTITY(1,1),

    HoTen NVARCHAR(100),

    SoDienThoai VARCHAR(15),

    CCCD VARCHAR(20),

    DiaChi NVARCHAR(255)

);

CREATE TABLE HopDong (

    MaHD INT PRIMARY KEY IDENTITY(1,1),

    MaKH INT,

    NgayVay DATE,

    TienGoc DECIMAL(18,2),

    Deadline1 DATE,

    Deadline2 DATE,

    TrangThai NVARCHAR(50),

    FOREIGN KEY (MaKH)
        REFERENCES KhachHang(MaKH)

);

CREATE TABLE TaiSan (

    MaTS INT PRIMARY KEY IDENTITY(1,1),

    TenTaiSan NVARCHAR(100),

    GiaTriDinhGia DECIMAL(18,2),

    TrangThai NVARCHAR(50)

);

CREATE TABLE HopDong_TaiSan (

    MaHD INT,

    MaTS INT,

    PRIMARY KEY (MaHD, MaTS),

    FOREIGN KEY (MaHD)
        REFERENCES HopDong(MaHD),

    FOREIGN KEY (MaTS)
        REFERENCES TaiSan(MaTS)

);

CREATE TABLE ThanhToan (

    MaTT INT PRIMARY KEY IDENTITY(1,1),

    MaHD INT,

    NgayThanhToan DATE,

    SoTienTra DECIMAL(18,2),

    NguoiThu NVARCHAR(100),

    FOREIGN KEY (MaHD)
        REFERENCES HopDong(MaHD)

);

